import 'package:flutter/material.dart';import 'package:flutter_map/flutter_map.dart';
import 'package:height_assessment/data_model.dart';

class Popup extends StatefulWidget {
  final Marker marker;
  List<DataDike> dikeList;
  Popup(this.marker, this.dikeList, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopupState(this.marker);
}

class _PopupState extends State<Popup> {
  final Marker _marker;

  final List<IconData> _icons = [
    Icons.star_border,
    Icons.star_half,
    Icons.star
  ];
  int _currentIcon = 0;

  _PopupState(this._marker);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
        onTap: () =>
            setState(() {
              _currentIcon = (_currentIcon + 1) % _icons.length;
            }),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    print("card");
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2E9CCA),
      ),
      padding:  EdgeInsets.all(10),
      child: Container(

        constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Popup for a marker!",
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              "Position: ${_marker.point.latitude}, ${_marker.point.longitude}",
              style: TextStyle(fontSize: 12.0),
            ),
            Text(
              "Marker size: ${_marker.builder.toString()}",
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}