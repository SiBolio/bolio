import 'package:flutter/material.dart';
import 'package:smarthome/Models/nodeModel.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? BolioColors.surface
          : null,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: httpService.getAdapterObjects(widget.name, context),
          builder: (BuildContext context,
              AsyncSnapshot<List<ObjectsModel>> snapshotAdapterObjects) {
            if (snapshotAdapterObjects.hasData) {
              return FutureBuilder(
                future:
                    _getObjectList(widget.name, snapshotAdapterObjects.data),
                builder: (BuildContext context,
                    AsyncSnapshot<StatelessWidget> snapshotObjectList) {
                  if (snapshotObjectList.hasData &&
                      snapshotObjectList.connectionState ==
                          ConnectionState.done) {
                    return snapshotObjectList.data;
                  } else if (snapshotObjectList.connectionState ==
                          ConnectionState.done &&
                      !snapshotObjectList.hasData) {
                    return Text('Keine Datenpunkte gefunden');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<ListView> _getObjectList(
      String adapterId, List<ObjectsModel> adapterObjects) async {
    List<NodeModel> nodes = await httpService.getAdapterNodes(widget.name);

    Entry root = new Entry('root', 'root', []);
    Entry current = root;

    for (ObjectsModel adapterObject in adapterObjects) {
      List<String> objectHierarchyIds =
          _getObjectHierarchyIds(adapterObject.id);
      List<String> objectHierarchyIdsFull =
          _getObjectHierarchyIdsFull(adapterObject.id);

      for (var i = 0; i < objectHierarchyIds.length; i++) {
        bool foundEntry = false;
        for (Entry child in current.children) {
          if (child.id == objectHierarchyIds[i]) {
            foundEntry = true;
            current = child;
          }
        }
        if (!foundEntry) {
          Entry newEntry = new Entry(
            objectHierarchyIds[i],
            _getNodeName(objectHierarchyIdsFull[i], nodes),
            [],
            i == objectHierarchyIds.length - 1
                ? ObjectListTile(
                    object: adapterObject,
                    isFavorite: adapterObject.isfavorite,
                  )
                : null,
          );
          current.children.add(newEntry);
          current = newEntry;
        }
      }
      current = root;
    }

    return root.children.length != 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                EntryItem(root.children[0], context),
            itemCount: 1,
          )
        : Container();
  }


  List<String> _getObjectHierarchyIds(String id) {
    List<String> returnList = new List<String>();
    id.split('.').forEach((element) {
      returnList.add(element);
    });
    return returnList;
  }

  List<String> _getObjectHierarchyIdsFull(String id) {
    List<String> returnList = new List<String>();

    id.split('.').forEach((element) {
      returnList.add(element);
    });

    for (var i = 1; i < returnList.length; i++) {
      returnList[i] = returnList[i - 1] + '.' + returnList[i];
    }
    return returnList;
  }

  String _getNodeName(String objectsId, List<NodeModel> nodes) {
    for (var node in nodes) {
      if (node.id == objectsId) {
        return node.name;
      }
    }
    return objectsId;
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
  FavoriteService saveService;
  IconButtonService _iconButtonSrv;
  BolioColors _bolioColors;

  @override
  void initState() {
    _bolioColors = new BolioColors();
    saveService = new FavoriteService();
    _iconButtonSrv = new IconButtonService();
    _isFavorite = widget.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: _bolioColors.getDropDownBackgroundColor(context),
      child: ListTile(
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
                          child:
                              Text('Objekttyp: ' + widget.object.typeReadable),
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
      ),
    );
  }
}

class Entry {
  Entry(this.id, this.title,
      [this.children = const <Entry>[], this.objectTile]);

  final String id;
  final String title;
  final List<Entry> children;
  final ObjectListTile objectTile;
}

class EntryItem extends StatelessWidget {
  BolioColors _bolioColors;
  var _context;

  EntryItem(this.entry, this._context) {
    _bolioColors = new BolioColors();
  }

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return root.objectTile;
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      leading: ClipOval(
        child: Material(
          color: _bolioColors.getDropDownBackgroundColor(_context),
          child: InkWell(
            splashColor: Colors.red,
            child: SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: Text(
                  root.children.length.toString(),
                  style: new TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ),
        ),
      ),
      title:
          Text(root.title, style: new TextStyle(fontWeight: FontWeight.w500)),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
