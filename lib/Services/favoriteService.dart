import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/objectsModel.dart';

class FavoriteService {
  addObjectToFavorite(ObjectsModel object, context) async {
    List<FavoriteModel> favorites = await getFavorites(context);
    FavoriteModel favorite =
        new FavoriteModel(id: object.id, title: object.name);
    favorites.add(favorite);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_encodeFavorites(favorites)));
  }

  Future<List<FavoriteModel>> getFavorites(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('favorites');
    List<FavoriteModel> _favorites = new List();
    if (data == null) {
      _favorites = new List();
    } else {
      for (Map i in json.decode(data)) {
        _favorites.add(FavoriteModel.fromJson(i));
      }
    }
    return _favorites;
  }

  List _encodeFavorites(List<FavoriteModel> favorites) {
    List jsonList = List();
    favorites.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  removeObjectFromFavorites(String id, context) async {
    List<FavoriteModel> favorites = await getFavorites(context);
    for (var favorite in favorites) {
      if (favorite.id == id) {
        favorites.remove(favorite);
      }
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_encodeFavorites(favorites)));
  }
}
