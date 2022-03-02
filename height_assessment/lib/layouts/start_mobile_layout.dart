import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart';
import 'package:height_assessment/dike_points.dart';
import 'package:height_assessment/layouts/map_mobile_layout.dart';

class StartMobileLayout extends StatefulWidget {
  final Future<List<String>> leveeList;

  StartMobileLayout({this.leveeList});

  _StartMobileLayoutState createState() => _StartMobileLayoutState();
}

class _StartMobileLayoutState extends State<StartMobileLayout> {
  double _year = 2021;
  String _textfieldInput = "";
  bool _inputError = false;
  List _leveeList = [];

  Future<void> readText() async {
    final list = await widget.leveeList;
    // print (list);
    setState(() {
      _leveeList = list;
    });
  }

  @override
  void initState() {
    super.initState();
    readText();
  }

  @override
  Widget build(BuildContext context) {

    double responsiveWidth;
    if(MediaQuery.of(context).size.width < 900){
      responsiveWidth = 0.9;
    }
    else{
      responsiveWidth = 0.7;
    }
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [Color(0xFF25274D), Color(0xFF016670)],
            tileMode: TileMode.repeated,
          )),
      child: Center(
        child: SingleChildScrollView(
          // widthFactor: responsiveWidth,
          child: Column(
            children: [
              //Box for the image
              SizedBox(

                height: MediaQuery.of(context).size.height * 0.35,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF25274D),
                      image: DecorationImage(
                        image: AssetImage("assets/images/dijk_pc.jpg"),
                        colorFilter: ColorFilter.mode(
                            Color(0xFF2E9CCA).withOpacity(0.7),
                            BlendMode.dstATop),
                        fit: BoxFit.cover,
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Image.asset(
                                      "assets/images/white_logo.png",
                                      scale: 4),
                                ),
                                Text(
                                  "Dijk Checker",
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 4,
                                          color: Colors.black,
                                        )
                                      ]),
                                ),
                              ],
                            )),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Selecteer een waterschap",
                              style: TextStyle(shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 4,
                                  color: Colors.black,
                                )
                              ]),
                            ),
                            Text(
                              "Vervolgens kies een dijk",
                              style: TextStyle(shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 4,
                                  color: Colors.black,
                                )
                              ]),
                            ),
                            Text(
                              "En klik op zoek om beeld te krijgen",
                              style: TextStyle(shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 4,
                                  color: Colors.black,
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Box for input
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.65),
                child: Container(
                  color: Color(0xFF2E9CCA),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //First input field
                      /*
                        Container(
                          margin: EdgeInsets.only(bottom: 20, left: 40),
                          child: Column(
                            children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Waterschap",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.7,
                                      child: TextField(
                                      style: TextStyle(fontSize: 18.0, color: Color(0xFF25274D)),
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          filled: true,
                                          hintText: "'Waterschap",
                                          isDense: true,
                                          contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 5),
                                        ),
                                      ),
                                    ),
                                 ),
                              ],
                           )
                        ),
                        */

                      //Second input field
                      Container(
                        margin: EdgeInsets.only(bottom: 50, left: 40),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Dijk code",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: responsiveWidth,
                                child: Container(
                                  child: Autocomplete(
                                    optionsBuilder: (TextEditingValue value) {
                                      return _leveeList.where((item) {
                                        final queryLower =
                                        value.text.toUpperCase();
                                        return item.contains(queryLower);
                                      }).toList();
                                    },
                                    //incase of dictionary, this way you can choice what to print
                                    // displayStringForOption: (Levee levee) => levee.code,

                                    //when you select a ListTile, changed the input
                                    onSelected: (text) {
                                      setState(() {
                                        _inputError = false;
                                        _textfieldInput = text;
                                      });
                                    },
                                    //changes the Textfield input
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController
                                        fieldTextEditingController,
                                        FocusNode fieldFocusNode,
                                        VoidCallback onFieldSubmitted) {
                                      return TextField(
                                        onChanged: (text) {
                                          setState(() {
                                            _textfieldInput = text;
                                            _inputError = false;
                                          });
                                        },
                                        controller: fieldTextEditingController,
                                        focusNode: fieldFocusNode,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                                fontSize: 16, height: 1),
                                            errorText: _inputError
                                                ? "Geen bestaande dijkcode"
                                                : null,
                                            contentPadding:
                                            EdgeInsets.only(left: 5),
                                            hintText: "e.g. A117"),
                                      );
                                    },
                                    //changes the listview from the autocomplete
                                    optionsViewBuilder: (BuildContext context,
                                        AutocompleteOnSelected onSelected,
                                        Iterable options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                            child: Container(
                                                color: Colors.white,
                                                // First the size of half the box - margin and then the widthfactor
                                                width: (MediaQuery.of(context).size.width - 40) * responsiveWidth,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                      int index) {
                                                    final String levee = options
                                                        .elementAt(index);
                                                    //the style for the list elements
                                                    return TextButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero,
                                                              )),
                                                          backgroundColor:
                                                          MaterialStateProperty.resolveWith((Set<MaterialState>states) {
                                                            if (states.contains(MaterialState.hovered))
                                                              return Color(0xFF016670).withOpacity(0.5);
                                                            if (states.contains(MaterialState.pressed))
                                                              return Color(0xFF016670).withOpacity(0.5);
                                                            return Color(0xFFFFFFFF);
                                                          }),
                                                        ),
                                                        onPressed: () {
                                                          onSelected(levee);
                                                        },
                                                        child: ListTile(
                                                          title: Text(levee),
                                                        ));
                                                  },
                                                ))),
                                      );
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Slider input
                      Container(
                          margin: EdgeInsets.only(bottom: 20, left: 40),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Jaar",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: responsiveWidth,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$_year",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: responsiveWidth,
                                  child: Slider(
                                    value: _year,
                                    min: 2021,
                                    max: 2040,
                                    divisions: 2040 - 2021,
                                    onChanged: (value) {
                                      setState(() {
                                        _year = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: responsiveWidth - 0.02,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "2021",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "2040",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),

                      //button
                      Container(
                        child: ElevatedButton(
                          onPressed: () => {
                            if (_leveeList.contains(_textfieldInput.toUpperCase()))
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapMobileLayout(
                                          dikeCode: _textfieldInput,
                                          year: _year,
                                          dikeList:
                                          getRequest(_textfieldInput),
                                        )
                                    )
                                )
                              }
                            else {setState(() {_inputError = true;}),}
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.only(bottom: 15, top: 15)),
                            backgroundColor: MaterialStateProperty.resolveWith(
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
                            widthFactor: 0.3,
                            child: Align(
                              child: Text("zoek",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xFF25274D))),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
