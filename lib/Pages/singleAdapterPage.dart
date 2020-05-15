import 'package:flutter/material.dart';
import 'package:smarthome/Models/objectsModel.dart';
import 'package:smarthome/Services/colorsService.dart';
import 'package:smarthome/Services/httpService.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'package:smarthome/Services/iconButtonService.dart';

HttpService httpService = new HttpService();

class SingleAdapterPage extends StatefulWidget {
  final String name;
  final String title;
  final String adapterId;
  SingleAdapterPage({this.name, this.title, this.adapterId});

  @override
  _SingleAdapterPageState createState() => _SingleAdapterPageState();
}

class _SingleAdapterPageState extends State<SingleAdapterPage> {
  TextEditingController _searchQueryController = TextEditingController();

  bool _isSearching = false;
  String searchQuery = "";

  String _currentlySelected = "Alle";
  final List<String> _dropdownValues = [
    "Alle",
    "On/Off",
    "Zahl",
    "Wert",
    "Text",
    "Objekt"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? BolioColors.surface
          : null,
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButton(
              items: _dropdownValues
                  .map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String value) {
                setState(() {
                  _currentlySelected = value;
                });
              },
              isExpanded: false,
              value: _currentlySelected,
            ),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: httpService.getAdapterObjects(widget.name, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return new CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return new CircularProgressIndicator();
            } else {
              List<ObjectsModel> objects = snapshot.data ?? [];

              if (_isSearching && this.searchQuery.length > 1) {
                objects = queryObjects(objects);
              }

              if (_currentlySelected != 'Alle') {
                objects = filterObjects(objects);
              }

              List<ObjectsModel> _sortedObjects = _orderAlphabetical(objects);

              return ListView.builder(
                itemCount: _sortedObjects.length,
                itemBuilder: (context, index) {
                  return ObjectListTile(
                    object: _sortedObjects[index],
                    isFavorite: _sortedObjects[index].isfavorite,
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startSearch();
        },
        child: Icon(Icons.search),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: widget.title + ' durchsuchen',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      onChanged: (query) {
        setState(() {
          this.searchQuery = query;
        });
      },
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  List<ObjectsModel> queryObjects(List<ObjectsModel> queryObjects) {
    List<ObjectsModel> returnList = new List();
    for (var object in queryObjects) {
      if (object.desc.contains(this.searchQuery) ||
          object.id.contains(this.searchQuery) ||
          object.name.contains(this.searchQuery)) {
        returnList.add(object);
      }
    }
    return returnList;
  }

  List<ObjectsModel> filterObjects(List<ObjectsModel> queryObjects) {
    List<ObjectsModel> returnList = new List();
    for (var object in queryObjects) {
      if (object.typeReadable == _currentlySelected) {
        returnList.add(object);
      }
    }
    return returnList;
  }

  List<ObjectsModel> _orderAlphabetical(List<ObjectsModel> objects) {
    objects
        .sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    return objects;
  }
}

class ObjectListTile extends StatefulWidget {
  final ObjectsModel object;
  final bool isFavorite;

  ObjectListTile({this.object, this.isFavorite});

  @override
  _ObjectListTileState createState() => _ObjectListTileState();
}

class _ObjectListTileState extends State<ObjectListTile> {
  bool _isFavorite;
  FavoriteService saveService = new FavoriteService();
  IconButtonService _iconButtonSrv = new IconButtonService();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.object.name),
      subtitle: Text(widget.object.id),
      onTap: () {
        return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(widget.object.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Objekttyp: ' + widget.object.typeReadable),
                      ),
                      FutureBuilder(
                        future: httpService.getObjectValue(widget.object.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              child: Text(
                                snapshot.data,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.black,
                      child: Text('Ok'),
                      onPressed: () {
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
      leading: _iconButtonSrv.getItemIcon(widget.object.type),
      trailing: IconButton(
        color: _isFavorite ? Theme.of(context).accentColor : null,
        icon: Icon(
          _isFavorite ? Icons.star : Icons.star_border,
        ),
        onPressed: () {
          setState(
            () {
              _isFavorite = !_isFavorite;
              _isFavorite
                  ? saveService.addObjectToFavorites(widget.object, context)
                  : saveService.removeObjectFromFavorites(
                      widget.object.id, context);
              String snackBarText =
                  _isFavorite ? 'Favorit hinzugefügt' : 'Favorit entfernt';
              final snackBar = SnackBar(
                content: Text(snackBarText),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
          );
        },
      ),
    );
  }
}
