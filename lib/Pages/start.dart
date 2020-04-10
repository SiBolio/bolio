import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smarthome/Componts/SmarthomeCard.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Pages/allAdapterPage.dart';
import 'package:smarthome/Services/favoriteService.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  FavoriteService favoriteService = new FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: FutureBuilder(
          future: favoriteService.getFavorites(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return new CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return new CircularProgressIndicator();
            } else {
              List<FavoriteModel> favorites = snapshot.data ?? [];
              return StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: favorites.length,
                itemBuilder: (BuildContext context, int index) => new Container(
                  child: SmarthomeCard(
                    id: favorites[index].id,
                    title: favorites[index].title,
                    objectType: favorites[index].objectType,
                    tileSize: favorites[index].tileSize,
                  ),
                ),
                staggeredTileBuilder: (int index) {
                  var tileWidth;
                  var tileHeight;
                  if (favorites[index].tileSize == 'S') {
                    tileWidth = 2;
                    tileHeight = 1;
                  } else if (favorites[index].tileSize == 'M') {
                    tileWidth = 2;
                    tileHeight = 2;
                  } else if (favorites[index].tileSize == 'L') {
                    tileWidth = 4;
                    tileHeight = 2;
                  }
                  return new StaggeredTile.count(tileWidth, tileHeight);
                },
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllAdapterPage()),
          ).then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.settings),
      ),
    );
  }
}
