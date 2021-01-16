import 'package:bolio/models/adapterModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:flutter/material.dart';

class AdapterCard extends StatelessWidget {
  final AdapterModel adapter;
  AdapterCard(this.adapter);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorSerivce.surfaceCard,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
            child: Text(
              adapter.title,
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.network(
                adapter.iconUrl,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Text('-');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
