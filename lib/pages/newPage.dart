import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';

class NewPagePage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: Text('Neue Seite'),
      ),
    );
  }
}
