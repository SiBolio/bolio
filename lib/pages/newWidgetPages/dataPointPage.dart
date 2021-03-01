import 'package:bolio/models/objectModel.dart';
import 'package:bolio/models/saveModel.dart';
import 'package:bolio/pages/newWidgetPages/widgetSizePage.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/httpService.dart';
import 'package:flutter/material.dart';

class DataPointPage extends StatefulWidget {
  String selectedItem = '';
  String dataPoint = '';
  HttpService httpService;
  SaveModel saveCMD;
  ListView objectList;

  DataPointPage(this.saveCMD) {
    this.httpService = new HttpService();
  }

  @override
  _DataPointPageState createState() => _DataPointPageState();
}

class _DataPointPageState extends State<DataPointPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: widget.selectedItem == ''
            ? Text('Datenpunkt')
            : Text(
                widget.selectedItem,
                overflow: TextOverflow.ellipsis,
              ),
        backgroundColor: ColorSerivce.surface,
        elevation: 0.0,
        actions: <Widget>[
          Visibility(
            visible: widget.selectedItem != '',
            child: RawMaterialButton(
              onPressed: () {
                widget.saveCMD.objectId = widget.dataPoint;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WidgetSizePage(widget.saveCMD),
                  ),
                );
              },
              elevation: 2.0,
              fillColor: ColorSerivce.constMainColor,
              child: Icon(
                Icons.arrow_forward_ios_sharp,
              ),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: widget.saveCMD.objectId == null &&
                widget.saveCMD.type == 'Licht',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Wählen sie Datenpunkt um das Licht an und auszuschalten',
              ),
            ),
          ),
          Expanded(
            child: widget.objectList == null
                ? FutureBuilder(
                    future: widget.httpService
                        .getAdapterObjects(widget.saveCMD.adapterId),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ObjectsModel>>
                            snapshotAdapterObjects) {
                      if (snapshotAdapterObjects.hasData) {
                        return FutureBuilder(
                          future: _setObjectList(widget.saveCMD.adapterId,
                              snapshotAdapterObjects.data),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshotObjectList) {
                            if (widget.objectList != null &&
                                snapshotObjectList.connectionState ==
                                    ConnectionState.done) {
                              return widget.objectList;
                            } else if (snapshotObjectList.connectionState ==
                                    ConnectionState.done &&
                                !snapshotObjectList.hasData) {
                              return Text('Keine Datenpunkte gefunden');
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                : widget.objectList,
          ),
        ],
      ),
    );
  }

  Future<bool> _setObjectList(
      String adapterId, List<ObjectsModel> adapterObjects) async {
    List<NodeModel> nodes = await widget.httpService.getAdapterNodes(adapterId);

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
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.dataPoint = adapterObject.id;
                        widget.selectedItem = adapterObject.name;
                      });
                    },
                    child: ObjectListTile(
                        object: adapterObject, parentState: this),
                  )
                : null,
          );
          current.children.add(newEntry);
          current = newEntry;
        }
      }
      current = root;
    }
    widget.objectList = ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          EntryItem(root.children[0]),
      itemCount: 1,
    );
    return true;
  }

  List<String> _getObjectHierarchyIds(String id) {
    List<String> returnList = [];
    id.split('.').forEach((element) {
      returnList.add(element);
    });
    return returnList;
  }

  List<String> _getObjectHierarchyIdsFull(String id) {
    List<String> returnList = [];

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

class ObjectListTile extends StatelessWidget {
  final ObjectsModel object;
  _DataPointPageState parentState;

  ObjectListTile({this.object = const ObjectsModel(), this.parentState});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(object.name),
      subtitle: Text(object.id),
    );
  }
}

class NodeModel {
  String name;
  String id;
  String type;

  NodeModel({this.name = '', this.id = '', this.type = ''});
}

class Entry {
  Entry(this.id, this.title,
      [this.children = const <Entry>[], this.objectTile]);

  final String id;
  final String title;
  final List<Entry> children;
  final GestureDetector objectTile;
}

class EntryItem extends StatelessWidget {
  EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return root.objectTile;
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      leading: ClipOval(
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(4.0),
            splashColor: ColorSerivce.constMainColor,
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
      title: Text(
        root.title,
        style: new TextStyle(fontWeight: FontWeight.w500),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
