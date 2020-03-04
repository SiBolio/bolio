import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/objectsModel.dart';

class SaveService {
  addObjectToFavorite(ObjectsModel object) async {
    FavoriteModel favorite =
        new FavoriteModel(title: object.name, id: object.id);
    var _prefs = await SharedPreferences.getInstance();
    _prefs.setString('1', json.encode(favorite.toJson()));

//////////////////////////
    var x = _prefs.getString('1');
    var y = FavoriteModel.fromJson(json.decode(x));
    print(y.id);
//////////////////////////
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
