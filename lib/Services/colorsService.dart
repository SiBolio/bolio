import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class BolioColors {
  RandomColor _randomColor;
  BolioColors() {
    _randomColor = RandomColor();
  }

  static const surface = Color(0xFF121212);
  static const secondary = Color(0xFF14cba8);
  static const primary = Color(0xFF14cba8);
  static const surfaceCard = Color(0xFF1b1b1b);
  static const dangerCard = Color(0xFF494949);
  static const dangerLine = Color(0xFFf44336);
  static const dropDown = Color(0xFF303030);


  Color getGaugeInactivColor(context) {
     return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]
        : Colors.grey[400];
  }

  getRandomColorLight() {
    return _randomColor.randomColor(colorBrightness: ColorBrightness.light);
  }

  Color getCardFontColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[400]
        : Colors.grey[900];
  }

  Color getIconColor(String switchValue, context) {
    if (switchValue == 'true') {
      return Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.grey[900];
    } else {
      return Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[600]
          : Colors.grey[400];
    }
  }

  Color getDropDownBackgroundColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dropDown
        : Color(0xFFe0f2f1);
  }

  Color getPopupColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF424242)
        : null;
  }

  Color getGraphLabelColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[400]
        : Colors.grey[700];
  }

  Color getButtonColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1b1b1b)
        : null;
  }

  Color getSetPointColorLineGraph(
      String value, double min, double max, context) {
    if (min != null) {
      if (double.parse(value) < min) {
        return BolioColors.dangerLine;
      }
    }
    if (max != null) {
      if (double.parse(value) > max) {
        return BolioColors.dangerLine;
      }
    }
    return Theme.of(context).brightness == Brightness.dark
        ? BolioColors.surfaceCard
        : Colors.transparent;
  }

  Color getNavigationCanvas(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1b1b1b)
        : Colors.grey[100];
  }

  Color getNavigationInactiv(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[400]
        : Colors.grey[600];
  }

}
