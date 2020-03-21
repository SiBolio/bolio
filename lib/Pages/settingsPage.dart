import 'package:flutter/material.dart';
import 'package:smarthome/Services/saveService.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _edited = false;
  String _ipAdress = '';
  SaveService saveService = new SaveService();

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Center(child: Text('ToDo')),
      floatingActionButton: new Visibility(
        visible: _edited,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
