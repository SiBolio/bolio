import 'package:flutter/material.dart';
import 'package:smarthome/Componts/SmarthomeCard.dart';
import 'package:smarthome/Pages/allAdapterPage.dart';
import 'settingsPage.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smarthome'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SmarthomeCard(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllAdapterPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
