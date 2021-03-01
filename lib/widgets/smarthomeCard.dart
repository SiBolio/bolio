import 'package:bolio/models/historyModel.dart';
import 'package:bolio/widgets/graph.dart';
import 'package:bolio/widgets/light.dart';
import 'package:bolio/widgets/onOffButton.dart';
import 'package:bolio/widgets/singleValue.dart';
import 'package:bolio/widgets/sliderWidget.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

class SmarthomeCard extends StatefulWidget {
  final String objectId;
  final String objectType;
  final String tileSize;
  final String text;
  final String secondayObjectId;

  SmarthomeCard(
    this.objectId,
    this.objectType,
    this.tileSize,
    this.text, [
    this.secondayObjectId,
  ]);

  @override
  State<StatefulWidget> createState() => _SmarthomeCardState();
}

class _SmarthomeCardState extends State<SmarthomeCard> {
  @override
  Widget build(BuildContext context) {
    switch (widget.objectType) {
      case 'On/Off Button':
        {
          return StreamBuilder(
            initialData: globals.socketService.getObjectValue(widget.objectId),
            stream: globals.socketService
                .getStreamController(widget.objectId)
                .stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return OnOffButton(
                  widget.text,
                  widget.objectId,
                  snapshot.data == 'true' ? true : false,
                  widget.tileSize,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        }
      case 'Einzelwert':
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
      case 'Licht':
        {
          return StreamBuilder(
            initialData: globals.socketService.getObjectValue(widget.objectId),
            stream: globals.socketService
                .getStreamController(widget.objectId)
                .stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return snapshot.data == 'true'
                    ? Light(widget.text, widget.objectId, true, widget.tileSize,
                        widget.secondayObjectId)
                    : Light(widget.text, widget.objectId, false,
                        widget.tileSize, widget.secondayObjectId);
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        }
      case 'Slider':
        {
          return StreamBuilder(
            initialData: globals.socketService.getObjectValue(widget.objectId),
            stream: globals.socketService
                .getStreamController(widget.objectId)
                .stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SliderWidget(
                    widget.text,
                    widget.objectId,
                    double.parse(snapshot.data),
                    widget.tileSize,
                    widget.secondayObjectId);
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
                          historyList.data, snapshot.data, widget.tileSize);
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
