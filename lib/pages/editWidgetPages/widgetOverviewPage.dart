import 'package:bolio/models/saveModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/saveService.dart';
import 'package:flutter/material.dart';

class WidgetOverviewPage extends StatefulWidget {
  SaveService saveService;

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
      body: FutureBuilder<List<SaveModel>>(
        future: widget.saveService.getAllFavorites(),
        builder: (context, AsyncSnapshot<List<SaveModel>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].type),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: 'Widget löschen',
                    onPressed: () {
                      setState(() {
                        widget.saveService.deleteWidget(snapshot.data[index]);
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
