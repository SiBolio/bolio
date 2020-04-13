import 'package:flutter/material.dart';
import 'package:smarthome/Models/adapterModel.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Pages/singleAdapterPage.dart';
import 'package:smarthome/Pages/start.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'package:smarthome/Services/httpService.dart';
import 'package:smarthome/Services/settingsService.dart';

HttpService httpService = new HttpService();
FavoriteService favoriteService = new FavoriteService();
SettingsService settingsService = new SettingsService();

class AllAdapterPage extends StatefulWidget {
  @override
  _AllAdapterPageState createState() => _AllAdapterPageState();
}

class _AllAdapterPageState extends State<AllAdapterPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Favoriten'),
    Tab(text: 'Adapter'),
    Tab(text: 'Sonstiges')
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<FavoriteModel> objects;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StartPage()),
              ).then((value) {
                setState(() {});
              });
            }),
        title: const Text('Einstellungen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map(
          (Tab tab) {
            if (tab.text == 'Sonstiges') {
              return FutureBuilder<String>(
                future: settingsService.getIpAddress_Port(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    TextEditingController ipController =
                        new TextEditingController();
                    ipController.text = snapshot.data.split(':')[0];
                    TextEditingController portController =
                        new TextEditingController();
                    portController.text = snapshot.data.split(':')[1];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: ipController,
                            decoration:
                                InputDecoration(labelText: 'IP Adresse'),
                          ),
                          TextFormField(
                            controller: portController,
                            decoration:
                                InputDecoration(labelText: 'simpleAPI Port'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: RaisedButton(
                              color: Colors.tealAccent,
                              child: const Text('Speichern',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              onPressed: () {
                                setState(
                                  () {
                                    settingsService
                                        .setIpAddress(ipController.text);
                                    settingsService
                                        .setPort(portController.text);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            } else if (tab.text == 'Adapter') {
              return Center(
                child: FutureBuilder(
                  future: httpService.getAllAdapters(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Text('Keine Adapter gefunden.');
                    }
                    if (snapshot.hasError) {
                      return new CircularProgressIndicator();
                    } else {
                      List<AdapterModel> objects = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: objects.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(objects[index].iconUrl),
                            ),
                            title: Text(objects[index].title),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleAdapterPage(
                                    title: objects[index].title,
                                    name: objects[index].name,
                                    adapterId: objects[index].id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              );
            } else {
              if (objects == null) {
                return Container(
                  child: FutureBuilder(
                    future: favoriteService.getFavorites(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return new CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return new CircularProgressIndicator();
                      } else {
                        objects = snapshot.data ?? [];
                        if (objects.length == 0) {
                          return Center(
                            child: Text(
                                'Fügen sie im Tab Adapter neue Favoriten hinzu'),
                          );
                        } else {
                          return _getFavoriteList(objects, context);
                        }
                      }
                    },
                  ),
                );
              } else {
                return _getFavoriteList(objects, context);
              }
            }
          },
        ).toList(),
      ),
    );
  }

  Widget _getFavoriteList(objects, context) {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(
          () {
            favoriteService.reorderFavorites(oldIndex, newIndex, context);
          },
        );
      },
      children: _getListTiles(objects, context),
    );
  }

  List<Widget> _getListTiles(objects, context) {
    List<Widget> listTiles = new List<Widget>();
    for (var object in objects) {
      var tile = new ListTile(
        key: ValueKey(object),
        title: Text(object.title),
        subtitle: Text(object.objectType),
        onTap: () {
          return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              TextEditingController nameController =
                  new TextEditingController();
              nameController.text = object.title;

              List _isSelected = <bool>[
                object.tileSize == 'S',
                object.tileSize == 'M',
                object.tileSize == 'L'
              ];

              String _isSelectedDropdownObjectType = object.objectType;
              String _isSelectedDropdownTimespan = object.timeSpan;

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Objekt bearbeiten'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Objektname'),
                        ),
                        TextFormField(
                          enabled: false,
                          initialValue: object.id,
                          decoration: InputDecoration(labelText: 'Objekt ID'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Größe: '),
                              ToggleButtons(
                                fillColor: Colors.tealAccent,
                                selectedColor: Colors.black,
                                children: <Widget>[
                                  Text('S'),
                                  Text('M'),
                                  Text('L'),
                                ],
                                onPressed: (int index) {
                                  setState(
                                    () {
                                      for (int buttonIndex = 0;
                                          buttonIndex < _isSelected.length;
                                          buttonIndex++) {
                                        if (buttonIndex == index) {
                                          _isSelected[buttonIndex] = true;
                                        } else {
                                          _isSelected[buttonIndex] = false;
                                        }
                                      }
                                    },
                                  );
                                },
                                isSelected: _isSelected,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Objekttyp: '),
                              DropdownButton<String>(
                                value: _isSelectedDropdownObjectType,
                                items: <String>[
                                  'Einzelwert',
                                  'On/Off Button',
                                  'Graph',
                                  'Slider',
                                  'Tür/Fensterkontakt'
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(
                                    () {
                                      _isSelectedDropdownObjectType = newValue;
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Visibility(
                            visible: _isSelectedDropdownObjectType == 'Graph',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Zeitraum: '),
                                DropdownButton<String>(
                                  value: _isSelectedDropdownTimespan,
                                  items: <String>[
                                    '24 Stunden',
                                    '7 Tage',
                                    '30 Tag',
                                  ].map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(
                                      () {
                                        _isSelectedDropdownTimespan = newValue;
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Abbrechen'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      RaisedButton(
                        child: Text('Speichern'),
                        color: Colors.tealAccent,
                        onPressed: () async {
                          FavoriteService favoriteService =
                              new FavoriteService();
                          setState(
                            () {
                              var tileSize = 'S';
                              if (_isSelected[1]) {
                                tileSize = 'M';
                              } else if (_isSelected[2]) {
                                tileSize = 'L';
                              }
                              favoriteService.updateFavorite(
                                object.id,
                                nameController.text,
                                tileSize,
                                _isSelectedDropdownObjectType,
                                _isSelectedDropdownTimespan,
                                context,
                              );
                            },
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllAdapterPage()),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            FavoriteService favoriteService = new FavoriteService();
            setState(
              () {
                favoriteService.removeObjectFromFavorites(object.id, context);
              },
            );
            final snackBar = SnackBar(
              content: Text('Favorit entfernt'),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
      );
      listTiles.add(tile);
    }
    return listTiles;
  }
}
