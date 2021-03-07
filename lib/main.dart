import 'package:bolio/pages/setIpAddressPage.dart';
import 'package:bolio/pages/start.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/settingsService.dart';
import 'package:bolio/services/socketService.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

void main() {
  runApp(BolioApp());
}

class BolioApp extends StatefulWidget {
  @override
  _BolioAppState createState() => _BolioAppState();
}

class _BolioAppState extends State<BolioApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bolio',
      darkTheme: ThemeData(
        accentColor: Colors.blueGrey,
        primarySwatch: ColorService.primarySwatch,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _setIpAddress(),
        builder: (BuildContext context, AsyncSnapshot<bool> ipAddressSnapshot) {
          if (ipAddressSnapshot.hasData &&
              ipAddressSnapshot.connectionState == ConnectionState.done) {
            if (!ipAddressSnapshot.data) {
              return SetIpAddressPage();
            } else {
              return FutureBuilder<bool>(
                future: _setSocket(),
                builder:
                    (BuildContext context, AsyncSnapshot<bool> socketSnapshot) {
                  if (socketSnapshot.hasData &&
                      socketSnapshot.connectionState == ConnectionState.done) {
                    return StartPage();
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            }
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

  Future<bool> _setIpAddress() async {
    SettingsService settingsService = new SettingsService();
    globals.ipAddress = await settingsService.getIpAddress();
    globals.socketPort = await settingsService.getSocketIOPort();
    globals.httpPort = await settingsService.getSimpleAPIPort();
    if (globals.ipAddress == null ||
        globals.socketPort == null ||
        globals.httpPort == null) {
      return false;
    }
    return true;
  }
}
