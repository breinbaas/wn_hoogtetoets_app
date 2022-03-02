import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong/latlong.dart';
import 'package:screenshot/screenshot.dart';
import 'package:height_assessment/my_marker.dart';
import 'package:height_assessment/data_model.dart';
import 'package:tuple/tuple.dart';

class FilterLayout extends StatefulWidget {
  var safe_color;
  var warning_color;
  var declined_color;
  var nodata_color;

  bool safe;
  bool warning;
  bool declined;
  bool nodata;
  bool greyscale;

  Function changeSafe;
  Function changeWarning;
  Function changeDeclined;
  Function changeNoData;
  Function switchGreyscale;

  FilterLayout({
    this.safe_color,
    this.warning_color,
    this.declined_color,
    this.nodata_color,
    this.safe,
    this.warning,
    this.declined,
    this.nodata,
    this.greyscale,
    this.changeSafe,
    this.changeWarning,
    this.changeDeclined,
    this.changeNoData,
    this.switchGreyscale,
  });

  @override
  _FilterLayoutState createState() => _FilterLayoutState(
    safe_color: safe_color,
      warning_color: warning_color,
      declined_color: declined_color,
      nodata_color: nodata_color,
      safe: safe,
      warning: warning,
      declined: declined,
      nodata: nodata,
      greyscale: greyscale,
  );
}

class _FilterLayoutState extends State<FilterLayout> {

  var safe_color;
  var warning_color;
  var declined_color;
  var nodata_color;

  bool safe;
  bool warning;
  bool declined;
  bool nodata;
  bool greyscale;

  void greyscaleFilter(){
    if (!greyscale) {
      setState(() {
        safe_color = Color(0xFFACACAC);
        warning_color = Color(0xFF737373);
        declined_color = Color(0xFF313131);
        nodata_color =  Color(0xFFFFFFFFFF);
        greyscale = !greyscale;
      });
    } else {
      setState(() {
        safe_color = Color(0xFF1EC81D);
        warning_color = Color(0xFFDFA50D);
        declined_color = Color(0xFFEA1010);
        nodata_color = Color(0xFF9E9E9E);
        greyscale = !greyscale;
      });
    }
  }

  _FilterLayoutState({
    this.safe_color,
    this.warning_color,
    this.declined_color,
    this.nodata_color,
    this.safe,
    this.warning,
    this.declined,
    this.nodata,
    this.greyscale,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
      ),
      body: Column(
        children: [
          //Legend box
          Container(
            padding: EdgeInsets.only(bottom: 10, top: 10, left: 10),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.white, width: 2))),
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
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Color(0xFF25274D).withOpacity(0.3);
                              if (states.contains(MaterialState.pressed))
                                return Color(0xFF25274D).withOpacity(0.3);
                              return Color(0xff2E9CCA);
                            }),
                          ),
                          onPressed: () {
                            setState(() {
                              safe = !safe;
                            });
                            widget.changeSafe();
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                  value: safe,
                                  activeColor: Colors.white,
                                  checkColor: Color(0xFF25274D),
                                  onChanged: (bool value) {
                                    setState(() {
                                      safe = !safe;
                                    });
                                    widget.changeSafe();
                                  }),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 2,
                                  right: 10,
                                ),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: safe_color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFF25274D),
                                    width: 1,
                                  ),
                                ),
                              ),
                              Text(
                                "Voldoet",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),

                      //warning checkbox
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Color(0xFF25274D).withOpacity(0.3);
                              if (states.contains(MaterialState.pressed))
                                return Color(0xFF25274D).withOpacity(0.3);
                              return Color(0xff2E9CCA);
                            }),
                          ),
                          onPressed: () => {
                            setState(() {
                            warning = !warning;
                            }),
                            widget.changeWarning(),
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: warning,
                                activeColor: Colors.white,
                                checkColor: Color(0xFF25274D),
                                onChanged: (bool value) => {
                                  setState(() {
                                    warning = !warning;
                                  }),
                                  widget.changeWarning(),
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 2, right: 10),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: warning_color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFF25274D),
                                    width: 1,
                                  ),
                                ),
                              ),
                              Text("Bij afkeurgrens",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white)),
                            ],
                          )),

                      //not safe checkbox
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Color(0xFF25274D).withOpacity(0.3);
                              if (states.contains(MaterialState.pressed))
                                return Color(0xFF25274D).withOpacity(0.3);
                              return Color(0xFF2E9CCA);
                            }),
                          ),
                          onPressed: () => {
                            setState(() {
                              declined = !declined;
                            }),
                            widget.changeDeclined(),
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                  value: declined,
                                  activeColor: Colors.white,
                                  checkColor: Color(0xFF25274D),
                                  onChanged: (bool value) => {
                                    setState(() {
                                      declined = !declined;
                                    }),
                                    widget.changeDeclined(),
                                  }),
                              Container(
                                margin: EdgeInsets.only(left: 2, right: 10),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: declined_color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFF25274D),
                                    width: 1,
                                  ),
                                ),
                              ),
                              Text(
                                "Voldoet niet",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                      //no data checkbox
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Color(0xFF25274D).withOpacity(0.3);
                              if (states.contains(MaterialState.pressed))
                                return Color(0xFF25274D).withOpacity(0.3);
                              return Color(0xFF2E9CCA);
                            }),
                          ),
                          onPressed: () => {
                            setState(() {
                              nodata = !nodata;
                            }),
                            widget.changeNoData(),
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                  value: nodata,
                                  activeColor: Colors.white,
                                  checkColor: Color(0xFF25274D),
                                  onChanged: (bool value) => {
                                    setState(() {
                                      nodata = !nodata;
                                    }),
                                    widget.changeNoData(),
                                  }),
                              Container(
                                margin: EdgeInsets.only(left: 2, right: 10),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: nodata_color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFF25274D),
                                    width: 1,
                                  ),
                                ),
                              ),
                              Text(
                                "Geen data",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),

          //greyBox
          Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.white, width: 2))),
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
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered))
                          return Color(0xFF25274D).withOpacity(0.3);
                        if (states.contains(MaterialState.pressed))
                          return Color(0xFF25274D).withOpacity(0.3);
                        return Color(0xff2E9CCA);
                      }),
                    ),
                    onPressed: () => {
                      widget.switchGreyscale(),
                      greyscaleFilter(),
                    },
                    child: Row(
                      children: [
                        Checkbox(
                            value: greyscale,
                            activeColor: Colors.white,
                            checkColor: Color(0xFF25274D),
                            onChanged: (bool value) => {
                              widget.switchGreyscale(),
                              greyscaleFilter(),
                            }),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            "Greyscale",
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
        ],
      ),
    );
  }
}
