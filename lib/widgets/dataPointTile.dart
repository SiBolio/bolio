import 'package:bolio/models/dataPointNode.dart';
import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';

class DataPointTile extends StatelessWidget {
  const DataPointTile({
    Key key,
    @required this.child,
    this.isSelectedPrimary,
    this.isSelectedSecondary,
  }) : super(key: key);

  final DataPointNode child;
  final bool isSelectedPrimary;
  final bool isSelectedSecondary;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Material(
          color: ColorService.constMainColor,
          child: SizedBox(
              width: 40, height: 40, child: Icon(_getTileIcon(child.type))),
        ),
      ),
      tileColor: _getDataPointTileColor(),
      title: child.name != null
          ? Text(
              child.dataPointName,
              style: TextStyle(
                  color: isSelectedPrimary || isSelectedSecondary
                      ? Colors.black
                      : Colors.white),
            )
          : Text('-'),
      subtitle: child.objectId != null
          ? Text(
              child.objectId,
              style: TextStyle(
                  color: isSelectedPrimary || isSelectedSecondary
                      ? Colors.black
                      : Colors.white),
            )
          : Text('-'),
    );
  }

  Color _getDataPointTileColor() {
    if (isSelectedPrimary) {
      return ColorService.selectionPrimary;
    } else if (isSelectedSecondary) {
      return ColorService.selectionSecondary;
    } else {
      return null;
    }
  }

  IconData _getTileIcon(String type) {
    switch (type) {
      case 'boolean':
        return Icons.power_settings_new;
        break;
      case 'number':
        return Icons.looks_two;
        break;
      case 'string':
        return Icons.short_text;
        break;
      case 'value':
        return Icons.money_outlined;
        break;
      case 'text':
        return Icons.text_snippet;
        break;
      default:
        print('Typ:' + type.toString());
        return Icons.circle;
        break;
    }
  }
}