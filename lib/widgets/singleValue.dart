import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';

class SingleValue extends StatefulWidget {
  final String text;
  final String id;
  final String value;
  SingleValue(this.text, this.id, this.value);

  @override
  State<StatefulWidget> createState() => _SingleValueState();
}

class _SingleValueState extends State<SingleValue> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorSerivce.surfaceCard,
      child: Column(
        children: <Widget>[
          Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: LayoutBuilder(
              builder: (context, constraint) {
                return FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(widget.value),
                );
              },
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(widget.text),
                  )),
            ),
          )
        ],
      ),
    );
  }
}