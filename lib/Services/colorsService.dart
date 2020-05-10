import 'dart:ui';

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
}
