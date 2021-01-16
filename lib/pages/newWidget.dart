import 'package:bolio/services/colorService.dart';
import 'package:bolio/widgets/newWidgetStepper.dart';
import 'package:flutter/material.dart';

class NewWidgetPage extends StatefulWidget {
  @override
  _NewWidgetPageState createState() => _NewWidgetPageState();
}

class _NewWidgetPageState extends State<NewWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: Text('Neues Widget'),
      ),
      body: NewWidgetStepper(),
    );
  }
}
