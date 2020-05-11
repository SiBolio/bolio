import 'package:flutter/material.dart';
import 'package:smarthome/Pages/start.dart';
import 'package:smarthome/Services/colorsService.dart';

void main() {
  runApp(Smarthome());
}

class Smarthome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bolio',
      theme: ThemeData(
        primaryColorDark: BolioColors.primary,
        accentColor: BolioColors.secondary,
        brightness: Brightness.dark,
      ),
      home: StartPage(),
    );
  }
}
