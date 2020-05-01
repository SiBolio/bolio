import 'package:flutter/material.dart';
import 'package:smarthome/Services/httpService.dart';
import 'lineGraph.dart';

class SmarthomeCard extends StatefulWidget {
  final String id;
  final String title;
  final String objectType;
  final String tileSize;
  final String timeSpan;
  final double sliderMin;
  final double sliderMax;
  final int setPointMin;
  final int setPointMax;

  SmarthomeCard(
      {this.id,
      this.title,
      this.objectType,
      this.tileSize,
      this.timeSpan,
      this.sliderMin,
      this.sliderMax,
      this.setPointMin,
      this.setPointMax});

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
        return Center(
          child: FutureBuilder(
            future: http.getObjectValue(widget.id),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                sliderValue = double.parse(snapshot.data);
                return _getSliderCard();
              } else
                return CircularProgressIndicator();
            },
          ),
        );
      } else {
        return _getSliderCard();
      }
    } else if (widget.objectType == 'Einzelwert') {
      return FutureBuilder(
        future: http.getObjectValue(widget.id),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Card(
              color: _getSetPointColor(
                  snapshot.data, widget.setPointMin, widget.setPointMax),
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
                    child: Center(
                      child: Text(
                        snapshot.data,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
    } else if (widget.objectType == 'Tür/Fensterkontakt') {
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
              return _getContactCard();
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
                  return Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: LineGraph(snapshot.data),
                          ),
                        ),
                        Visibility(
                          visible: _isValueVisibleInGraphTile(widget.tileSize),
                          child: Flexible(
                            flex: 3,
                            child: FutureBuilder(
                              future: http.getObjectValue(widget.id),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      snapshot.data,
                                      overflow: TextOverflow.ellipsis,
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
                        ),
                      ],
                    ),
                  );
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
    double _min = 0;
    double _max = 100;

    if (widget.sliderMin != null) {
      _min = widget.sliderMin;
    }
    if (widget.sliderMax != null) {
      _max = widget.sliderMax;
    }

    return Card(
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            min: _min,
            max: _max,
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
          mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _getContactCard() {
    return Card(
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              switchValue ? Icons.lock_open : Icons.lock,
              color: Colors.grey,
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
    );
  }

  _isValueVisibleInGraphTile(String tileSize) {
    bool _isVisible = true;
    if (tileSize == 'S') {
      if (MediaQuery.of(context).size.width < 700) {
        _isVisible = false;
      }
    } else if (tileSize == 'M') {
      if (MediaQuery.of(context).size.width < 700) {
        _isVisible = false;
      }
    }
    return _isVisible;
  }

  _getSetPointColor(String value, int min, int max) {
    if (min != null) {
      if (double.parse(value) < min) {
        return Colors.red[900];
      }
    }
    if (max != null) {
      if (double.parse(value) > max) {
        return Colors.redAccent[700];
      }
    }
    return Colors.grey[900];
  }
}
