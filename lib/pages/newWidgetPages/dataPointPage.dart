import 'package:bolio/models/objectModel.dart';
import 'package:bolio/models/saveModel.dart';
import 'package:bolio/pages/newWidgetPages/widgetSizePage.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/httpService.dart';
import 'package:flutter/material.dart';

class DataPointPage extends StatefulWidget {
  String selectedDataPoint = '';
  HttpService httpService;
  SaveModel saveCMD;

  List<ObjectsModel> objectList;

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
      backgroundColor: ColorService.surface,
      appBar: AppBar(
        title: Text('Datenpunkt'),
        backgroundColor: ColorService.surface,
        actions: <Widget>[
          Visibility(
            visible: widget.selectedDataPoint != '',
            child: RawMaterialButton(
              onPressed: () {
                widget.saveCMD.objectId = widget.selectedDataPoint;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WidgetSizePage(widget.saveCMD),
                  ),
                );
              },
              elevation: 2.0,
              fillColor: ColorService.constMainColor,
              child: Icon(
                Icons.arrow_forward_ios_sharp,
              ),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future:
              widget.httpService.getAdapterObjects(widget.saveCMD.adapterId),
          builder: (BuildContext context,
              AsyncSnapshot<List<ObjectsModel>> snapshotAdapterObjects) {
            if (snapshotAdapterObjects.hasData) {
              _setAdapterObjectList(snapshotAdapterObjects.data);
              return buildListView(widget.saveCMD.adapterId);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  ListView buildListView(String adapterId) {
    Node root = new Node();
    root.name = adapterId;

    for (ObjectsModel object in widget.objectList) {
      if (object.name == 'typeXXXXX') {
        print('FF');
      }
      Node currentNode = root;
      List<String> objectPath = object.id.split(".");
      for (var i = 1; i < objectPath.length; i++) {
        bool nodeFound = false;
        for (var child in currentNode.children) {
          if (child.name == objectPath[i]) {
            currentNode = child;
            nodeFound = true;
          }
        }

        if (!nodeFound) {
          Node newNode = new Node();
          newNode.name = objectPath[i];
          newNode.objectId = object.id;

          if (i == objectPath.length - 1) {
            newNode.objectId = object.id;
            newNode.type = object.dataType;
          }

          currentNode.children.add(newNode);
          currentNode = newNode;
        }
      }
    }

    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(root.name),
          children: _getChildrenTiles(root),
          initiallyExpanded: true,
        );
      },
    );
  }

  List<Widget> _getChildrenTiles(Node node) {
    List<Widget> tiles = [];
    for (var child in node.children) {
      child.children.length == 0
          ? tiles.add(
              GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.selectedDataPoint = child.objectId;
                    });
                  },
                  child: DataPointTile(
                    child: child,
                    isSelected: widget.selectedDataPoint == child.objectId,
                  )),
            )
          : tiles.add(
              ExpansionTile(
                title: Text(_getExpansionTileName(child.objectId)),
                children: _getChildrenTiles(child),
                subtitle: Text(child.name),
              ),
            );
    }
    return tiles;
  }

  void _setAdapterObjectList(List<ObjectsModel> items) {
    widget.objectList = items;
  }

  String _getExpansionTileName(String objectId) {
    if (objectId == 'pi-hole.0.type') {
      print('FFFF');
    }
    String returnText = '';
    for (var object in widget.objectList) {
      if (object.id == objectId) {
        returnText = object.name;
        break;
      }
    }
    return returnText;
  }
}

class DataPointTile extends StatelessWidget {
  const DataPointTile({
    Key key,
    @required this.child,
    this.isSelected,
  }) : super(key: key);

  final Node child;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Material(
          color: ColorService.constMainColor,
          child: SizedBox(
              width: 40, height: 40, child: Icon(_getTileIcon(child.type))),
        ),
      ),
      tileColor:
          isSelected ? ColorService.constMainColor : ColorService.tileColor,
      title: child.name != null ? Text(child.name) : Text('-'),
      subtitle: child.objectId != null ? Text(child.objectId) : Text('-'),
    );
  }

  IconData _getTileIcon(String type) {
    switch (type) {
      case 'boolean':
        return Icons.power_settings_new;
        break;
      case 'number':
        return Icons.looks_two;
        break;
      case 'string':
        return Icons.short_text;
        break;
      case 'value':
        return Icons.money_outlined;
        break;
      case 'text':
        return Icons.text_snippet;
        break;
      default:
        print('Typ:' + type.toString());
        return Icons.circle;
        break;
    }
  }
}

class Node {
  String name;
  String objectId;
  String type;
  String displayName;
  List<Node> children = [];
}
