import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smarthome/Models/adapterModel.dart';
import 'package:smarthome/Models/objectsModel.dart';

class HttpService {
  List<AdapterModel> _getAllAdapters = new List();
  Future<List> getAllAdapters() async {
    if (_getAllAdapters.length > 0) {
      return _getAllAdapters;
    } else {
      var response = await http
          .get("http://192.168.178.122:8087/objects?type=adapter&prettyPrint");

      Map<String, dynamic> parsedJson = json.decode(response.body);
      List<AdapterModel> responseList = new List();

      for (var key in parsedJson.keys.toList()) {
        var ioBrokerObject = AdapterModel.fromJson(parsedJson[key]);
        responseList.add(ioBrokerObject);
      }
      _getAllAdapters = responseList;
      return responseList;
    }
  }

  clearGetAllAdapters() {
    this._getAllAdapters.clear();
  }

  Future<List> getAdapterObjects(String adapterId) async {
    var response = await http.get(
        "http://192.168.178.122:8087/objects?pattern=" +
            adapterId +
            "*&type=state&prettyPrint");

    Map<String, dynamic> parsedJson = json.decode(response.body);
    List<ObjectsModel> responseList = new List();

    for (var key in parsedJson.keys.toList()) {
      var ioBrokerObject = ObjectsModel.fromJson(parsedJson[key]);
      responseList.add(ioBrokerObject);
    }
    return responseList;
  }
}
