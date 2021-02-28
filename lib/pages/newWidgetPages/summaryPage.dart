import 'package:bolio/models/saveModel.dart';
import 'package:bolio/pages/start.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/saveService.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  String widgetName = '';
  SaveService saveService;
  SaveModel saveCMD;

  @override
  _SummaryPageState createState() => _SummaryPageState();

  SummaryPage(this.saveCMD) {
    this.saveService = new SaveService();
  }
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: Text('Sonstige Einstellungen'),
        backgroundColor: ColorSerivce.surface,
        elevation: 0.0,
        actions: <Widget>[
          RawMaterialButton(
            onPressed: () {
              widget.saveCMD.name = widget.widgetName;
              widget.saveService.saveWidget(widget.saveCMD);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StartPage(),
                ),
              );
            },
            elevation: 2.0,
            fillColor: ColorSerivce.constMainColor,
            child: Icon(
              Icons.save,
            ),
            shape: CircleBorder(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: TextFormField(
          initialValue: widget.widgetName,
          decoration: InputDecoration(labelText: 'Widgetname'),
          onChanged: (value) {
            widget.widgetName = value;
          },
        ),
      ),
    );
  }
}
