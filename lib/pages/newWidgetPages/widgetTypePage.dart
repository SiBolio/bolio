import 'package:bolio/models/saveModel.dart';
import 'package:bolio/pages/newWidgetPages/adapterSelectPage.dart';
import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WidgetTypePage extends StatefulWidget {
  String selectedItem = '';

  List<String> types = [
    'Einzelwert',
    'Graph',
    'On/Off Button',
    'Slider',
    'Licht'
  ];
  List<IconData> icons = [
    Icons.looks_two_outlined,
    Icons.bar_chart_sharp,
    Icons.power_settings_new,
    Icons.swipe,
    Icons.lightbulb_outline
  ];

  @override
  _WidgetTypePageState createState() => _WidgetTypePageState();
}

class _WidgetTypePageState extends State<WidgetTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: Text('Widgettyp'),
        backgroundColor: ColorSerivce.surface,
        elevation: 0.0,
        actions: <Widget>[
          Visibility(
            visible: widget.selectedItem != '',
            child: RawMaterialButton(
              onPressed: () {
                SaveModel saveCMD = new SaveModel();
                saveCMD.type = widget.selectedItem;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdapterSelectPage(saveCMD),
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
        staggeredTiles: List<StaggeredTile>.generate(5, (index) {
          return StaggeredTile.count(1, 1);
        }),
        children: getWidgetTypeCards(),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.all(4.0),
      ),
    );
  }

  List<Widget> getWidgetTypeCards() {
    return List<Widget>.generate(5, (index) {
      return GestureDetector(
          onTap: () {
            setState(() {
              widget.selectedItem = widget.types[index];
            });
          },
          child: WidgetTypeCard(widget.types[index], widget.icons[index],
              widget.selectedItem == widget.types[index]));
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
