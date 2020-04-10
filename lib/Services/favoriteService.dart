import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/objectsModel.dart';

class FavoriteService {
  addObjectToFavorites(ObjectsModel object, context) async {
    List<FavoriteModel> favorites = await getFavorites(context);
    FavoriteModel favorite = new FavoriteModel(
        id: object.id,
        title: object.name,
        tileSize: 'S',
        objectType: 'Einzelwert');
    favorites.add(favorite);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_encodeFavorites(favorites)));
  }

  addFavoriteToFavorites(FavoriteModel favorite, context) async {
    List<FavoriteModel> favorites = await getFavorites(context);
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
    for (var favorite in List.from(favorites)) {
      if (favorite.id == id) {
        favorites.remove(favorite);
      }
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_encodeFavorites(favorites)));
  }

  updateFavorite(String id, String title, String tileSize, String objectType,
      context) async {
    List<FavoriteModel> favorites = await getFavorites(context);
    for (var favorite in favorites) {
      if (favorite.id == id) {
        favorite.setTitle(title);
        favorite.setTileSize(tileSize);
        favorite.setObjectType(objectType);
      }
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_encodeFavorites(favorites)));
  }
}
