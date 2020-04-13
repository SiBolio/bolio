import 'package:flutter/material.dart';
import 'package:smarthome/Services/httpService.dart';
import 'lineGraph.dart';

class SmarthomeCard extends StatefulWidget {
  final String id;
  final String title;
  final String objectType;
  final String tileSize;
  final String timeSpan;

  SmarthomeCard({this.id, this.title, this.objectType, this.tileSize, this.timeSpan});

  @override
  _SmarthomeCardState createState() => _SmarthomeCardState();
}

class _SmarthomeCardState extends State<SmarthomeCard> {
  HttpService http = new HttpService();

  bool switchValue;
  double sliderValue;

  @override
  Widget build(BuildContext context) {
    if (widget.objectType == 'Slider') {
      if (sliderValue == null) {
        return FutureBuilder(
          future: http.getObjectValue(widget.id),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              sliderValue = double.parse(snapshot.data);
              return _getSliderCard();
            } else
              return CircularProgressIndicator();
          },
        );
      } else {
        return _getSliderCard();
      }
    } else if (widget.objectType == 'Einzelwert') {
      return Card(
        color: Colors.grey[900],
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Flexible(
              child: FutureBuilder(
                future: http.getObjectValue(widget.id),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Text(
                        snapshot.data,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      );
    } else if (widget.objectType == 'On/Off Button') {
      if (switchValue == null) {
        return FutureBuilder(
          future: http.getObjectValue(widget.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == 'true') {
                switchValue = true;
              } else {
                switchValue = false;
              }
              return _getOnOffCard();
            } else {
              return Text('-');
            }
          },
        );
      } else {
        return _getOnOffCard();
      }
    } else if (widget.objectType == 'Graph') {
      return Card(
        color: Colors.grey[900],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: http.getHistory(widget.id, widget.timeSpan),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (widget.tileSize == 'L') {
                    return Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 7,
                            child: LineGraph(snapshot.data),
                          ),
                          Flexible(
                            flex: 3,
                            child: FutureBuilder(
                              future: http.getObjectValue(widget.id),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      snapshot.data,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Flexible(
                      child: LineGraph(snapshot.data),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget _getSliderCard() {
    return Card(
      color: Colors.grey[900],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[400],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Slider(
            activeColor: Colors.tealAccent,
            min: 0,
            max: 100,
            value: sliderValue,
            divisions: 10,
            inactiveColor: Colors.transparent,
            onChanged: (value) {
              setState(() {
                sliderValue = value;
              });
            },
            onChangeEnd: (value) {
              http.setObjectValue(widget.id, value.toString());
            },
          )
        ],
      ),
    );
  }

  Widget _getOnOffCard() {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            switchValue = !switchValue;
            http.setObjectValue(widget.id, switchValue.toString());
          },
        );
      },
      child: Card(
        shape: switchValue
            ? new RoundedRectangleBorder(
                side: new BorderSide(color: Colors.tealAccent, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              )
            : new RoundedRectangleBorder(
                side: new BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(4.0)),
        color: Colors.grey[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.power_settings_new,
                color: switchValue ? Colors.white : Colors.grey,
                size: 44.0,
              ),
            ),
            Flexible(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
