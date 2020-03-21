import 'dart:convert';
import 'dart:js';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/objectsModel.dart';

class FavoriteService {
  addObjectToFavorite(ObjectsModel object) async {
//TODO
  }

  _loadFavoritesFromFile(context) async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/favorites.json");
    final jsonResult = json.decode(data);
  }

  List<FavoriteModel> getFavorites(BuildContext context) {
    _loadFavoritesFromFile(context);
  }
}
