import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Services/colorsService.dart';

import 'lineGraph.dart';

class BarGraph extends StatelessWidget {
  BolioColors bolioColors;
  final List<charts.Series> seriesList;
  final bool animate;

  BarGraph(this.seriesList, {this.animate}) {
    bolioColors = new BolioColors();
  }

  @override
  Widget build(BuildContext context) {

 CustomCircleSymbolRenderer customRenderer =
        new CustomCircleSymbolRenderer(value: '0');

    return new charts.BarChart(
      seriesList,
      behaviors: [LinePointHighlighter(symbolRenderer: customRenderer)],
      selectionModels: [
        SelectionModelConfig(
          changedListener: (SelectionModel model) {
            if (model.hasDatumSelection) {
              String value = model.selectedDatum[0].datum.value.toString();
              customRenderer.setValue(value);
              customRenderer.setColor(
                  Theme.of(context).brightness == Brightness.dark
                      ? Color.white
                      : Color.black);
            }
          },
        )
      ],
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            fontSize: 18,
            color: charts.ColorUtil.fromDartColor(
              bolioColors.getGraphLabelColor(context),
            ),
          ),
          lineStyle: new charts.LineStyleSpec(
            color: charts.ColorUtil.fromDartColor(
              bolioColors.getGraphLabelColor(context),
            ),
          ),
        ),
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
            desiredTickCount: 2, zeroBound: true),
      ),
      animate: animate,
       domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }
}
