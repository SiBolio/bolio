import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smarthome/Models/adapterModel.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/historyModel.dart';
import 'package:smarthome/Models/objectsModel.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HttpService {
  FavoriteService favoriteService = new FavoriteService();

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

  Future<List<charts.Series<HistoryModel, DateTime>>> getHistory(
      String objectId) async {
    List<HistoryModel> historyList = new List();

    var now = new DateTime.now();
    var yesterday =
        new DateTime(now.year, now.month, now.day - 1, now.hour, now.minute);

    var response = await http.get("http://192.168.178.122:8087/query/" +
        objectId +
        "/?prettyPrint&dateFrom=" +
        yesterday.toString() +
        "&dateTo=" +
        now.toString());

    Iterable l = json.decode(response.body);
    for (var item in l.elementAt(0)['datapoints']) {
      if (item[0] != null) {
        var historyModel = HistoryModel(
            value: item[0].toDouble(),
            timestamp: DateTime.fromMillisecondsSinceEpoch(item[1]));
        historyList.add(historyModel);
      }
    }

    return [
      new charts.Series<HistoryModel, DateTime>(
        id: 'History',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.tealAccent),
        domainFn: (HistoryModel history, _) => history.timestamp,
        measureFn: (HistoryModel history, _) => history.value,
        strokeWidthPxFn: (HistoryModel history, _) => 3,
        data: historyList,
      )
    ];
  }

  clearGetAllAdapters() {
    this._getAllAdapters.clear();
  }

  Future<List> getAdapterObjects(String adapterId, context) async {
    List<FavoriteModel> _favorites =
        await favoriteService.getFavorites(context);
    var response = await http.get(
        "http://192.168.178.122:8087/objects?pattern=" +
            adapterId +
            "*&type=state&prettyPrint");

    Map<String, dynamic> parsedJson = json.decode(response.body);
    List<ObjectsModel> responseList = new List();

    for (var key in parsedJson.keys.toList()) {
      var ioBrokerObject = ObjectsModel.fromJson(parsedJson[key]);
      ioBrokerObject.isfavorite = false;
      for (var favorite in _favorites) {
        if (favorite.id == ioBrokerObject.id) {
          ioBrokerObject.isfavorite = true;
        }
      }
      responseList.add(ioBrokerObject);
    }
    return responseList;
  }

  Future<String> getObjectValue(String objectId) async {
    var response =
        await http.get("http://192.168.178.122:8087/get/" + objectId);
    Map<String, dynamic> parsedJson = json.decode(response.body);
    if (parsedJson['val'] != null) {
      return parsedJson['val'].toString();
    } else {
      return '-';
    }
  }

  setObjectValue(String objectId, String value) {
    http.get("http://192.168.178.122:8087/set/" + objectId + "?value=" + value);
  }
}
