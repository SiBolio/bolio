import 'package:bolio/models/adapterModel.dart';
import 'package:bolio/models/saveModel.dart';
import 'package:bolio/pages/newWidgetPages/dataPointPage.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/httpService.dart';
import 'package:bolio/services/settingsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AdapterSelectPage extends StatefulWidget {
  HttpService httpService;
  SettingsService settingsService;

  String selectedItem = '';
  List<AdapterModel> adapterModels = [];
  SaveModel saveCMD;

  @override
  _AdapterSelectPageState createState() => _AdapterSelectPageState();

  AdapterSelectPage(this.saveCMD) {
    httpService = new HttpService();
    settingsService = new SettingsService();
  }
}

class _AdapterSelectPageState extends State<AdapterSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorService.surface,
      appBar: AppBar(
        title: Text('Adapterauswahl'),
        backgroundColor: ColorService.surface,
        elevation: 0.0,
        actions: <Widget>[
          Visibility(
            visible: widget.selectedItem != '',
            child: RawMaterialButton(
              onPressed: () {
                widget.saveCMD.adapterId = widget.selectedItem;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataPointPage(widget.saveCMD),
                  ),
                );
              },
              elevation: 2.0,
              fillColor: ColorService.constAccentColor,
              child: Icon(
                Icons.arrow_forward_ios_sharp,
              ),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
      body: widget.adapterModels.length == 0
          ? FutureBuilder<bool>(
              future: _setAdapterCards(),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> _adapterCards) {
                if (_adapterCards.hasData &&
                    _adapterCards.connectionState == ConnectionState.done) {
                  return StaggeredGridView.count(
                    crossAxisCount:
                        widget.settingsService.getCrossAxisCount(context),
                    staggeredTiles: List<StaggeredTile>.generate(
                        widget.adapterModels.length, (index) {
                      return StaggeredTile.count(1, 1);
                    }),
                    children: getWidgetTypeCards(),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    padding: const EdgeInsets.all(4.0),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : StaggeredGridView.count(
              crossAxisCount: widget.settingsService.getCrossAxisCount(context),
              staggeredTiles: List<StaggeredTile>.generate(
                  widget.adapterModels.length, (index) {
                return StaggeredTile.count(1, 1);
              }),
              children: getWidgetTypeCards(),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              padding: const EdgeInsets.all(4.0),
            ),
    );
  }

  Future<bool> _setAdapterCards() async {
    widget.adapterModels = await widget.httpService.getAllAdapters();
    return true;
  }

  List<Widget> getWidgetTypeCards() {
    return List<Widget>.generate(widget.adapterModels.length, (index) {
      return GestureDetector(
          onTap: () {
            setState(() {
              widget.selectedItem = widget.adapterModels[index].name;
            });
          },
          child: AdapterCard(widget.adapterModels[index],
              widget.selectedItem == widget.adapterModels[index].name));
    });
  }
}

class AdapterCard extends StatelessWidget {
  final AdapterModel adapter;
  bool isSelected;
  AdapterCard(this.adapter, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color:
          isSelected ? ColorService.constMainColor : ColorService.surfaceCard,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: adapter.iconUrl.startsWith('http')
                  ? Image.network(
                      adapter.iconUrl,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Text(' - ');
                      },
                    )
                  : Text(' - '),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0, right: 3.0),
              child: Text(
                adapter.title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 14.0,
                  color: isSelected
                      ? ColorService.constMainColorSub
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
