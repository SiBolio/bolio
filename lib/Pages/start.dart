import 'package:flutter/material.dart';
import 'package:smarthome/Componts/SmarthomeCard.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Pages/allAdapterPage.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'settingsPage.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  FavoriteService favoriteService = new FavoriteService();

  _getSmarthomeCards(List<FavoriteModel> favorites) {
    List<SmarthomeCard> smarthomeCards = new List();
    for (var favorite in favorites) {
      smarthomeCards.add(new SmarthomeCard(id: favorite.id, title: favorite.title));
    }
    return smarthomeCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smarthome'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: FutureBuilder(
          future: favoriteService.getFavorites(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return new CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return new CircularProgressIndicator();
            } else {
              List<FavoriteModel> favorites = snapshot.data ?? [];
              return GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: _getSmarthomeCards(favorites),
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
          );
        },
        child: Icon(Icons.create),
      ),
    );
  }
}
