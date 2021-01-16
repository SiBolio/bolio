import 'package:auto_size_text/auto_size_text.dart';
import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

class OnOffButton extends StatefulWidget {
  final String text;
  final String id;
  final bool isOn;
  OnOffButton(this.text, this.id, this.isOn);

  @override
  State<StatefulWidget> createState() => _OnOffButtonState();
}

class _OnOffButtonState extends State<OnOffButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.amber,
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        globals.socketService.setState(widget.id, !widget.isOn);
      },
      child: Card(
        color: ColorSerivce.surfaceCard,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: widget.isOn ? Colors.amber : Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Icon(
                  Icons.power_settings_new_sharp,
                  color: widget.isOn ? Colors.amber : Colors.white,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(widget.text),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
