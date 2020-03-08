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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _loadIpAddress(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.network_locked),
                    hintText: 'IP Adresse und Port vom ioBroker',
                    labelText: 'IP Adresse',
                  ),
                  onChanged: (ipAdress) {
                    _ipAdress = ipAdress;
                    setState(() {
                      _edited = true;
                    });
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Es ist ein Fehler aufgetretn');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
      floatingActionButton: new Visibility(
        visible: _edited,
        child: FloatingActionButton(
          onPressed: () {
            _save();
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  _save() {
    saveService.saveIpAddress(_ipAdress);
  }

  Future<String> _loadIpAddress() {
    return Future(null);
    // saveService.getIpAddress();
  }
}
