import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

class SliderWidget extends StatefulWidget {
  final String text;
  final String objectId;
  final double sliderValue;
  final String tileSize;
  final String secondayObjectId;

  SliderWidget(
    this.text,
    this.objectId,
    this.sliderValue,
    this.tileSize, [
    this.secondayObjectId,
  ]);

  @override
  State<StatefulWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorSerivce.surfaceCard,
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
              child: Slider(
                activeColor: ColorSerivce.constMainColor,
                max: 100,
                min: 0,
                value: widget.sliderValue,
                onChanged: (selection) {
                  globals.socketService
                      .setState(widget.objectId, selection);
                  setState(() {});
                },
              )),
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
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
