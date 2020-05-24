import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:smarthome/Services/colorsService.dart';


class GaugeGraph extends StatelessWidget {
  BolioColors bolioColors;
  final List<charts.Series> seriesList;
  final bool animate;

  GaugeGraph(this.seriesList, {this.animate}) {
    bolioColors = new BolioColors();
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 12, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi));
  }
}
