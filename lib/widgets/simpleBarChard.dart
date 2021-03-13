import 'package:bolio/models/historyModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<HistoryModel> primaryHistoryList;
  final List<HistoryModel> secondaryHistoryList;
  final String tileSize;
  final String timeSpan;
  final String minimum;
  final String maximum;

  SimpleBarChart(this.primaryHistoryList, this.tileSize, this.timeSpan,
      [this.secondaryHistoryList, this.minimum, this.maximum]);

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _getSeriesList(),
      animate: true,
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: tileSize == 'M'
            ? charts.NoneRenderSpec()
            : new charts.GridlineRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 18,
                  color: charts.ColorUtil.fromDartColor(Colors.white),
                ),
                lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(Colors.grey),
                ),
              ),
      ),
    );
  }

  List<charts.Series<HistoryModel, String>> _getSeriesList() {
    List<HistoryModel> clusteredList =
        _getClusteredList(this.primaryHistoryList);

    List<charts.Series<HistoryModel, String>> returnList = [];

    returnList.add(new charts.Series<HistoryModel, String>(
      id: 'HistorySecondary',
      colorFn: (HistoryModel history, __) {
        if (minimum == null && maximum == null) {
          return charts.ColorUtil.fromDartColor(ColorService.constMainColorSub);
        } else if (minimum == null) {
          return history.value < double.parse(minimum)
              ? charts.ColorUtil.fromDartColor(ColorService.constMainColorSub)
              : charts.ColorUtil.fromDartColor(ColorService.graphDanger);
        } else if (maximum == null) {
          return history.value > double.parse(maximum)
              ? charts.ColorUtil.fromDartColor(ColorService.constMainColorSub)
              : charts.ColorUtil.fromDartColor(ColorService.graphDanger);
        } else {
          return history.value < double.parse(minimum) ||
                  history.value > double.parse(maximum)
              ? charts.ColorUtil.fromDartColor(ColorService.constMainColorSub)
              : charts.ColorUtil.fromDartColor(ColorService.graphDanger);
        }
      },
      domainFn: (HistoryModel history, _) => history.timeStamp.toString(),
      measureFn: (HistoryModel history, _) => history.value,
      strokeWidthPxFn: (HistoryModel history, _) => 2,
      data: clusteredList,
    ));

    return returnList;
  }

  List<HistoryModel> _getClusteredList(List<HistoryModel> primaryHistoryList) {
    List<HistoryModel> clusterItems = [];

    double clusterSum = 0;
    var itemsInCluster =
        (primaryHistoryList.length / double.parse(timeSpan)).floor();
    var clusterIndex = 0;

    for (var i = 0; i < primaryHistoryList.length; i++) {
      if (clusterIndex < itemsInCluster - 1) {
        clusterSum = clusterSum + primaryHistoryList[i].value;
        clusterIndex++;
      } else {
        clusterItems.add(HistoryModel(
            primaryHistoryList[i].timeStamp, clusterSum / itemsInCluster));
        clusterSum = 0;
        clusterIndex = 0;
      }
    }

    return clusterItems;
  }
}
