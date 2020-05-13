import 'package:flutter/material.dart';
import 'package:smarthome/Services/colorsService.dart';

class IconButtonService {
  BolioColors colorSrv;
  IconButtonService() {
    colorSrv = new BolioColors();
  }

  CircleAvatar getPageIcon(Icon icon) {
    return CircleAvatar(
      backgroundColor: Colors.blueGrey[200],
      child: new IconButton(
        icon: icon,
        onPressed: null,
      ),
    );
  }

  CircleAvatar getItemIcon(String type) {
    Icon returnIcon;
    Color returnColor = Colors.amber;
    Color iconColor = Colors.grey[900];

    switch (type) {
      case 'boolean':
        {
          returnColor = Colors.red[200];
          returnIcon = Icon(
            Icons.power_settings_new,
            color: iconColor,
          );
          break;
        }
      case 'number':
        {
          returnColor = Colors.purple[200];
          returnIcon = Icon(
            Icons.looks_one,
            color: iconColor,
          );
          break;
        }
      case 'value':
        {
          returnColor = Colors.indigo[200];
          returnIcon = Icon(
            Icons.data_usage,
            color: iconColor,
          );
          break;
        }
      case 'string':
        {
          returnColor = Colors.cyan[200];
          returnIcon = Icon(
            Icons.format_quote,
            color: iconColor,
          );
          break;
        }
      case 'object':
        {
          returnColor = Colors.deepOrange[200];
          returnIcon = Icon(
            Icons.extension,
            color: iconColor,
          );
          break;
        }
      case 'Einzelwert':
        {
          returnColor = Colors.green[200];
          returnIcon = Icon(
            Icons.bubble_chart,
            color: iconColor,
          );
          break;
        }
      case 'Graph':
        {
          returnColor = Colors.brown[200];
          returnIcon = Icon(
            Icons.trending_up,
            color: iconColor,
          );
          break;
        }
      case 'Slider':
        {
          returnColor = Colors.indigo[200];
          returnIcon = Icon(
            Icons.tune,
            color: iconColor,
          );
          break;
        }
      case 'Tür/Fensterkontakt':
        {
          returnColor = Colors.blue[200];
          returnIcon = Icon(
            Icons.lock_open,
            color: iconColor,
          );
          break;
        }
      case 'On/Off Button':
        {
          returnColor = Colors.pink[200];
          returnIcon = Icon(
            Icons.power_settings_new,
            color: iconColor,
          );
          break;
        }
      default:
        {
          returnColor = Colors.lime[200];
          returnIcon = Icon(
            Icons.device_unknown,
            color: iconColor,
          );
          break;
        }
    }

    return CircleAvatar(
      backgroundColor: returnColor,
      child: new IconButton(
        icon: returnIcon,
        onPressed: null,
      ),
    );
  }

  CircleAvatar getSelectIcon(bool isSelected) {
    return CircleAvatar(
      backgroundColor: isSelected? BolioColors.secondary: Colors.white60,
      child: new IconButton(
        icon: Icon(
          isSelected
              ? Icons.check_box
              : Icons.check_box_outline_blank,
          color:Colors.black,
        ),
        onPressed: null,
      ),
    );
  }
}
