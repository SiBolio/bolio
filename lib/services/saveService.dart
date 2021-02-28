import 'dart:convert';

import 'package:bolio/models/saveModel.dart';
import 'package:bolio/models/singleValueModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveService {
  saveWidget(SaveModel saveModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var json = saveModel.toJson();

    List<String> allFavorites = await getAllFavoritesRaw();

    allFavorites.add(jsonEncode(json));

    // allFavorites.clear();
    prefs.setStringList('favorites', allFavorites);
  }

  deleteWidget(SaveModel saveModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<SaveModel> allFavorites = await getAllFavorites();

    allFavorites.removeWhere((item) => item.uid == saveModel.uid);

    List<String> allFavoritesRaw = [];

    for (var favorite in allFavorites) {
      allFavoritesRaw.add(jsonEncode(favorite));
    }

    prefs.setStringList('favorites', allFavoritesRaw);
  }

  Future<List<SaveModel>> getAllFavorites() async {
    List<String> allFavoritesRaw = await getAllFavoritesRaw();
    List<SaveModel> allFavorites = [];

    for (var favorite in allFavoritesRaw) {
      allFavorites.add(SaveModel.fromJson(jsonDecode(favorite)));
    }

    return allFavorites;
  }

  Future<List<String>> getAllFavoritesRaw() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> allFavoritesRaw = prefs.getStringList('favorites');
    //  allFavoritesRaw.clear();
    if (allFavoritesRaw == null) {
      allFavoritesRaw = [];
    }

    return allFavoritesRaw;
  }
}
