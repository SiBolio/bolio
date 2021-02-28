import 'package:auto_size_text/auto_size_text.dart';
import 'package:bolio/models/historyModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/widgets/SimpleLineChart.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

class Graph extends StatefulWidget {
  final String text;
  final String id;
  final List<HistoryModel> history;
  final String currentValue;
  final String tileSize;

  Graph(this.text, this.id, this.history, this.currentValue, this.tileSize);

  @override
  State<StatefulWidget> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorSerivce.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: widget.tileSize == 'L' ? EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8):EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            widget.tileSize == 'L'
                ? Flexible(
                    flex: 6,
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
                        Flexible(
                            flex: 5,
                            fit: FlexFit.tight,
                            child: SimpleLineChart(
                                widget.history, widget.tileSize)),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(widget.currentValue),
                          ),
                        ),
                      ],
                    ),
                  )
                : Flexible(
                    flex: 3,
                    child: SimpleLineChart(widget.history, widget.tileSize),
                  ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
