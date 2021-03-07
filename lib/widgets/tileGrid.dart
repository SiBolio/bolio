import 'package:bolio/models/saveModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/saveService.dart';
import 'package:bolio/widgets/smarthomeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TileGrid extends StatefulWidget {
  SaveService saveService;

  @override
  State<StatefulWidget> createState() => _TileGridState();

  TileGrid() {
    saveService = new SaveService();
  }
}

class _TileGridState extends State<TileGrid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SaveModel>>(
      future: widget.saveService.getAllFavorites(),
      builder: (context, AsyncSnapshot<List<SaveModel>> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return snapshot.data.length > 0
              ? StaggeredGridView.countBuilder(
                  crossAxisCount: _getCrossAxisCount(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SmarthomeCard(
                      snapshot.data[index].objectId,
                      snapshot.data[index].type,
                      snapshot.data[index].size,
                      snapshot.data[index].name,
                      snapshot.data[index].secondaryObjectId,
                      snapshot.data[index].timeSpan,
                    );
                  },
                  staggeredTileBuilder: (int index) {
                    var tileWidth;
                    var tileHeight;
                    if (snapshot.data[index].size == 'M') {
                      tileWidth = 1;
                      tileHeight = 1;
                    } else if (snapshot.data[index].size == 'L') {
                      tileWidth = 3;
                      tileHeight = 1.5;
                    }
                    return new StaggeredTile.count(tileWidth, tileHeight);
                  },
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                )
              : Center(
                  child: Text(
                    'Wechseln sie in die Einstellungen um Widgets anzulegen',
                    style: TextStyle(
                      fontSize: 25,
                      color: ColorService.constMainColorSub,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
        } else {
          return CircularProgressIndicator();
        }
      },
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
      axisCount = 3;
    }
    return axisCount;
  }
}
