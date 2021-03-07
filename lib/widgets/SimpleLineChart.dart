import 'package:bolio/models/historyModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<HistoryModel> primaryHistoryList;
  final List<HistoryModel> secondaryHistoryList;
  final String tileSize;

  SimpleLineChart(this.primaryHistoryList, this.tileSize,
      [this.secondaryHistoryList]);

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
        renderSpec: tileSize == 'M'
            ? new charts.NoneRenderSpec()
            : new charts.GridlineRendererSpec(
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
    List<charts.Series<HistoryModel, DateTime>> returnList = [];

    if (secondaryHistoryList != null) {
      returnList.add(new charts.Series<HistoryModel, DateTime>(
        id: 'HistorySecondary',
        colorFn: (HistoryModel history, __) {
          return charts.ColorUtil.fromDartColor(ColorService.constMainColor);
        },
        domainFn: (HistoryModel history, _) => history.timeStamp,
        measureFn: (HistoryModel history, _) => history.value,
        strokeWidthPxFn: (HistoryModel history, _) => 2,
        data: this.secondaryHistoryList,
      ));
    }

    returnList.add(new charts.Series<HistoryModel, DateTime>(
      id: 'HistoryPrimary',
      colorFn: (HistoryModel history, __) {
        return charts.ColorUtil.fromDartColor(ColorService.constMainColorSub);
      },
      domainFn: (HistoryModel history, _) => history.timeStamp,
      measureFn: (HistoryModel history, _) => history.value,
      strokeWidthPxFn: (HistoryModel history, _) => 2,
      data: this.primaryHistoryList,
    ));

    return returnList;
  }
}
