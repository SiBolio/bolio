import 'package:bolio/models/dataPointNode.dart';
import 'package:bolio/models/objectModel.dart';
import 'package:bolio/models/saveModel.dart';
import 'package:bolio/pages/newWidgetPages/widgetSizePage.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/httpService.dart';
import 'package:bolio/widgets/dataPointHintCard.dart';
import 'package:bolio/widgets/dataPointTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DataPointPage extends StatefulWidget {
  String primaryObjectId = '';
  String secondaryObjectId = '';

  String selectionStep = '';

  HttpService httpService;
  SaveModel saveCMD;

  List<ObjectsModel> objectList;

  DataPointPage(this.saveCMD) {
    this.httpService = new HttpService();
    this.selectionStep = 'primary';
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
            visible: widget.primaryObjectId != '',
            child: RawMaterialButton(
              onPressed: () {
                widget.saveCMD.objectId = widget.primaryObjectId;
                widget.saveCMD.secondaryObjectId = widget.secondaryObjectId;
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
      body: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              color: ColorService.hintSurfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _getDataPointHint(),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 9,
            fit: FlexFit.tight,
            child: FutureBuilder(
              future: widget.httpService
                  .getAdapterObjects(widget.saveCMD.adapterId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ObjectsModel>> snapshotAdapterObjects) {
                if (snapshotAdapterObjects.hasData) {
                  _setAdapterObjectList(snapshotAdapterObjects.data);
                  return buildListView(widget.saveCMD.adapterId);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  ListView buildListView(String adapterId) {
    DataPointNode root = new DataPointNode();
    root.name = adapterId;

    for (ObjectsModel object in widget.objectList) {
      DataPointNode currentNode = root;
      List<String> objectPath = object.id.split(".");
      for (var i = 2; i < objectPath.length; i++) {
        bool nodeFound = false;

        String expandNodeName = '';
        String dataPointName = '';

        if (object.objectType == 'channel' || object.objectType == 'device') {
          expandNodeName = object.name;
        } else {
          dataPointName = object.name;
        }

        for (var child in currentNode.children) {
          if (child.name == objectPath[i]) {
            currentNode = child;

            if (currentNode.expandNodeName == '' &&
                i == objectPath.length - 1) {
              currentNode.expandNodeName = expandNodeName;
            }

            nodeFound = true;
          }
        }

        if (!nodeFound) {
          DataPointNode newNode = new DataPointNode();

          newNode.expandNodeName = expandNodeName;
          newNode.dataPointName = dataPointName;
          newNode.name = objectPath[i];
          newNode.objectId = object.id;
          newNode.type = object.dataType;

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

  List<Widget> _getChildrenTiles(DataPointNode node) {
    List<Widget> tiles = [];
    for (var child in node.children) {
      child.children.length == 0
          ? tiles.add(
              GestureDetector(
                onTap: () {
                  setState(() {
                    switch (widget.selectionStep) {
                      case 'primary':
                        widget.primaryObjectId = child.objectId;
                        break;
                      case 'secondary':
                        widget.secondaryObjectId = child.objectId;
                        break;
                      default:
                    }
                  });
                },
                child: DataPointTile(
                  child: child,
                  isSelectedPrimary: widget.primaryObjectId == child.objectId,
                  isSelectedSecondary:
                      widget.secondaryObjectId == child.objectId,
                ),
              ),
            )
          : tiles.add(
              ExpansionTile(
                title: Text(child.expandNodeName),
                children: _getChildrenTiles(child),
              ),
            );
    }
    return tiles;
  }

  void _setAdapterObjectList(List<ObjectsModel> items) {
    widget.objectList = items;
  }

  List<Widget> _getDataPointHint() {
    if (widget.saveCMD.type == 'Licht') {
      return _getDataPointHintLight();
    } else if (widget.saveCMD.type == 'Graph') {
      return _getDataPointHintGraph();
    } else {
      return [Text('Wählen sie einen Datenpunkt für das Widget aus')];
    }
  }

  List<Widget> _getDataPointHintLight() {
    return [
      Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.selectionStep = 'primary';
            });
          },
          child: DataPointHintCard(
            widget.primaryObjectId != '',
            widget.selectionStep == 'primary',
            'Datenpunkt um an und auszuschalten',
            ColorService.selectionPrimary,
          ),
        ),
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.selectionStep = 'secondary';
            });
          },
          child: DataPointHintCard(
            widget.secondaryObjectId != '',
            widget.selectionStep == 'secondary',
            'Datenpunkt für die Helligkeit',
            ColorService.selectionSecondary,
          ),
        ),
      )
    ];
  }

  List<Widget> _getDataPointHintGraph() {
    return [
      Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.selectionStep = 'primary';
            });
          },
          child: DataPointHintCard(
            widget.primaryObjectId != '',
            widget.selectionStep == 'primary',
            'Datenpunkt für den primären Graphen',
            ColorService.selectionPrimary,
          ),
        ),
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.selectionStep = 'secondary';
            });
          },
          child: DataPointHintCard(
            widget.secondaryObjectId != '',
            widget.selectionStep == 'secondary',
            'Datenpunkt für den sekundären Graphen',
            ColorService.selectionSecondary,
          ),
        ),
      )
    ];
  }
}
