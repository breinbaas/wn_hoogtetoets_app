import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:height_assessment/data_model.dart';
import 'package:latlong/latlong.dart';
import 'package:tuple/tuple.dart';
import 'package:hovering/hovering.dart';

/* a marker can be used to display points that are
safe = height >= required height
critical = optional for now; height <= height + offset   (with 0.05 meters)
unsafe= height < required height
none = no state
 */

enum MarkerMode { none, safe, critical, unsafe }

var MarkerColors = {
  MarkerMode.none: Colors.grey,
  MarkerMode.safe: Colors.red,
  MarkerMode.critical: Color(0xFF737373),
  MarkerMode.unsafe: Color(0xFF313131)
};

// Changes the colors for the state colors, so it automaticly updates
void changeMarkerColors(Color _none_color, Color _safe_color,
    Color _critical_color, Color _unsafe_color) {
  MarkerColors[MarkerMode.none] = _none_color;
  MarkerColors[MarkerMode.safe] = _safe_color;
  MarkerColors[MarkerMode.critical] = _critical_color;
  MarkerColors[MarkerMode.unsafe] = _unsafe_color;
}

var MarkerGroupVisible = {
  MarkerMode.none: true,
  MarkerMode.safe: true,
  MarkerMode.critical: true,
  MarkerMode.unsafe: true
};

void changeMarkerGroupVisible(bool _none_visibility, bool _safe_visibility,
    bool _critical_visibility, bool _unsafe_visibility) {
  MarkerGroupVisible[MarkerMode.none] = _none_visibility;
  MarkerGroupVisible[MarkerMode.safe] = _safe_visibility;
  MarkerGroupVisible[MarkerMode.critical] = _critical_visibility;
  MarkerGroupVisible[MarkerMode.unsafe] = _unsafe_visibility;
}

//loop through the dike points, while calculating what kinda of markerMode that point needs
//keeps count of all the unsafe points, so it can calculated the % unsafe
Tuple2<List<Marker>, int> setMarkers(
    double year,
    List<DataDike> dikeList,
    Color _none_color,
    Color _safe_color,
    Color _critical_color,
    Color _unsafe_color,
    bool _none_visibility,
    bool _safe_visibility,
    bool _critical_visibility,
    bool _unsafe_visibility){

  //first set all the state variables
  changeMarkerColors(_none_color, _safe_color, _critical_color, _unsafe_color);
  changeMarkerGroupVisible(_none_visibility, _safe_visibility, _critical_visibility, _unsafe_visibility);

  List<Marker> markers = [];
  int countUnsafe = 0;

  dikeList.forEach((dike) {
    MarkerMode markerMode;
    double current_ZAhn = dike.z_ahn4 + ((year - 2021) * dike.bgs);

    if (dike.z_ahn4 == -9999) {
      markerMode = MarkerMode.none;
    } else if (current_ZAhn - dike.z_req < 0.05 && current_ZAhn > dike.z_req) {
      markerMode = MarkerMode.critical;
    } else if (current_ZAhn > dike.z_req) {
      markerMode = MarkerMode.safe;
    } else {
      countUnsafe = countUnsafe + 1;
      markerMode = MarkerMode.unsafe;
    }
    Marker marker = new Marker(
      point: new LatLng(dike.lat, dike.lon),
      //size is important, if these are smaller than the Container of the builder, then it will take these values
      width: 13.0,
      height: 13.0,
      builder: (context) => MyCustomMarker(markerMode: markerMode),
    );
    markers.add(marker);
  });

  return Tuple2(markers, countUnsafe);
}

class MyCustomMarker extends StatefulWidget {
  final bool popupsOn;
  double selectedYear;
  var markerMode;
  final Function setClicked;
  DataDike dike;

  MyCustomMarker(
      {this.markerMode,
      this.popupsOn,
      this.setClicked,
      this.dike,
      this.selectedYear});

  _MyCustomMarkerState createState() => _MyCustomMarkerState();
}

//makes the widget builder
class _MyCustomMarkerState extends State<MyCustomMarker> {
  var markerMode = MarkerMode.none;
  double popupWidth = 250;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Visibility(
            visible: MarkerGroupVisible[widget.markerMode],
            child: Center(
              child: HoverContainer(
                clipBehavior: Clip.none,
                width: 10,
                hoverWidth: 13,
                height: 10,
                hoverHeight: 13,
                cursor: SystemMouseCursors.click,
                decoration: BoxDecoration(
                  color: MarkerColors[widget.markerMode],
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hoverDecoration: BoxDecoration(
                  color: MarkerColors[widget.markerMode].withOpacity(0.8),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
        )
      ],
    );
  }
}

Container createPopup(Marker marker, List<DataDike> list, double selectedYear) {
  var index = list.indexWhere((dike) =>
      dike.lon == marker.point.longitude && dike.lat == marker.point.latitude);
  return Container(
    //transform lowers the popup, so the start is within the marker
    transform: Matrix4.translationValues(0.0, 6.0, 0.0),
    width: 265,
    height: 120,
    padding: EdgeInsets.only(bottom: 40, top: 10, right: 20, left: 20),
    margin: EdgeInsets.only(left: 6),
    child: Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 3,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "hoogte:",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: list[index].z_ahn4 > -1000
                      ? Text((list[index].z_ahn4 + ((selectedYear - 2021) * list[index].bgs)).toStringAsFixed(4) + " m")
                      : Text("n.n.b."),
                )
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Flexible(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Zakking per jaar:"),
              ),
            ),
            Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(list[index].bgs.toStringAsFixed(4) + " m"),
                )
            )
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Flexible(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Veiligheidsgrens:"),
              ),
            ),
            Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(list[index].z_req.toString() + " m"),
                )
            )
          ],
        ),
      ],
    ),
    //image is specially made, so if you want to change the size you need to adjust the image
    decoration: BoxDecoration(
        image: DecorationImage(
      image: AssetImage("assets/images/popup_height.png"),
      fit: BoxFit.cover,
    )),
  );
}

