import 'package:bolio/models/saveModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/saveService.dart';
import 'package:flutter/material.dart';

class WidgetOverviewPage extends StatefulWidget {
  SaveService saveService;
  List<SaveModel> widgets = [];

  @override
  _WidgetOverviewPageState createState() => _WidgetOverviewPageState();

  WidgetOverviewPage() {
    saveService = new SaveService();
  }
}

class _WidgetOverviewPageState extends State<WidgetOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: Text('Widgets bearbeiten'),
        backgroundColor: ColorSerivce.surface,
        elevation: 0.0,
      ),
      body: Center(
        child: widget.widgets.length == 0
            ? FutureBuilder<List<SaveModel>>(
                future: widget.saveService.getAllFavorites(),
                builder: (context, AsyncSnapshot<List<SaveModel>> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    widget.widgets = snapshot.data;
                    return buildReorderableListView(widget.widgets);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            : buildReorderableListView(widget.widgets),
      ),
    );
  }

  ReorderableListView buildReorderableListView(List<SaveModel> widgets) {
    return ReorderableListView(
      children: <Widget>[
        for (var i = 0; i < widgets.length; i += 1)
          ListTile(
              key: ValueKey(i),
              title: Text(widgets[i].name),
              subtitle: Text(widgets[i].objectId),
              leading: ClipOval(
                child: Material(
                  color: ColorSerivce.constMainColor,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Icon(
                      _getLeadingIconData(widgets[i].type),
                      color: ColorSerivce.constMainColorSub,
                    ),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Widget löschen',
                onPressed: () {
                  setState(() {
                    widget.saveService.deleteWidget(widgets[i]);
                    widget.widgets.removeAt(i);
                  });
                },
              ),
              onTap: () {
                _showBottomSheet(widgets[i], i, context);
              }),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          widget.widgets.insert(newIndex, widget.widgets[oldIndex]);
          if (newIndex > oldIndex) {
            widget.widgets.removeAt(oldIndex);
          } else {
            widget.widgets.removeAt(oldIndex + 1);
          }
          widget.saveService.updateWidgetList(widget.widgets);
        });
      },
    );
  }

  IconData _getLeadingIconData(String type) {
    switch (type) {
      case 'Einzelwert':
        {
          return Icons.looks_two_outlined;
        }
        break;
      case 'Graph':
        {
          return Icons.bar_chart_sharp;
        }
        break;
      case 'On/Off Button':
        {
          return Icons.power_settings_new;
        }
        break;
      case 'Slider':
        {
          return Icons.swipe;
        }
        break;
      case 'Licht':
        {
          return Icons.lightbulb_outline;
        }
        break;
      default:
        {
          return null;
        }
        break;
    }
  }

  _showBottomSheet(SaveModel item, int index, BuildContext context) {
    String widgetName = item.name;
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: ColorSerivce.surfaceCard,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  initialValue: item.name,
                  decoration: InputDecoration(labelText: 'Widgetname'),
                  onChanged: (value) {
                    widgetName = value;
                  },
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      child: Text('Löschen'),
                      onPressed: () {
                        setState(() {
                          widget.saveService
                              .deleteWidget(widget.widgets[index]);
                          widget.widgets.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.widgets[index].name = widgetName;
                          widget.saveService.updateWidgetList(widget.widgets);
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Speichern'),
                    )
                  ],
                  alignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
