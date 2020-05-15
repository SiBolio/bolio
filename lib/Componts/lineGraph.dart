import 'dart:math';
import 'package:charts_flutter/src/text_element.dart' as textElement;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Services/colorsService.dart';

class LineGraph extends StatelessWidget {
  BolioColors bolioColors;
  final List<charts.Series> seriesList;
  final bool animate;

  LineGraph(this.seriesList, {this.animate}) {
    bolioColors = new BolioColors();
  }

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
              customRenderer.setColor(
                  Theme.of(context).brightness == Brightness.dark
                      ? Color.white
                      : Color.black);
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
            desiredTickCount: 2, zeroBound: false),
      ),
    );
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  String value;
  Color textColor;
  CustomCircleSymbolRenderer({this.value});

  setValue(String value) {
    this.value = value;
  }

  setColor(Color textColor) {
    this.textColor = textColor;
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
    textStyle.color = textColor;
    textStyle.fontSize = 20;
    canvas.drawText(textElement.TextElement(this.value, style: textStyle),
        (bounds.left - 10).round(), -2);
  }
}
