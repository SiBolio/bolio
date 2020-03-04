import 'package:flutter/material.dart';
import 'package:smarthome/Pages/start.dart';

void main() => runApp(Smarthome());

class Smarthome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: StartPage(),
    );
  }
}
