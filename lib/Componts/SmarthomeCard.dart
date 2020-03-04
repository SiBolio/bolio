import 'package:flutter/material.dart';

class SmarthomeCard extends StatefulWidget {
  @override
  _SmarthomeCardState createState() => _SmarthomeCardState();
}

class _SmarthomeCardState extends State<SmarthomeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
        ],
      ),
    );
  }
}
