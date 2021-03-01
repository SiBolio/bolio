import 'package:bolio/pages/editWidgetPages/widgetOverviewPage.dart';
import 'package:bolio/pages/newWidgetPages/widgetTypePage.dart';
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
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: Text('Einstellungen'),
        backgroundColor: ColorSerivce.surface,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: ClipOval(
              child: Material(
                color: ColorSerivce.constMainColor,
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.add,
                    color: ColorSerivce.constMainColorSub,
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
                color: ColorSerivce.constMainColor,
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.edit,
                    color: ColorSerivce.constMainColorSub,
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

/*           ListTile(
            leading: Icon(
              Icons.edit_location_outlined,
              color: ColorSerivce.constMainColor,
            ),
            title: Text('Seiten bearbeiten'),
          ), */
        ],
      ),
    );
  }
}
