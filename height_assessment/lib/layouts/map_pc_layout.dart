import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import 'package:latlong/latlong.dart';
import 'package:screenshot/screenshot.dart';
import 'package:height_assessment/my_marker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:height_assessment/data_model.dart';
import 'package:tuple/tuple.dart';




class MapPcLayout extends StatefulWidget {
  final String dikeCode;
  final double year;
  Future<List<DataDike>> dikeList;

  MapPcLayout({this.dikeCode, this.year, this.dikeList});

  @override
  _MapPcLayoutState createState() => _MapPcLayoutState(year: year);
}



class _MapPcLayoutState extends State<MapPcLayout> {

  double year = 2021;
  _MapPcLayoutState({this.year});
  MapController _mapController = MapController();

  final PopupController _popupController = PopupController();

  bool _safe = true;
  bool _nodata = true;
  bool _warning = true;
  bool _declined = true;
  bool _greyscale = false;

  var _safe_color = Color(0xFF1EC81D);
  var _warning_color = Color(0xFFDFA50D);
  var _declined_color = Color(0xFFEA1010);
  var _nodata_color = Color(0xFF9E9E9E);


  //variables for making a screenshot
  Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose(){
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    print(widget.dikeCode);

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 1,
            child: Text(
              "+",
              style: TextStyle(fontSize: 25, color: Color(0xFFF9DF68)),
            ),
            onPressed: () {
              if (_mapController.zoom < 18) {
                _mapController.move(
                    _mapController.center, _mapController.zoom + 0.5);
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 2,
            child: Text(
              "-",
              style: TextStyle(fontSize: 25, color: Color(0xFFF9DF68)),
            ),
            onPressed: () {
              _mapController.move(
                  _mapController.center, _mapController.zoom - 0.5);
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: widget.dikeList, //hhttps:/db.getdwars
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget child;

            if (snapshot.hasData) {

              //var for a more responsive webpage, used with MediaQuary...size
              double responsiveWidth;
              double buttonWidth;
              if(MediaQuery.of(context).size.width < 900){
                responsiveWidth = 0.35;
                buttonWidth = 0.7;
              }
              else{
                responsiveWidth = 0.2;
                buttonWidth = 0.5;
              }

              Tuple2<List<Marker>, int> results = setMarkers(year, snapshot.data, _nodata_color, _safe_color, _warning_color, _declined_color, _nodata, _safe, _warning, _declined);

              int middlePoint = (snapshot.data.length / 2).round();

              child = Row(children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * responsiveWidth,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(widget.dikeCode),
                      elevation: 0,
                      bottom: PreferredSize(
                          child: Container(
                            color: Colors.white,
                            height: 2.0,
                          ),
                          preferredSize: Size.fromHeight(4.0)),
                    ),
                    body:
                    ListView(
                      children: [

                        //Data box
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.white, width: 2),)),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Gegevens",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.8,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Voldoet niet:"),
                                          Text(
                                            "${(results.item2 / (snapshot.data.length / 100) ).ceil().round()}%",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Year box
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.white, width: 2)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Jaar",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              ),
                              Text(
                                "$year",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Slider(
                                  value: year,
                                  min: 2021,
                                  max: 2040,
                                  divisions: 2040 - 2021,
                                  onChanged: (value) {
                                    setState(() => { year = value,});
                                  },
                                ),
                              ),
                              FractionallySizedBox(
                                  widthFactor: 0.85,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("2021"),
                                      Text("2040"),
                                    ],
                                  ))
                            ],
                          ),
                        ),

                        //Legend box
                        Container(
                          padding:
                              EdgeInsets.only(bottom: 10, top: 10, left: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 2))),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Legenda",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    //safe checklist
                                    TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.hovered))
                                              return Color(0xFF25274D)
                                                  .withOpacity(0.3);
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Color(0xFF25274D)
                                                  .withOpacity(0.3);
                                            return Color(0xff2E9CCA);
                                          }),
                                        ),
                                        onPressed: () =>{
                                          _popupController.hidePopup(),
                                            setState(() => _safe = !_safe)},
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                value: _safe,
                                                activeColor: Colors.white,
                                                checkColor: Color(0xFF25274D),
                                                onChanged: (bool value) {
                                                  _popupController.hidePopup();
                                                  setState(() {
                                                    _safe = value;
                                                  });
                                                }),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 2, right: 10),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: _safe_color,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Color(0xFF25274D),
                                                    width: 1),
                                              ),
                                            ),
                                            Text("Voldoet",
                                                overflow:  TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        )),

                                    //warning checkbox
                                    TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.hovered))
                                              return Color(0xFF25274D)
                                                  .withOpacity(0.3);
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Color(0xFF25274D)
                                                  .withOpacity(0.3);
                                            return Color(0xff2E9CCA);
                                          }),
                                        ),
                                        onPressed: () => {
                                          _popupController.hidePopup(),
                                            setState(() => _warning = !_warning)},
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                value: _warning,
                                                activeColor: Colors.white,
                                                checkColor: Color(0xFF25274D),
                                                onChanged: (bool value) {
                                                  _popupController.hidePopup();
                                                  setState(() {
                                                    _warning = value;
                                                  });
                                                }),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 2, right: 10),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: _warning_color,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Color(0xFF25274D),
                                                    width: 1),
                                              ),
                                            ),
                                            Text("Bij afkeurgrens",
                                                overflow:  TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        )),

                                    //not safe checkbox
                                    TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.hovered))
                                              return Color(0xFF25274D)
                                                  .withOpacity(0.3);
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Color(0xFF25274D)
                                                  .withOpacity(0.3);
                                            return Color(0xFF2E9CCA);
                                          }),
                                        ),
                                        onPressed: () => {
                                          _popupController.hidePopup(),
                                        setState(
                                            () => _declined = !_declined)},
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                value: _declined,
                                                activeColor: Colors.white,
                                                checkColor: Color(0xFF25274D),
                                                onChanged: (bool value) {
                                                  _popupController.hidePopup();
                                                  setState(() {
                                                    _declined = value;
                                                  });
                                                }),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 2, right: 10),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: _declined_color,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Color(0xFF25274D),
                                                    width: 1),
                                              ),
                                            ),
                                            Text("Voldoet niet",
                                                overflow:  TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        )),
                                    //no data checkbox
                                    TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.hovered))
                                              return Color(0xFF25274D)
                                                  .withOpacity(0.3);
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Color(0xFF25274D)
                                                  .withOpacity(0.3);
                                            return Color(0xFF2E9CCA);
                                          }),
                                        ),
                                        onPressed: () =>{
                                          _popupController.hidePopup(),
                                            setState(() => _nodata = !_nodata)},
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                value: _nodata,
                                                activeColor: Colors.white,
                                                checkColor: Color(0xFF25274D),
                                                onChanged: (bool value) {
                                                  _popupController.hidePopup();
                                                  setState(() {
                                                    _nodata = value;
                                                  });
                                                }),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 2, right: 10),
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: _nodata_color,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Color(0xFF25274D),
                                                    width: 1),
                                              ),
                                            ),
                                            Text("Geen data",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        //Greyscale box
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 2))),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Kleur veranderen",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered))
                                        return Color(0xFF25274D)
                                            .withOpacity(0.3);
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Color(0xFF25274D)
                                            .withOpacity(0.3);
                                      return Color(0xff2E9CCA);
                                    }),
                                  ),
                                  onPressed: () {
                                    //switches the color schemes of the markers
                                    if (!_greyscale) {
                                      setState(() {
                                        _safe_color = Color(0xFFACACAC);
                                        _warning_color = Color(0xFF737373);
                                        _declined_color = Color(0xFF313131);
                                        _nodata_color =  Color(0xFFFFFFFFFF);
                                        _greyscale = !_greyscale;
                                      });
                                    } else {
                                      setState(() {
                                        _safe_color = Color(0xFF1EC81D);
                                        _warning_color = Color(0xFFDFA50D);
                                        _declined_color = Color(0xFFEA1010);
                                        _nodata_color = Color(0xFF9E9E9E);
                                        _greyscale = !_greyscale;
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          value: _greyscale,
                                          activeColor: Colors.white,
                                          checkColor: Color(0xFF25274D),
                                          onChanged: (bool value) {
                                            if (!_greyscale) {
                                              setState(() {
                                                _safe_color = Color(0xFFACACAC);
                                                _warning_color = Color(0xFF737373);
                                                _declined_color = Color(0xFF313131);
                                                _nodata_color =  Color(0xFFFFFFFFFF);
                                                _greyscale = !_greyscale;
                                              });
                                            } else {
                                              setState(() {
                                                _safe_color = Color(0xFF1EC81D);
                                                _warning_color = Color(0xFFDFA50D);
                                                _declined_color = Color(0xFFEA1010);
                                                _nodata_color = Color(0xFF9E9E9E);
                                                _greyscale = !_greyscale;
                                              });
                                            }
                                          }),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          "Grijstinten",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //print button
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                onPressed: () => {
                                  screenshotController
                                      .capture()
                                      .then((Uint8List image) async {
                                    setState(() {
                                      _imageFile = image;
                                    });
                                    //   final result = await ImageGallerySaver.saveImage(_imageFile);
                                    await FileSaver.instance.saveFile(
                                        "screenshot", _imageFile, "png");
                                  }).catchError((onError) {
                                    print(onError);
                                  })
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                          left: 10,
                                          right: 10)),
                                  elevation:
                                      MaterialStateProperty.all<double>(35),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Color(0XFFFFB900);
                                    if (states.contains(MaterialState.hovered))
                                      return Color(0XFFFFB900);
                                    if (states.contains(MaterialState.focused))
                                      return Color(0XFFFFB900);
                                    return Color(0xFFF9DF68);
                                  }),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: 0.7,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Downloadscherm",
                                      overflow:  TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Screenshot(
                    controller: screenshotController,
                    child: Container(
                        width: MediaQuery.of(context).size.width * ( 1 - responsiveWidth),
                        child: FlutterMap(
                          options: MapOptions(
                            onTap: (context) => {
                              _popupController.hidePopup(),
                            },
                            center: new LatLng(
                                snapshot.data[middlePoint].lat, snapshot.data[middlePoint].lon),
                            maxZoom: 18,
                            zoom: 16,
                            plugins: [PopupMarkerPlugin()],
                          ),
                          mapController: _mapController,
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            PopupMarkerLayerOptions(
                                markers: results.item1,
                                popupController: _popupController,
                                popupBuilder:
                                    (BuildContext context, Marker marker) =>
                                        createPopup(marker, snapshot.data, year)),
                          ],
                        ))),
              ]);
            } else if (snapshot.hasError) {
              child = Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Er is iets fout gedaan"),
                      Text("De database kan de dijk code niet vinden"),
                      Text("of er is geen internet verbinding"),
                      SizedBox(height: 20),
                      Text(snapshot.error.toString()),
                    ],
                  ));
            } else {
              child = Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Map wordt geladen...",
                          style: TextStyle(fontSize: 25)),
                    ],
                  ),
                ),
              );
            }
            return Container(
              child: child,
            );
          }),
    );
  }
}
