import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Pages/start.dart';
import 'package:smarthome/Services/colorsService.dart';

void main() {
  runApp(Smarthome());
}

class Smarthome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) {
        if (brightness == Brightness.dark) {
          return new ThemeData(
            primaryColorDark: BolioColors.primary,
            accentColor: BolioColors.secondary,
            brightness: brightness,
          );
        } else {
          return new ThemeData(
            primaryColor: BolioColors.primary,
            accentColor: BolioColors.secondary,
            brightness: brightness,
            primarySwatch: Colors.grey,
          );
        }
      },
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bolio',
          theme: theme,
          home: StartPage(),
        );
      },
    );
  }
}
