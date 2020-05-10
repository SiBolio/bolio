import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smarthome/Models/adapterModel.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/historyModel.dart';
import 'package:smarthome/Models/ipAddressModel.dart';
import 'package:smarthome/Models/objectsModel.dart';
import 'package:smarthome/Services/colorsService.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smarthome/Services/settingsService.dart';

class HttpService {
  FavoriteService favoriteService = new FavoriteService();
  SettingsService settingsService = new SettingsService();
  List<AdapterModel> _getAllAdapters = new List();

  Future<List> getAllAdapters() async {
    if (_getAllAdapters.length > 0) {
      return _getAllAdapters;
    } else {
      IpAddressModel ipPort = await settingsService.getIpAddressPort();
      var response = await http.get("http://" +
          ipPort.ipAddress +
          ':' +
          ipPort.portSimpleAPI +
          "/objects?type=adapter&prettyPrint");

      Map<String, dynamic> parsedJson = json.decode(response.body);
      List<AdapterModel> responseList = new List();

      AdapterModel aliasModel = new AdapterModel(
          name: 'alias.0',
          id: 'alias.0',
          title: 'Alias Objekte',
          iconUrl:
              'https://raw.githubusercontent.com/ioBroker/ioBroker.admin/master/admin/admin.png',
          desc: 'Stammordner für Aliase');
      responseList.add(aliasModel);

      AdapterModel userDataModel = new AdapterModel(
          name: '0_userdata.0',
          id: '0_userdata.0',
          title: 'Benutzerobjekte',
          iconUrl:
              'https://raw.githubusercontent.com/ioBroker/ioBroker.admin/master/admin/admin.png',
          desc: 'Stammordner für Benutzerobjekte und Dateien');
      responseList.add(userDataModel);

      for (var key in parsedJson.keys.toList()) {
        var ioBrokerObject = AdapterModel.fromJson(parsedJson[key]);
        responseList.add(ioBrokerObject);
      }

      _getAllAdapters = responseList;
      return responseList;
    }
  }

  Future<List<charts.Series<HistoryModel, DateTime>>> getHistory(
      String objectId,
      String timeSpan,
      double setPointMin,
      double setPointMax) async {
    List<HistoryModel> historyList = new List();

    var now = new DateTime.now();
    var from;
    if (timeSpan == '24 Stunden') {
      from =
          new DateTime(now.year, now.month, now.day - 1, now.hour, now.minute);
    } else if (timeSpan == '7 Tage') {
      from =
          new DateTime(now.year, now.month, now.day - 7, now.hour, now.minute);
    } else if (timeSpan == '30 Tage') {
      from =
          new DateTime(now.year, now.month - 1, now.day, now.hour, now.minute);
    }

    IpAddressModel ipPort = await settingsService.getIpAddressPort();

    var response = await http.get("http://" +
        ipPort.ipAddress +
        ':' +
        ipPort.portSimpleAPI +
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
            value: item[0].toDouble(),
            timestamp: DateTime.fromMillisecondsSinceEpoch(item[1]));
        historyList.add(historyModel);
      }
    }

    return [
      new charts.Series<HistoryModel, DateTime>(
        id: 'History',
        colorFn: (HistoryModel history, __) {
          if (setPointMin != null) {
            if (setPointMin > history.value) {
              return charts.ColorUtil.fromDartColor(BolioColors.dangerLine);
            }
          }
          if (setPointMax != null) {
            if (setPointMax < history.value) {
              return charts.ColorUtil.fromDartColor(BolioColors.dangerLine);
            }
          }

          return charts.ColorUtil.fromDartColor( BolioColors.primary);
        },
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

    IpAddressModel ipPort = await settingsService.getIpAddressPort();
    var response = await http.get("http://" +
        ipPort.ipAddress +
        ':' +
        ipPort.portSimpleAPI +
        "/objects?pattern=" +
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
    IpAddressModel ipPort = await settingsService.getIpAddressPort();
    var response = await http.get("http://" +
        ipPort.ipAddress +
        ':' +
        ipPort.portSimpleAPI +
        "/get/" +
        objectId);
    Map<String, dynamic> parsedJson = json.decode(response.body);
    if (parsedJson['val'] != null) {
      return parsedJson['val'].toString();
    } else {
      return '-';
    }
  }

  setObjectValue(String objectId, String value) async {
    IpAddressModel ipPort = await settingsService.getIpAddressPort();
    http.get("http://" +
        ipPort.ipAddress +
        ':' +
        ipPort.portSimpleAPI +
        "/set/" +
        objectId +
        "?value=" +
        value);
  }
}
