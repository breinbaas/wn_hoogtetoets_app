import 'package:flutter/services.dart' show rootBundle;
import 'package:height_assessment/data_model.dart';

Future<List<DataDike>> getRequest(String dtcode) async {
  var bgsData = await rootBundle.loadString('assets/files/bgsdata.csv');
  var bgsList = bgsData.split("\n");

  List<DataDike> allData = [];
  for (var bgs in bgsList) {
    var args = bgs.split(',');
    if (args[0] == dtcode) {
      DataDike data_dike = DataDike(
        lat: double.parse(args[2]),
        lon: double.parse(args[1]),
        z_ahn4: double.parse(args[3]),
        bgs: double.parse(args[4]),
        z_req: double.parse(args[5]),
      );
      allData.add(data_dike);
    }
  }
  return allData;
}
