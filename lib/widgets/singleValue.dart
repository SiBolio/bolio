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
      color: ColorService.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 1, minHeight: 1),
                  child: Text(widget.value),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
