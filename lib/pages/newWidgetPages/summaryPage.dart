import 'package:bolio/models/saveModel.dart';
import 'package:bolio/pages/start.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/saveService.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  String widgetName = '';
  String minimum;
  String maximum;
  String timeSpan = '7';
  SaveService saveService;
  SaveModel saveCMD;

  @override
  _SummaryPageState createState() => _SummaryPageState();

  SummaryPage(this.saveCMD) {
    this.widgetName = this.saveCMD.name;
    this.saveService = new SaveService();
  }
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorService.surface,
      appBar: AppBar(
        title: Text('Sonstige Einstellungen'),
        backgroundColor: ColorService.surface,
        elevation: 0.0,
        actions: <Widget>[
          RawMaterialButton(
            onPressed: () {
              widget.saveCMD.minimum = widget.minimum;
              widget.saveCMD.maximum = widget.maximum;
              widget.saveCMD.name = widget.widgetName;
              widget.saveCMD.timeSpan = widget.timeSpan;
              widget.saveService.saveWidget(widget.saveCMD);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => StartPage()),
                  (Route<dynamic> route) => false);
            },
            elevation: 2.0,
            fillColor: ColorService.constAccentColor,
            child: Icon(
              Icons.save,
            ),
            shape: CircleBorder(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: ColorService.settingsCard,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'Widgetname',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextFormField(
                      initialValue: widget.saveCMD.name,
                      decoration: InputDecoration(labelText: 'Widgetname'),
                      onChanged: (value) {
                        widget.widgetName = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: widget.saveCMD.type == 'Graph' ||
                  widget.saveCMD.type == 'Balkendiagramm',
              child: Card(
                color: ColorService.settingsCard,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        'Zeitraum für den Graph (Tage)',
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: Slider(
                              activeColor: ColorService.constMainColor,
                              max: 100,
                              min: 1,
                              divisions: 100,
                              value: double.parse(widget.timeSpan),
                              onChanged: (selection) {
                                setState(() {
                                  widget.timeSpan =
                                      selection.round().toString();
                                });
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              widget.timeSpan + ' T.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.saveCMD.type == 'Graph' ||
                  widget.saveCMD.type == 'Balkendiagramm',
              child: Card(
                color: ColorService.settingsCard,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        'Grenzwerte',
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: '',
                                decoration:
                                    InputDecoration(labelText: 'Minimum'),
                                onChanged: (value) {
                                  widget.minimum = value;
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: '',
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Maximum'),
                                onChanged: (value) {
                                  widget.maximum = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
