import 'package:flutter/material.dart';
import 'package:height_assessment/layouts/map_pc_layout.dart';

class MapPage extends StatefulWidget{
  MapPage({Key key}) : super(key: key);

    _MapPcState createState() => _MapPcState();
}

class _MapPcState extends State<MapPage>{
  @override
    Widget build(BuildContext context){
        return Scaffold(
            body: LayoutBuilder(
                builder: (context, constraints){
                    if(constraints.maxWidth > 600){
                        return MapPcLayout();
                    }
                    else {
                        return Text("Mobile");
                    }
                }
            )
        );
    }
}