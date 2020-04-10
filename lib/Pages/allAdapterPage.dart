import 'package:flutter/material.dart';
import 'package:smarthome/Models/adapterModel.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Pages/singleAdapterPage.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'package:smarthome/Services/httpService.dart';

HttpService httpService = new HttpService();
FavoriteService favoriteService = new FavoriteService();

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Meine Objekte'),
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
              return Center(
                child: Text('TODO'),
              );
            } else if (tab.text == 'Adapter') {
              return Center(
                child: FutureBuilder(
                  future: httpService.getAllAdapters(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return new CircularProgressIndicator();
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
                      List<FavoriteModel> objects = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: objects.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(objects[index].title),
                            subtitle: Text(objects[index].objectType),
                            onTap: () {
                              return showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController nameController =
                                      new TextEditingController();
                                  nameController.text = objects[index].title;

                                  List _isSelected = <bool>[
                                    objects[index].tileSize == 'S',
                                    objects[index].tileSize == 'M',
                                    objects[index].tileSize == 'L'
                                  ];

                                  String _isSelectedDropdown =
                                      objects[index].objectType;

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: Text('Objekt bearbeiten'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                  labelText: 'Objektname'),
                                            ),
                                            TextFormField(
                                              enabled: false,
                                              initialValue: objects[index].id,
                                              decoration: InputDecoration(
                                                  labelText: 'Objekt ID'),
                                            ),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 5,
                                              children: [
                                                Text('Anzeigegröße:'),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: ToggleButtons(
                                                    children: <Widget>[
                                                      Text('S'),
                                                      Text('M'),
                                                      Text('L'),
                                                    ],
                                                    onPressed: (int index) {
                                                      setState(
                                                        () {
                                                          for (int buttonIndex =
                                                                  0;
                                                              buttonIndex <
                                                                  _isSelected
                                                                      .length;
                                                              buttonIndex++) {
                                                            if (buttonIndex ==
                                                                index) {
                                                              _isSelected[
                                                                      buttonIndex] =
                                                                  true;
                                                            } else {
                                                              _isSelected[
                                                                      buttonIndex] =
                                                                  false;
                                                            }
                                                          }
                                                        },
                                                      );
                                                    },
                                                    isSelected: _isSelected,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 5,
                                              children: [
                                                Text('Objekttyp:'),
                                                DropdownButton<String>(
                                                  value: _isSelectedDropdown,
                                                  items: <String>[
                                                    'Einzelwert',
                                                    'On/Off Button',
                                                    'Graph',
                                                    'Slider'
                                                  ].map((String value) {
                                                    return new DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: new Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String newValue) {
                                                    setState(
                                                      () {
                                                        _isSelectedDropdown =
                                                            newValue;
                                                      },
                                                    );
                                                  },
                                                )
                                              ],
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
                                                  favoriteService
                                                      .updateFavorite(
                                                    objects[index].id,
                                                    nameController.text,
                                                    tileSize,
                                                    _isSelectedDropdown,
                                                    context,
                                                  );
                                                },
                                              );
                                              Navigator.of(context).pop();
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
                                FavoriteService favoriteService =
                                    new FavoriteService();
                                setState(
                                  () {
                                    favoriteService.removeObjectFromFavorites(
                                        objects[index].id, context);
                                  },
                                );
                                final snackBar = SnackBar(
                                  content: Text('Favorit entfernt'),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            }
          },
        ).toList(),
      ),
    );
  }
}
