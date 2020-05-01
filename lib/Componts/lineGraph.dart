import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as textElement;
import 'package:charts_flutter/src/text_style.dart' as style;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  LineGraph(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    CustomCircleSymbolRenderer customRenderer =
        new CustomCircleSymbolRenderer(value: '0');

    return new charts.TimeSeriesChart(
      seriesList,
      behaviors: [LinePointHighlighter(symbolRenderer: customRenderer)],
      selectionModels: [
        SelectionModelConfig(
          changedListener: (SelectionModel model) {
            if (model.hasDatumSelection) {
              String value = model.selectedDatum[0].datum.value.toString();
              customRenderer.setValue(value);
            }
          },
        )
      ],
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: new charts.NoneRenderSpec(),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            fontSize: 18,
            color: charts.ColorUtil.fromDartColor(Colors.white54),
          ),
          lineStyle: new charts.LineStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.white24)),
        ),
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
            desiredTickCount: 2, zeroBound: false),
      ),
    );
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  String value;
  CustomCircleSymbolRenderer({this.value});

  setValue(String value) {
    this.value = value;
  }

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds);
    canvas.drawRect(
        Rectangle(bounds.left, bounds.top, bounds.width, bounds.height),
        fill: Color.transparent);

    var textStyle = style.TextStyle();
    textStyle.color = Color.white;
    textStyle.fontSize = 20;

    canvas.drawText(textElement.TextElement(this.value, style: textStyle),
        (bounds.left - 10 ).round(), -2 );
  }
}
