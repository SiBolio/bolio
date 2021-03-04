import 'dart:convert';
import 'package:bolio/models/adapterModel.dart';
import 'package:bolio/models/historyModel.dart';
import 'package:bolio/models/objectModel.dart';
import 'package:bolio/pages/newWidgetPages/dataPointPage.dart';
import 'package:bolio/widgets/newWidgetStepper.dart';
import 'package:http/http.dart' as http;
import 'package:bolio/services/globals.dart' as globals;

class HttpService {
  Future<List<AdapterModel>> getAllAdapters() async {
    var response = await http.get("http://" +
        globals.ipAddress +
        ':' +
        globals.httpPort +
        "/objects?type=adapter&prettyPrint");

    Map<String, dynamic> parsedJson = json.decode(response.body);
    List<AdapterModel> responseList = [];

    AdapterModel aliasModel = new AdapterModel(
        'alias.0',
        'alias.0',
        'Alias Objekte',
        'Stammordner für Aliase',
        'https://raw.githubusercontent.com/ioBroker/ioBroker.admin/master/admin/admin.png');
    responseList.add(aliasModel);

    AdapterModel userDataModel = new AdapterModel(
        '0_userdata.0',
        '0_userdata.0',
        'Benutzerobjekte',
        'Stammordner für Benutzerobjekte und Dateien',
        'https://raw.githubusercontent.com/ioBroker/ioBroker.admin/master/admin/admin.png');
    responseList.add(userDataModel);

    for (var key in parsedJson.keys.toList()) {
      var ioBrokerObject = AdapterModel.fromJson(parsedJson[key]);
      responseList.add(ioBrokerObject);
    }

    return responseList;
  }

  Future<String> getObjectValue(String id) async {
    var response = await http.get(
        "http://" + globals.ipAddress + ':' + globals.httpPort + "/get/" + id);
    Map<String, dynamic> parsedJson = json.decode(response.body);

    return parsedJson['val'].toString();
  }

  Future<List<ObjectsModel>> getAdapterObjects(String adapterId) async {
    List<ObjectsModel> responseList = [];

    var response = await http.get("http://" +
        globals.ipAddress +
        ':' +
        globals.httpPort +
        "/objects?pattern=" +
        adapterId +
        "*&type=device&prettyPrint");

    Map<String, dynamic> parsedJson = json.decode(response.body);

    for (var key in parsedJson.keys.toList()) {
      var ioBrokerObject = ObjectsModel.fromJson(parsedJson[key]);
      responseList.add(ioBrokerObject);
    }

    response = await http.get("http://" +
        globals.ipAddress +
        ':' +
        globals.httpPort +
        "/objects?pattern=" +
        adapterId +
        "*&type=state&prettyPrint");

    parsedJson = json.decode(response.body);

    for (var key in parsedJson.keys.toList()) {
      var ioBrokerObject = ObjectsModel.fromJson(parsedJson[key]);
      responseList.add(ioBrokerObject);
    }

    response = await http.get("http://" +
        globals.ipAddress +
        ':' +
        globals.httpPort +
        "/objects?pattern=" +
        adapterId +
        "*&type=channel&prettyPrint");

    parsedJson = json.decode(response.body);

    for (var key in parsedJson.keys.toList()) {
      var ioBrokerObject = ObjectsModel.fromJson(parsedJson[key]);
      responseList.add(ioBrokerObject);
    }

    return responseList;
  }

  Future<List<HistoryModel>> getHistory(String objectId) async {
    List<HistoryModel> historyList = new List();

    DateTime now = new DateTime.now();
    DateTime from = now.subtract(Duration(days: 1));

    objectId = objectId.replaceAll('#', '%23');
    var response = await http.get("http://" +
        globals.ipAddress +
        ':' +
        globals.httpPort +
        "/query/" +
        objectId +
        "/?prettyPrint&dateFrom=" +
        from.toString() +
        "&dateTo=" +
        now.toString());

    Iterable l = json.decode(response.body);
    for (var item in l.elementAt(0)['datapoints']) {
      if (item[0] != null) {
        var historyModel = HistoryModel(
          DateTime.fromMillisecondsSinceEpoch(item[1]),
          item[0].toDouble(),
        );
        historyList.add(historyModel);
      }
    }
    return historyList;
  }
}
