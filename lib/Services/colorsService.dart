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

  Color getPopupColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF424242)
        : null;
  }

  Color getGraphLabelColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[200]
        : Colors.grey[700];
  }

  Color getButtonColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1b1b1b)
        : null;
  }
}
