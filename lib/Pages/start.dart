import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smarthome/Componts/SmarthomeCard.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/ipAddressModel.dart';
import 'package:smarthome/Models/pageModel.dart';
import 'package:smarthome/Pages/allAdapterPage.dart';
import 'package:smarthome/Services/colorsService.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'package:smarthome/Services/settingsService.dart';
import 'package:smarthome/Services/socketService.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
  IO.Socket mainSocket;
  StartPage({this.mainSocket});
}

class _StartPageState extends State<StartPage> {
  FavoriteService favoriteService;
  SettingsService settingsService;
  int _selectedIndex = 0;
  String _selectedPageId;
  SocketService socketService;

  @override
  void initState() {
    favoriteService = new FavoriteService();
    settingsService = new SettingsService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (socketService == null) {
      socketService = new SocketService();
    }
    return FutureBuilder(
      future: _setSelectedPageId(),
      builder: (BuildContext context, AsyncSnapshot snapshotPages) {
        if (snapshotPages.hasData) {
          return FutureBuilder<IpAddressModel>(
            future: settingsService.getIpAddressPort(),
            builder: (BuildContext context,
                AsyncSnapshot<IpAddressModel> snapshotIpPort) {
              if (snapshotIpPort.hasData) {
                if (widget.mainSocket == null) {
                  return FutureBuilder<IO.Socket>(
                    future: socketService.getSocket(snapshotIpPort.data),
                    builder: (BuildContext context,
                        AsyncSnapshot<IO.Socket> snapshotSocket) {
                      if (snapshotSocket.hasData) {
                        widget.mainSocket = snapshotSocket.data;
                        return _getStart(context, widget.mainSocket);
                      } else if (snapshotSocket.connectionState ==
                          ConnectionState.done) {
                        return _getInitalSettingsPage();
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                } else {
                  return _getStart(context, widget.mainSocket);
                }
              } else if (snapshotIpPort.data == null &&
                  snapshotIpPort.connectionState == ConnectionState.done) {
                return _getInitalSettingsPage();
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        } else if (snapshotPages.data == null &&
            snapshotPages.connectionState == ConnectionState.done) {
          return Center(child: Text('Fehler beim Laden der Seiten'));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  WillPopScope _getStart(BuildContext context, IO.Socket socket) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return null;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? BolioColors.surface
            : null,
        bottomNavigationBar: FutureBuilder(
          future: favoriteService.getPages(context),
          builder: (BuildContext context,
              AsyncSnapshot<List<PageModel>> snapshotPages) {
            if (snapshotPages.hasData && snapshotPages.data.length > 1) {
              return Visibility(
                visible: true,
                child: _getNavigationBar(snapshotPages.data),
              );
            } else {
              return Visibility(visible: false, child: Container());
            }
          },
        ),
        body: Container(
          child: RefreshIndicator(
            onRefresh: _refreshPage,
            child: FutureBuilder(
              future: favoriteService.getFavorites(context, _selectedPageId),
              builder: (context, snapshotFavorites) {
                if (snapshotFavorites.connectionState != ConnectionState.done) {
                  return new CircularProgressIndicator();
                } else if (snapshotFavorites.hasError) {
                  return new CircularProgressIndicator();
                } else {
                  List<FavoriteModel> favorites = snapshotFavorites.data ?? [];
                  if (favorites.length == 0) {
                    return Center(
                      child: Text(
                        'Wechseln sie in die Einstellungen um Favoriten anzulegen.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
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
                          socket: socket,
                          secured: favorites[index].secured,
                          icon: favorites[index].icon,
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
                }
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllAdapterPage(
                  mainSocket: widget.mainSocket,
                ),
              ),
            ).then((value) {
              setState(() {});
            });
          },
          child: Icon(Icons.settings),
        ),
      ),
    );
  }

  Scaffold _getInitalSettingsPage() {
    TextEditingController ipController = new TextEditingController();
    ipController.text = '192.168.178.122';
    TextEditingController portSimpleAPIController = new TextEditingController();
    portSimpleAPIController.text = '8087';
    TextEditingController portSocketIOController = new TextEditingController();
    portSocketIOController.text = '8084';

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
                controller: portSimpleAPIController,
                decoration: InputDecoration(labelText: 'simpleAPI Port'),
              ),
              TextFormField(
                controller: portSocketIOController,
                decoration: InputDecoration(labelText: 'socket.io Port'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  color: Colors.tealAccent,
                  child: const Text('Speichern',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  onPressed: () {
                    setState(
                      () {
                        settingsService.setIpAddress(ipController.text);
                        settingsService
                            .setPortSimpleAPI(portSimpleAPIController.text);
                        settingsService
                            .setPortSocketIO(portSocketIOController.text);
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

  BottomNavigationBar _getNavigationBar(List<PageModel> pages) {
    List<BottomNavigationBarItem> _navigationItems = new List();
    for (PageModel page in pages) {
      var _iconData = new IconData(page.icon,
          fontFamily: 'MaterialIcons', matchTextDirection: false);

      var item = BottomNavigationBarItem(
        icon: Icon(_iconData),
        title: Text(page.title),
      );

      _navigationItems.add(item);
    }

    return BottomNavigationBar(
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,
      items: _navigationItems,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      favoriteService
          .getPages(context)
          .then((pages) => {_selectedPageId = pages[index].id});
    });
  }

  Future<bool> _setSelectedPageId() async {
    List<PageModel> pages = await favoriteService.getPages(context);
    if (pages.length > _selectedIndex) {
      this._selectedPageId = pages[_selectedIndex].id;
    }
    return true;
  }
}
