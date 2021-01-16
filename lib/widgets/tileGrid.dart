import 'package:bolio/widgets/smarthomeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TileGrid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TileGridState();
}

class _TileGridState extends State<TileGrid> {
  List<SmarthomeCard> cardList = [
    SmarthomeCard('yeelight-2.0.stripe-0x0000000004cddcef.control.power',
        'OnOffButton', 'M', 'sdf'),
    SmarthomeCard('yeelight-2.0.stripe-0x0000000004cddcef.control.power',
        'OnOffButton', 'S', 'sdfsdf'),
    SmarthomeCard('zigbee.0.00158d0002c99d77.humidity', 'SingleValue', 'M',
        'Luftfeuchtigkeit'),
    SmarthomeCard('zigbee.0.00158d0002c99d77.humidity', 'Graph', 'L',
        'Schreibtischlicht'),
  ];

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: _getCrossAxisCount(),
      itemCount: cardList.length,
      itemBuilder: (BuildContext context, int index) {
        return cardList[index];
      },
      staggeredTileBuilder: (int index) {
        var tileWidth;
        var tileHeight;
        if (cardList[index].tileSize == 'S') {
          tileWidth = 2;
          tileHeight = 1;
        } else if (cardList[index].tileSize == 'M') {
          tileWidth = 2;
          tileHeight = 2;
        } else if (cardList[index].tileSize == 'L') {
          tileWidth = 4;
          tileHeight = 2;
        }
        return new StaggeredTile.count(tileWidth, tileHeight);
      },
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
    );
  }

  _getCrossAxisCount() {
    int axisCount;
    double width = MediaQuery.of(context).size.width;
    if (width > 1300) {
      axisCount = 10;
    } else if (width > 1000) {
      axisCount = 8;
    } else if (width > 600) {
      axisCount = 6;
    } else {
      axisCount = 4;
    }
    return axisCount;
  }
}
