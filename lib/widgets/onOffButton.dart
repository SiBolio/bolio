import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

class OnOffButton extends StatefulWidget {
  final String text;
  final String id;
  final bool isOn;
  final String tileSize;
  OnOffButton(this.text, this.id, this.isOn, this.tileSize);

  @override
  State<StatefulWidget> createState() => _OnOffButtonState();
}

class _OnOffButtonState extends State<OnOffButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        globals.socketService.setState(widget.id, !widget.isOn);
      },
      child: Card(
        color: widget.isOn
            ? ColorSerivce.constMainColor
            : ColorSerivce.surfaceCard,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorSerivce.constMainColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Icon(
                Icons.power_settings_new_sharp,
                size: 50,
                color: widget.isOn ? ColorSerivce.constMainColorSub: ColorSerivce.constMainColor,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isOn ? ColorSerivce.constMainColorSub : Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
