import 'package:bolio/main.dart';
import 'package:bolio/pages/editWidgetPages/widgetOverviewPage.dart';
import 'package:bolio/pages/newWidgetPages/widgetTypePage.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/settingsService.dart';
import 'package:flutter/material.dart';

class SetIpAddressPage extends StatefulWidget {
  @override
  _SetIpAddressPageState createState() => _SetIpAddressPageState();

  SettingsService settingsService;

  SetIpAddressPage() {
    settingsService = new SettingsService();
  }
}

class _SetIpAddressPageState extends State<SetIpAddressPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController ipController = new TextEditingController();
    ipController.text = '192.168.178.122';
    TextEditingController portSimpleAPIController = new TextEditingController();
    portSimpleAPIController.text = '8087';
    TextEditingController portSocketIOController = new TextEditingController();
    portSocketIOController.text = '8084';

    return Scaffold(
      backgroundColor: ColorService.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/logo.png'),
                height: 50,
              ),
              TextFormField(
                controller: ipController,
                decoration: InputDecoration(labelText: 'IP Adresse'),
              ),
              TextFormField(
                controller: portSimpleAPIController,
                decoration: InputDecoration(labelText: 'simpleAPI Port'),
              ),
              TextFormField(
                controller: portSocketIOController,
                decoration: InputDecoration(labelText: 'socket.io Port'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ElevatedButton(
                  child: const Text(
                    'Speichern',
                    style: TextStyle(
                        fontSize: 20, color: ColorService.constMainColorSub),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        widget.settingsService.setIpAddress(ipController.text);
                        widget.settingsService
                            .setPortSimpleAPI(portSimpleAPIController.text);
                        widget.settingsService
                            .setPortSocketIO(portSocketIOController.text);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BolioApp()),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
