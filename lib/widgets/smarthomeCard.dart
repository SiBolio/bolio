import 'package:bolio/models/historyModel.dart';
import 'package:bolio/widgets/graph.dart';
import 'package:bolio/widgets/onOffButton.dart';
import 'package:bolio/widgets/singleValue.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

class SmarthomeCard extends StatefulWidget {
  final String objectId;
  final String objectType;
  final String tileSize;
  final String text;
  SmarthomeCard(this.objectId, this.objectType, this.tileSize, this.text);

  @override
  State<StatefulWidget> createState() => _SmarthomeCardState();
}

class _SmarthomeCardState extends State<SmarthomeCard> {
  @override
  Widget build(BuildContext context) {
    switch (widget.objectType) {
      case 'OnOffButton':
        {
          return StreamBuilder(
            initialData: globals.socketService.getObjectValue(widget.objectId),
            stream: globals.socketService
                .getStreamController(widget.objectId)
                .stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return snapshot.data == 'true'
                    ? OnOffButton(widget.text, widget.objectId, true)
                    : OnOffButton(widget.text, widget.objectId, false);
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        }
      case 'SingleValue':
        {
          return StreamBuilder(
            initialData: globals.socketService.getObjectValue(widget.objectId),
            stream: globals.socketService
                .getStreamController(widget.objectId)
                .stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SingleValue(widget.text, widget.objectId, snapshot.data);
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        }
      case 'Graph':
        {
          return FutureBuilder<List<HistoryModel>>(
            future: globals.httpService.getHistory(widget.objectId),
            builder: (BuildContext context,
                AsyncSnapshot<List<HistoryModel>> historyList) {
              if (historyList.hasData &&
                  historyList.connectionState == ConnectionState.done) {
                return StreamBuilder(
                  initialData:
                      globals.socketService.getObjectValue(widget.objectId),
                  stream: globals.socketService
                      .getStreamController(widget.objectId)
                      .stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Graph(widget.text, widget.objectId,
                          historyList.data, snapshot.data);
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        }
      default:
        {
          return Container();
        }
        break;
    }
  }
}
