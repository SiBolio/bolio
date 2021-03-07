
import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';

class DataPointHintCard extends StatelessWidget {
  final bool isSelected;
  final bool isDone;
  final String text;
  final Color accentColor;

  DataPointHintCard(this.isDone, this.isSelected, this.text, this.accentColor);

  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isSelected ? accentColor : Colors.transparent),
        borderRadius: BorderRadius.circular(15),
      ),
      color: ColorService.surfaceCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isDone
              ? Icon(Icons.done)
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 12.0,
                    color: isSelected ? accentColor : Colors.white,
                  ),
                ),
        ],
      ),
    );
  }
}