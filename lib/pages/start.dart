import 'package:bolio/pages/settingsPage.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PageView(
          children: <Widget>[
            TileGrid(),
            Container(
              child: Center(child: Text('2')),
            ),
            Container(
              child: Center(child: Text('3')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(),
            ),
          );
        },
        child: Icon(
          Icons.settings,
          color: ColorSerivce.constMainColorSub,
        ),
        backgroundColor: ColorSerivce.constMainColor,
      ),
    );
  }
}
