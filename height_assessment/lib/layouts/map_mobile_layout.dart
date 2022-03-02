import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong/latlong.dart';
import 'package:height_assessment/my_marker.dart';
import 'package:height_assessment/data_model.dart';
import 'package:tuple/tuple.dart';
import 'package:height_assessment/layouts/mobile_filter_layout.dart';

class MapMobileLayout extends StatefulWidget {
  final String dikeCode;
  final double year;
  Future<List<DataDike>> dikeList;

  MapMobileLayout({this.dikeCode, this.year, this.dikeList});

  @override
  _MapMobileLayoutState createState() => _MapMobileLayoutState(year: year);
}

class _MapMobileLayoutState extends State<MapMobileLayout> {
  double year = 2021;

  _MapMobileLayoutState({this.year});

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

  void changeSafe(){
    _popupController.hidePopup();
    setState(() {
      _safe = !_safe;
    });
  }

  void changeWarning(){
    _popupController.hidePopup();
    setState(() {
      _warning = !_warning;
    });
  }

  void changeDeclined(){
    _popupController.hidePopup();
    setState(() {
      _declined = !_declined;
    });
  }

  void changeNodata(){
    _popupController.hidePopup();
    setState(() {
      _nodata = !_nodata;
    });
  }

  void switchGreyScale(){
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Creates two button in the corner of the screen
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
          future: widget.dikeList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget child;

            if (snapshot.hasData) {
              Tuple2<List<Marker>, int> results = setMarkers(
                  year,
                  snapshot.data,
                  _nodata_color,
                  _safe_color,
                  _warning_color,
                  _declined_color,
                  _nodata,
                  _safe,
                  _warning,
                  _declined);
              int middlePoint = (snapshot.data.length / 2).round();

              child = Scaffold(
                appBar: AppBar(
                  title: Text("Dijktraject: ${widget.dikeCode}"),
                  elevation: 0,
                  //TODO change to icon
                  actions: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FilterLayout(
                                  safe_color: _safe_color,
                                  warning_color: _warning_color,
                                  declined_color: _declined_color,
                                  nodata_color: _nodata_color,
                                  safe: _safe,
                                  warning: _warning,
                                  declined: _declined,
                                  nodata: _nodata,
                                  greyscale: _greyscale,
                                  changeSafe: changeSafe,
                                  changeWarning: changeWarning,
                                  changeDeclined: changeDeclined,
                                  changeNoData: changeNodata,
                                  switchGreyscale: switchGreyScale,
                                    ),
                            )
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/images/filter-icon.png",
                        width: 35,
                        fit: BoxFit.cover,),
                      ),
                    )
                  ],
                  bottom: PreferredSize(
                      child: Container(
                        color: Colors.white,
                        height: 2.0,
                      ),
                      preferredSize: Size.fromHeight(4.0)),
                ),

                body: Column(children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 2,)),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 2),
                                child: Align(
                                  alignment: Alignment(-0.9, 0),
                                  child: Text(
                                    "Jaar: ",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${year.toStringAsFixed(0)}",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("2021"),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: Slider(
                                    value: year,
                                    min: 2021,
                                    max: 2040,
                                    divisions: 2040 - 2021,
                                    onChanged: (value) {
                                      setState(() => {
                                        year = value,
                                      });
                                    },
                                  ),
                                ),
                                Text("2040"),
                              ],
                            )),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Voldoet niet: ", style: TextStyle(fontSize: 18),),
                            SizedBox(width: 20),
                            Text("${(results.item2 / (snapshot.data.length / 100) ).ceil().round()}%", style: TextStyle(fontSize: 18),),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: FlutterMap(
                        options: MapOptions(
                          onTap: (context) => {
                            _popupController.hidePopup(),
                          },
                          center: new LatLng(snapshot.data[middlePoint].lat,
                              snapshot.data[middlePoint].lon),
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
                      )),
                ]),
              );
            } else if (snapshot.hasError) {
              child = Container(
                  width: MediaQuery.of(context).size.width,
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
