
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Pages/start.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(Smarthome());
}

class Smarthome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bolio',
      theme: ThemeData(
        accentColor: Colors.tealAccent,
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: StartPage(),
    );
  }
}
