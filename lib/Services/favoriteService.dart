import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/objectsModel.dart';
import 'package:smarthome/Models/pageModel.dart';

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
        objectType: objectType,
        sliderMin: object.sliderMin,
        sliderMax: object.sliderMax);
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

  addPageToPages(PageModel page, context) async {
    List<PageModel> pages = await getPages(context);
    pages.add(page);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('pages', jsonEncode(_encodePages(pages)));
  }

  Future<List<PageModel>> getPages(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('pages');
    List<PageModel> _pages = new List();
    if (data == null) {
      _pages = new List();
    } else {
      for (Map i in json.decode(data)) {
        _pages.add(PageModel.fromJson(i));
      }
    }
    return _pages;
  }

  Future<List<FavoriteModel>> getFavorites(BuildContext context,
      [String pageId]) async {
    var prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('favorites');
    List<FavoriteModel> _favorites = new List();
    if (data == null) {
      _favorites = new List();
    } else {
      for (Map i in json.decode(data)) {
        if (pageId == null) {
          _favorites.add(FavoriteModel.fromJson(i));
        } else {
          var _tempFavorite = FavoriteModel.fromJson(i);
          if (_tempFavorite.pageId == pageId) {
            _favorites.add(_tempFavorite);
          }
        }
      }
    }
    return _favorites;
  }

  List _encodeFavorites(List<FavoriteModel> favorites) {
    List jsonList = List();
    favorites.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  List _encodePages(List<PageModel> pages) {
    List jsonList = List();
    pages.map((item) => jsonList.add(item.toJson())).toList();
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

  removePageFromPages(String id, context) async {
    List<PageModel> pages = await getPages(context);
    for (var page in List.from(pages)) {
      if (page.id == id) {
        pages.remove(page);
      }
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('pages', jsonEncode(_encodePages(pages)));

    getFavorites(context).then(
      (favorites) => {
        for (var favorite in favorites)
          {
            if (favorite.pageId == id)
              {
                updateFavorite(
                    favorite.id,
                    favorite.title,
                    favorite.tileSize,
                    favorite.objectType,
                    favorite.timeSpan,
                    favorite.setPointMin != null
                        ? favorite.setPointMin.toString()
                        : null,
                    favorite.setPointMax != null
                        ? favorite.setPointMax.toString()
                        : null,
                    null,
                    favorite.secured,
                    context)
              }
          }
      },
    );
  }

  updatePage(PageModel pageToUpdate, context) async {
    List<PageModel> pages = await getPages(context);
    for (PageModel page in pages) {
      if (page.id == pageToUpdate.id) {
        page.setIcon(pageToUpdate.icon);
        page.setTite(pageToUpdate.title);
      }
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('pages', jsonEncode(_encodePages(pages)));
  }

  updateFavorite(
    String id,
    String title,
    String tileSize,
    String objectType,
    String timeSpan,
    String setPointMin,
    String setPointMax,
    String pageId,
    bool secured,
    context,
  ) async {
    if (timeSpan == null) {
      timeSpan = '24 Stunden';
    }
    List<FavoriteModel> favorites = await getFavorites(context);
    for (FavoriteModel favorite in favorites) {
      if (favorite.id == id) {
        favorite.setTitle(title);
        favorite.setTileSize(tileSize);
        favorite.setObjectType(objectType);
        favorite.setTimeSpan(timeSpan);
        favorite.setSetPointMin(setPointMin);
        favorite.setSetPointMax(setPointMax);
        favorite.setPageId(pageId);
        favorite.setSecured(secured);
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
