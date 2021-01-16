import 'package:bolio/pages/start.dart';
import 'package:bolio/services/socketService.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bolio',
      darkTheme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amber,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: _setSocket(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return StartPage();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<bool> _setSocket() async {
    globals.socketService = new SocketService();
    globals.socketService.setSocket(await globals.socketService
        .getSocket(globals.ipAddress, globals.socketPort));
    return true;
  }
}
