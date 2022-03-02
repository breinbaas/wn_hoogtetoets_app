import 'package:flutter/material.dart';
import 'package:height_assessment/layouts/start_pc_layout.dart';
import 'package:height_assessment/layouts/start_mobile_layout.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/services.dart';

Future<List<String>> loadAsset() async {
  //var loadData =  await rootBundle.loadString('assets/files/dijkList.txt');
  //var list = loadData.split(",");
  var loadData = await rootBundle.loadString('assets/files/dijkList.csv');
  var list = loadData.split("\n");
  list.removeWhere((element) => element == '');
  return list;
}

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Widget build(BuildContext context) {
    Future<List<String>> leveeList = loadAsset();
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constrains) {
          if (constrains.maxWidth > 600) {
            return StartPcLayout(
              leveeList: leveeList,
            );
          } else {
            return StartMobileLayout(
              leveeList: leveeList,
            );
          }
        },
      ),
    );
  }
}
