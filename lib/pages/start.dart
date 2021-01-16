import 'package:bolio/pages/newPage.dart';
import 'package:bolio/pages/newWidget.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/widgets/tileGrid.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: ColorSerivce.surface,
      appBar: _getAppBar(),
      body: TileGrid(),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: Text('Bolio'),
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if (value == 1) {
                    return NewWidgetPage();
                  } else {
                    return NewPagePage();
                  }
                },
              ),
            );
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Icon(Icons.add),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Widget hinzufügen'),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: <Widget>[
                  Icon(Icons.add),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Seite hinzufügen'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
