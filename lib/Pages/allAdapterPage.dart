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
            if (tab.text == 'Adapter') {
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
              return Center(
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
                            subtitle: Text(objects[index].id),
                            onTap: () {
                              return showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController nameController =
                                      new TextEditingController();
                                  nameController.text = objects[index].title;
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
                                          FavoriteModel updateFavorite =
                                              new FavoriteModel(
                                            id: objects[index].id,
                                            title: nameController.text,
                                          );
                                          FavoriteService favoriteService =
                                              new FavoriteService();
                                          setState(
                                            () {
                                              favoriteService.updateFavorite(
                                                objects[index].id,
                                                nameController.text,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(
            () {
              httpService.clearGetAllAdapters();
            },
          );
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
