import 'package:auto_size_text/auto_size_text.dart';
import 'package:bolio/models/historyModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/widgets/simpleBarChard.dart';
import 'package:bolio/widgets/simpleLineChart.dart';
import 'package:flutter/material.dart';

class Graph extends StatefulWidget {
  final String text;
  final List<HistoryModel> primaryHistory;
  final List<HistoryModel> secondaryHistory;
  final String primaryCurrentValue;
  final String secondaryCurrentValue;
  final String tileSize;
  final String graphType;
  final String timeSpan;
  final String minimum;
  final String maximum;

  Graph(
    this.text,
    this.primaryHistory,
    this.primaryCurrentValue,
    this.tileSize,
    this.timeSpan,
    this.graphType, [
    this.secondaryHistory,
    this.secondaryCurrentValue,
    this.minimum,
    this.maximum,
  ]);

  @override
  State<StatefulWidget> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorService.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: widget.tileSize == 'L'
            ? EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8)
            : EdgeInsets.all(0),
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
                          child: _getChart(),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'aktuell:',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: ColorService.constMainColorSub,
                                    ),
                                  ),
                                  AutoSizeText(
                                    widget.primaryCurrentValue,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: ColorService.constMainColorSub),
                                  ),
                                ],
                              ),
                              widget.secondaryCurrentValue != null
                                  ? Column(
                                      children: [
                                        Text(
                                          'aktuell:',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                ColorService.constMainColor,
                                          ),
                                        ),
                                        AutoSizeText(
                                          widget.secondaryCurrentValue,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              color:
                                                  ColorService.constMainColor),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Flexible(
                    flex: 3,
                    child: _getChart(),
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

  Widget _getChart() {
    if (widget.graphType == 'Graph') {
      if (widget.secondaryHistory == null) {
        return SimpleLineChart(widget.primaryHistory, widget.tileSize, null,
            widget.minimum, widget.maximum);
      } else {
        return SimpleLineChart(widget.primaryHistory, widget.tileSize,
            widget.secondaryHistory, widget.minimum, widget.maximum);
      }
    } else if (widget.graphType == 'Balkendiagramm') {
      return SimpleBarChart(widget.primaryHistory, widget.tileSize,
          widget.timeSpan, null, widget.minimum, widget.maximum);
    }
  }
}
