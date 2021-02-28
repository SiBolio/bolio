import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';
import 'package:bolio/services/globals.dart' as globals;

class Light extends StatefulWidget {
  final String text;
  final String objectId;
  final bool isOn;
  final String tileSize;
  final String secondayObjectId;

  Light(
    this.text,
    this.objectId,
    this.isOn,
    this.tileSize, [
    this.secondayObjectId,
  ]);

  @override
  State<StatefulWidget> createState() => _LightState();
}

class _LightState extends State<Light> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        globals.socketService.setState(widget.objectId, !widget.isOn);
      },
      onLongPress: () {
        _showBottomSheet(context);
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
                Icons.lightbulb_outline_sharp,
                size: 50,
                color: widget.isOn
                    ? ColorSerivce.constMainColorSub
                    : ColorSerivce.constMainColor,
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

  _showBottomSheet(BuildContext context) {
    double sliderValue = 0;
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: ColorSerivce.surfaceCard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Helligkeit ' + widget.text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              FutureBuilder(
                future:
                    globals.httpService.getObjectValue(widget.secondayObjectId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    sliderValue = double.parse(snapshot.data);
                    return StatefulBuilder(builder: (context, setState) {
                      return Slider(
                        activeColor: ColorSerivce.constMainColor,
                        max: 100,
                        min: 0,
                        value: sliderValue,
                        onChanged: (selection) {
                          globals.socketService
                              .setState(widget.secondayObjectId, selection);
                          setState(() {
                            sliderValue = selection;
                          });
                        },
                      );
                    });
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
