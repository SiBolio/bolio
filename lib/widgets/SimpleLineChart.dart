import 'package:bolio/models/historyModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<HistoryModel> historyList;

  SimpleLineChart(this.historyList);

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      _getSeriesList(),
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: new charts.NoneRenderSpec(),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            fontSize: 18,
            color: charts.ColorUtil.fromDartColor(Colors.white),
          ),
          lineStyle: new charts.LineStyleSpec(
            color: charts.ColorUtil.fromDartColor(Colors.grey),
          ),
        ),
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
            desiredTickCount: 2, zeroBound: false),
      ),
    );
  }

  List<charts.Series<HistoryModel, DateTime>> _getSeriesList() {
    return [
      new charts.Series<HistoryModel, DateTime>(
        id: 'History',
        colorFn: (HistoryModel history, __) {
          return charts.ColorUtil.fromDartColor(Colors.amber);
        },
        domainFn: (HistoryModel history, _) => history.timeStamp,
        measureFn: (HistoryModel history, _) => history.value,
        strokeWidthPxFn: (HistoryModel history, _) => 2,
        data: this.historyList,
      )
    ];
  }
}
