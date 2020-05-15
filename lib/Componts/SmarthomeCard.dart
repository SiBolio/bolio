import 'package:flutter/material.dart';
import 'package:smarthome/Services/colorsService.dart';
import 'package:smarthome/Services/httpService.dart';
import 'package:smarthome/Services/securityService.dart';
import 'package:smarthome/Services/socketService.dart';
import 'lineGraph.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SmarthomeCard extends StatefulWidget {
  final String id;
  final String title;
  final String objectType;
  final String tileSize;
  final String timeSpan;
  final double sliderMin;
  final double sliderMax;
  final double setPointMin;
  final double setPointMax;
  final IO.Socket socket;
  final bool secured;
  final int icon;

  SmarthomeCard({
    this.id,
    this.title,
    this.objectType,
    this.tileSize,
    this.timeSpan,
    this.sliderMin,
    this.sliderMax,
    this.setPointMin,
    this.setPointMax,
    this.socket,
    this.secured,
    this.icon,
  });

  SocketService socketSrv;

  @override
  _SmarthomeCardState createState() => _SmarthomeCardState();
}

class _SmarthomeCardState extends State<SmarthomeCard> {
  HttpService http;
  SecurityService securitySrv;
  BolioColors bolioColors;

  @override
  void initState() {
    http = new HttpService();
    securitySrv = new SecurityService();
    bolioColors = new BolioColors();
    widget.socketSrv =
        new SocketService(socket: widget.socket, favoriteId: widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.objectType == 'Slider') {
      widget.socketSrv
          .getObjectValue(widget.id, widget.setPointMin, widget.setPointMax);

      return Center(
        child: StreamBuilder(
          stream: widget.socketSrv.streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return _getSliderCard(double.parse(snapshot.data));
            } else
              return CircularProgressIndicator();
          },
        ),
      );
    } else if (widget.objectType == 'Einzelwert') {
      widget.socketSrv
          .getObjectValue(widget.id, widget.setPointMin, widget.setPointMax);
      return StreamBuilder(
        stream: widget.socketSrv.streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Card(
              shape: widget.setPointMin != null || widget.setPointMax != null
                  ? RoundedRectangleBorder(
                      side: new BorderSide(
                          color: bolioColors.getSetPointColorLineGraph(snapshot.data,
                              widget.setPointMin, widget.setPointMax, context),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(4.0),
                    )
                  : null,
              color: Theme.of(context).brightness == Brightness.dark
                  ? BolioColors.surfaceCard
                  : null,
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
                          color: bolioColors.getCardFontColor(context),
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
      widget.socketSrv
          .getObjectValue(widget.id, widget.setPointMin, widget.setPointMax);
      return StreamBuilder(
        stream: widget.socketSrv.streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _getOnOffCard(snapshot.data);
          } else {
            return Center(child: Text('-'));
          }
        },
      );
    } else if (widget.objectType == 'Tür/Fensterkontakt') {
      widget.socketSrv
          .getObjectValue(widget.id, widget.setPointMin, widget.setPointMax);
      return StreamBuilder(
        stream: widget.socketSrv.streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _getContactCard(snapshot.data);
          } else {
            return Text('-');
          }
        },
      );
    } else if (widget.objectType == 'Graph') {
      widget.socketSrv
          .getObjectValue(widget.id, widget.setPointMin, widget.setPointMax);
      return Center(
        child: FutureBuilder(
          future: http.getHistory(widget.id, widget.timeSpan,
              widget.setPointMin, widget.setPointMax),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Card(
                color: Theme.of(context).brightness == Brightness.dark
                    ? BolioColors.surfaceCard
                    : null,
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
                                color: bolioColors.getCardFontColor(context),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
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
                            visible:
                                _isValueVisibleInGraphTile(widget.tileSize),
                            child: Flexible(
                              flex: 3,
                              child: StreamBuilder(
                                stream:
                                    widget.socketSrv.streamController.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> socketSnapshot) {
                                  if (socketSnapshot.hasData) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        socketSnapshot.data,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 38,
                                          color: bolioColors.getCardFontColor(context),
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
                    ),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget _getSliderCard(double sliderValue) {
    double _min = 0;
    double _max = 100;

    if (widget.sliderMin != null) {
      _min = widget.sliderMin;
    }
    if (widget.sliderMax != null) {
      _max = widget.sliderMax;
    }

    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? BolioColors.surfaceCard
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.0,
                color: bolioColors.getCardFontColor(context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Slider(
            activeColor: BolioColors.primary,
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

  Widget _getOnOffCard(String _switchValue) {
    String _valueToSet;
    if (_switchValue == 'true') {
      _valueToSet = 'false';
    } else {
      _valueToSet = 'true';
    }
    return GestureDetector(
      onTap: () async {
        if (widget.secured) {
          securitySrv.checkBiometrics().then((canCheckBiometrics) {
            if (canCheckBiometrics) {
              securitySrv.checkAuthentication().then((authenticated) {
                if (authenticated) {
                  setState(
                    () {
                      http.setObjectValue(widget.id, _valueToSet);
                    },
                  );
                }
              });
            }
          });
        } else {
          setState(
            () {
              http.setObjectValue(widget.id, _valueToSet);
            },
          );
        }
      },
      child: Card(
        shape: _switchValue == 'true'
            ? new RoundedRectangleBorder(
                side: new BorderSide(color: BolioColors.primary, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              )
            : new RoundedRectangleBorder(
                side: new BorderSide(color: Colors.grey[800], width: 1.0),
                borderRadius: BorderRadius.circular(4.0)),
        color: Theme.of(context).brightness == Brightness.dark
            ? BolioColors.surfaceCard
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                Expanded(
                  child: Icon(
                    Icons.power_settings_new,
                    color: bolioColors.getIconColor(_switchValue, context),
                    size: 44.0,
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: widget.secured
                      ? Icon(
                          Icons.lock,
                          color: BolioColors.dangerLine,
                          size: 20.0,
                        )
                      : Container(),
                  flex: 1,
                ),
              ],
            ),
            Flexible(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  color: bolioColors.getCardFontColor(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getContactCard(String _switchValue) {
    IconData customIconData;
    if (widget.icon != null) {
      customIconData = IconData(widget.icon,
          fontFamily: 'MaterialIcons', matchTextDirection: false);
    }

    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? BolioColors.surfaceCard
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.icon == null
                ? Icon(
                    _switchValue == 'true' ? Icons.lock_open : Icons.lock,
                    color: bolioColors.getIconColor(_switchValue, context),
                    size: 44.0,
                  )
                : Icon(
                    customIconData,
                    color: bolioColors.getIconColor(_switchValue, context),
                    size: 44.0,
                  ),
          ),
          Flexible(
            child: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
                color: bolioColors.getCardFontColor(context),
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
      _isVisible = false;
    } else if (tileSize == 'M') {
      if (MediaQuery.of(context).size.width < 700) {
        _isVisible = false;
      }
    }
    return _isVisible;
  }

  _getSetPointColorBackground(String value, double min, double max) {
    if (min != null) {
      if (double.parse(value) < min) {
        return BolioColors.dangerCard;
      }
    }
    if (max != null) {
      if (double.parse(value) > max) {
        return BolioColors.dangerCard;
      }
    }
    return Theme.of(context).brightness == Brightness.dark
        ? BolioColors.surfaceCard
        : null;
  }

  _getSetPointColorFont(String value, double min, double max) {
    if (min != null) {
      if (double.parse(value) < min) {
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
      }
    }
    if (max != null) {
      if (double.parse(value) > max) {
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
      }
    }
    return Colors.grey[400];
  }

}
