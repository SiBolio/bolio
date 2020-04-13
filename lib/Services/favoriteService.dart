import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/objectsModel.dart';

class FavoriteService {
  addObjectToFavorites(ObjectsModel object, context) async {
    List<FavoriteModel> favorites = await getFavorites(context);

    var objectType;
    if (object.type == 'boolean') {
      objectType = 'On/Off Button';
    } else {
      objectType = 'Einzelwert';
    }

    FavoriteModel favorite = new FavoriteModel(
        id: object.id,
        title: object.name,
        tileSize: 'S',
        objectType: objectType);
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
      String timeSpan, context) async {
    if (timeSpan == null) {
      timeSpan = '24 Stunden';
    }
    List<FavoriteModel> favorites = await getFavorites(context);
    for (var favorite in favorites) {
      if (favorite.id == id) {
        favorite.setTitle(title);
        favorite.setTileSize(tileSize);
        favorite.setObjectType(objectType);
        favorite.setTimeSpan(timeSpan);
      }
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_encodeFavorites(favorites)));
  }

  reorderFavorites(oldIndex, newIndex, context) async {
    List<FavoriteModel> favorites = await getFavorites(context);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    var tempItem = favorites.removeAt(oldIndex);
    favorites.insert(newIndex, tempItem);

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(_encodeFavorites(favorites)));
  }
}
