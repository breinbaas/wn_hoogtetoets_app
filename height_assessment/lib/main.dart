import 'package:flutter/material.dart';
import 'package:height_assessment/screens/map_page.dart';
import 'package:height_assessment/screens/start_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waternet hoogtetoets app',

      //Edit all "standard" styles so it can be used everywhere
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF25274D),
          hoverElevation: 10.0,
          elevation: 10.0,
          hoverColor: Color(0xFf2E9CCA).withOpacity(0.5),
          focusColor: Color(0xFf2E9CCA).withOpacity(0.5),
        ),
        sliderTheme: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.white,
          inactiveTickMarkColor: Colors.white,
          activeTickMarkColor: Colors.white,
          trackHeight: 6.0,
          inactiveTrackColor: Colors.white,
          thumbColor: Color(0xFFF9DF68),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
          overlayColor: Colors.black.withAlpha(32),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
        ),
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF2E9CCA),
        accentColor: Colors.white,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 21.0, color: Colors.white),
          bodyText2: TextStyle(fontSize: 16.0, color: Colors.white),
          headline2: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        fontFamily: 'sans serif',
        canvasColor: Color(0xFF2E9CCA),
      ),
      routes: {
        '/': (context) => StartPage(),
        '/map': (context) => MapPage(),
      },
    );
  }
}
