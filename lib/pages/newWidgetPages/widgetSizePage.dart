import 'package:bolio/models/saveModel.dart';
import 'package:bolio/pages/newWidgetPages/adapterSelectPage.dart';
import 'package:bolio/pages/newWidgetPages/summaryPage.dart';
import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WidgetSizePage extends StatefulWidget {
  String selectedSize = '';

  List<String> types = [
    'Breites Widget',
    'Standard Widget',
  ];

  List<String> size = [
    'L',
    'M',
  ];
  List<IconData> icons = [
    Icons.panorama_wide_angle,
    Icons.panorama_vertical_sharp,
  ];

  SaveModel saveCMD;

  WidgetSizePage(this.saveCMD);

  @override
  _WidgetSizePageState createState() => _WidgetSizePageState();
}

class _WidgetSizePageState extends State<WidgetSizePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: Text('Widgetgröße'),
        backgroundColor: ColorSerivce.surface,
        elevation: 0.0,
        actions: <Widget>[
          Visibility(
            visible: widget.selectedSize != '',
            child: RawMaterialButton(
              onPressed: () {
                widget.saveCMD.size = widget.selectedSize;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryPage(widget.saveCMD),
                  ),
                );
              },
              elevation: 2.0,
              fillColor: ColorSerivce.constMainColor,
              child: Icon(
                Icons.arrow_forward_ios_sharp,
              ),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 3,
        staggeredTiles: [
          StaggeredTile.count(3, 1.5),
          StaggeredTile.count(1, 1),
        ],
        children: getWidgetTypeCards(),
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        padding: const EdgeInsets.all(4.0),
      ),
    );
  }

  List<Widget> getWidgetTypeCards() {
    return List<Widget>.generate(2, (index) {
      return GestureDetector(
          onTap: () {
            setState(() {
              widget.selectedSize = widget.size[index];
            });
          },
          child: WidgetTypeCard(widget.types[index], widget.icons[index],
              widget.selectedSize == widget.size[index]));
    });
  }
}

class WidgetTypeCard extends StatelessWidget {
  final String text;
  final IconData iconData;
  bool isSelected;

  WidgetTypeCard(this.text, this.iconData, this.isSelected);

  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color:
          isSelected ? ColorSerivce.constMainColor : ColorSerivce.surfaceCard,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Icon(
              iconData,
              color: isSelected
                  ? ColorSerivce.constMainColorSub
                  : ColorSerivce.constMainColor,
              size: 38.0,
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 14.0,
                color:
                    isSelected ? ColorSerivce.constMainColorSub : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
