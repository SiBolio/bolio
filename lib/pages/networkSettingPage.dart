import 'package:bolio/main.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/settingsService.dart';
import 'package:flutter/material.dart';

class NetworkSettingsPage extends StatefulWidget {
  @override
  _NetworkSettingsPageState createState() => _NetworkSettingsPageState();

  SettingsService settingsService;

  TextEditingController ipController = new TextEditingController();
  TextEditingController portSimpleAPIController = new TextEditingController();
  TextEditingController portSocketIOController = new TextEditingController();

  NetworkSettingsPage() {
    settingsService = new SettingsService();
  }
}

class _NetworkSettingsPageState extends State<NetworkSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorService.surface,
      appBar: AppBar(
        title: Text('Netzwerkeinstellungen'),
        backgroundColor: ColorService.surface,
        elevation: 0.0,
      ),
      body: FutureBuilder<bool>(
          future: _setIpAddress(),
          builder:
              (BuildContext context, AsyncSnapshot<bool> ipAddressSnapshot) {
            if (ipAddressSnapshot.hasData &&
                ipAddressSnapshot.connectionState == ConnectionState.done) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: widget.ipController,
                        decoration: InputDecoration(labelText: 'IP Adresse'),
                      ),
                      TextFormField(
                        controller: widget.portSimpleAPIController,
                        decoration:
                            InputDecoration(labelText: 'simpleAPI Port'),
                      ),
                      TextFormField(
                        controller: widget.portSocketIOController,
                        decoration:
                            InputDecoration(labelText: 'socket.io Port'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: ElevatedButton(
                          child: const Text(
                            'Speichern',
                            style: TextStyle(
                                fontSize: 20,
                                color: ColorService.constMainColorSub),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                widget.settingsService
                                    .setIpAddress(widget.ipController.text);
                                widget.settingsService.setPortSimpleAPI(
                                    widget.portSimpleAPIController.text);
                                widget.settingsService.setPortSocketIO(
                                    widget.portSocketIOController.text);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BolioApp()),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Future<bool> _setIpAddress() async {
    widget.ipController.text = await widget.settingsService.getIpAddress();
    widget.portSimpleAPIController.text =
        await widget.settingsService.getSimpleAPIPort();
    widget.portSocketIOController.text =
        await widget.settingsService.getSocketIOPort();
    return true;
  }
}
