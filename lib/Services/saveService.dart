import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/objectsModel.dart';

class SaveService {
  addObjectToFavorite(ObjectsModel object) async {
//TODO
  }

  saveIpAddress(String ipAddress) async {
    var _prefs = await SharedPreferences.getInstance();
    _prefs.setString('ipAddress', ipAddress);
  }

  Future<String> getIpAddress() async {
    var _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('ipAddress');
  }
}
