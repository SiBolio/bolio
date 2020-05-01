import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smarthome/Componts/SmarthomeCard.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Pages/allAdapterPage.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'package:smarthome/Services/settingsService.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  FavoriteService favoriteService = new FavoriteService();
  SettingsService settingsService = new SettingsService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: settingsService.getIpAddress_Port(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return WillPopScope(
            onWillPop: () {
              SystemNavigator.pop();
            },
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                child: RefreshIndicator(
                  onRefresh: _refreshPage,
                  child: FutureBuilder(
                    future: favoriteService.getFavorites(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return new CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return new CircularProgressIndicator();
                      } else {
                        List<FavoriteModel> favorites = snapshot.data ?? [];
                        if (favorites.length == 0) {
                          return Center(
                            child: Text(
                              'Wechseln sie in die Einstellungen um Favoriten anzulegen.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          );
                        } else {
                          return StaggeredGridView.countBuilder(
                            crossAxisCount: _getCrossAxisCount(),
                            itemCount: favorites.length,
                            itemBuilder: (BuildContext context, int index) =>
                                new Container(
                              child: SmarthomeCard(
                                id: favorites[index].id,
                                title: favorites[index].title,
                                objectType: favorites[index].objectType,
                                tileSize: favorites[index].tileSize,
                                timeSpan: favorites[index].timeSpan,
                                sliderMin: favorites[index].sliderMin,
                                sliderMax: favorites[index].sliderMax,
                                setPointMin: favorites[index].setPointMin,
                                setPointMax: favorites[index].setPointMax,
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
                              return new StaggeredTile.count(
                                  tileWidth, tileHeight);
                            },
                            mainAxisSpacing: 2.0,
                            crossAxisSpacing: 2.0,
                          );
                        }
                      }
                    },
                  ),
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
            ),
          );
        } else {
          TextEditingController ipController = new TextEditingController();
          ipController.text = '192.168.178.122';
          TextEditingController portController = new TextEditingController();
          portController.text = '8087';

          return Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SafeArea(
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/logo.png'),
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        'Einstellungen',
                        style: new TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: ipController,
                      decoration: InputDecoration(labelText: 'IP Adresse'),
                    ),
                    TextFormField(
                      controller: portController,
                      decoration: InputDecoration(labelText: 'simpleAPI Port'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        color: Colors.tealAccent,
                        child: const Text('Speichern',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        onPressed: () {
                          setState(
                            () {
                              settingsService.setIpAddress(ipController.text);
                              settingsService.setPort(portController.text);
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<Null> _refreshPage() async {
    setState(() {});
  }

  _getCrossAxisCount() {
    int axisCount;
    double width = MediaQuery.of(context).size.width;
    if (width > 1300) {
      axisCount = 10;
    } else if (width > 1000) {
      axisCount = 8;
    } else if (width > 600) {
      axisCount = 6;
    } else {
      axisCount = 4;
    }
    return axisCount;
  }
}
