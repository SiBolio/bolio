import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smarthome/Models/ipAddressModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket _socket;
  StreamController<String> streamController;
  String _favoriteId;

  SocketService({IO.Socket socket, String favoriteId}) {
    this._socket = socket;
    this._favoriteId = favoriteId;
    streamController = new StreamController<String>();
  }

  Future<IO.Socket> getSocket(IpAddressModel ipPort) async {
    String url = 'http://' + ipPort.ipAddress + ':' + ipPort.portSocketIO + '/';
    var newSocket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'rememberUpgrade': true,
      'reconnection limit': 10000,
      'autoConnect': false,
      'reconnection': true,
    });
    newSocket.connect();
    newSocket.emit('subscribe', '*');
    return newSocket;
  }

  getObjectValue(String id, double min, double max) {
    _socket.on('stateChange', (data) {
      if (data != null && data[1] != null && data[1] != null) {
        if (data[1]['val'] != null) {
          if (data[0] == this._favoriteId) {
            streamController.add(data[1]['val'].toString());
          }
        }
      }
    });

    _socket.emitWithAck(
      'getStates',
      [id],
      ack: (data) {
        if (data != null && data[1] != null && data[1][id] != null) {
          if (data[1][id]['val'] != null) {
            streamController.add(data[1][id]['val'].toString());

            if (min != null && max != null) {
              if (data[1][id]['val'] < min || data[1][id]['val'] > max) {
                //  _showNotification(data[1][id]['val'].toString());
              }
            }
          }
        }
      },
    );
  }

  _showNotification(String value) {
    FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();
    var androidInit = AndroidInitializationSettings('ic_launcher');
    var iOSInit = IOSInitializationSettings();
    var init = InitializationSettings(androidInit, iOSInit);
    notifications.initialize(init).then((done) {
      notifications.show(
          0,
          "Wert nicht im Sollbereich",
          value,
          NotificationDetails(
              AndroidNotificationDetails(
                  "announcement_app_0", "Announcement App", ""),
              IOSNotificationDetails()));
    });
  }
}
