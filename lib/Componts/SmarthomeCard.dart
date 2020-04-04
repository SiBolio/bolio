import 'package:flutter/material.dart';

class SmarthomeCard extends StatefulWidget {
  String id;
  String title;

  SmarthomeCard({this.id, this.title});

  @override
  _SmarthomeCardState createState() => _SmarthomeCardState();
}

class _SmarthomeCardState extends State<SmarthomeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(widget.title),
      ),
    );
  }
}
