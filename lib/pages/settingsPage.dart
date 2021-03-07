import 'package:bolio/pages/editWidgetPages/widgetOverviewPage.dart';
import 'package:bolio/pages/networkSettingPage.dart';
import 'package:bolio/pages/newWidgetPages/widgetTypePage.dart';
import 'package:bolio/pages/setIpAddressPage.dart';
import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorService.surface,
      appBar: AppBar(
        title: Text('Einstellungen'),
        backgroundColor: ColorService.surface,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: ClipOval(
              child: Material(
                color: ColorService.iconColorRedDark,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.add,
                    color: ColorService.iconColorRedLight,
                  ),
                ),
              ),
            ),
            title: Text('Neues Widget hinzufügen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WidgetTypePage()),
              );
            },
          ),
          ListTile(
            leading: ClipOval(
              child: Material(
                color: ColorService.iconColorIndigoDark,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.edit,
                    color: ColorService.iconColorIndigoLight,
                  ),
                ),
              ),
            ),
            title: Text('Widgets bearbeiten'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WidgetOverviewPage()),
              );
            },
          ),
          ListTile(
            leading: ClipOval(
              child: Material(
                color: ColorService.iconColorLightGreenDark,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.network_check,
                    color: ColorService.iconColorLightGreenLight,
                  ),
                ),
              ),
            ),
            title: Text('Netzwerkeinstellungen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NetworkSettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
