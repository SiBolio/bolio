import 'package:bolio/models/historyModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/widgets/SimpleLineChart.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class Graph extends StatefulWidget {
  final String text;
  final String id;
  final List<HistoryModel> history;
  final String currentValue;
  Graph(this.text, this.id, this.history, this.currentValue);

  @override
  State<StatefulWidget> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorSerivce.surfaceCard,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: SimpleLineChart(widget.history)),
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
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(widget.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
