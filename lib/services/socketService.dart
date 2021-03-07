import 'dart:async';
import 'package:bolio/models/historyModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;
  List<ObjectStreamController> objectStreamController = [];

  SocketService();

  Future<IO.Socket> getSocket(String ipAddress, String socketPort) async {

    String url = 'http://' + ipAddress + ':' + socketPort + '/';
    var newSocket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'rememberUpgrade': true,
      'reconnection limit': 10000,
      'autoConnect': true,
      'reconnection': true,
    });
    newSocket.connect();
    return newSocket;

  }

  setSocket(IO.Socket socket) {
    this.socket = socket;
  }

  setState(id, state) {
    this.socket.emitWithAck('setState', [id, state], ack: (data) {});
  }

  getObjectChanges(String id) {
    StreamController controller = getStreamController(id);
    if (controller == null) {
      controller = new StreamController.broadcast();
      objectStreamController.add(ObjectStreamController(controller, id));
      this.socket.emit('subscribe', id);
      this.socket.on('stateChange', (data) {
        if (data != null && data[1] != null && data[1] != null) {
          if (data[1]['val'] != null) {
            if (data[0] == id) {
              controller.add(data[1]['val'].toString());
            }
          }
        }
      });
    }
  }

  getObjectValue(String id) {
    getObjectChanges(id);
    this.socket.emitWithAck(
      'getStates',
      [id],
      ack: (data) {
        if (data != null && data[1] != null && data[1][id] != null) {
          if (data[1][id]['val'] != null) {
            StreamController controller = getStreamController(id);
            if (controller != null) {
              controller.add(data[1][id]['val'].toString());
            }
          }
        }
      },
    );
  }

  StreamController getStreamController(String id) {
    for (var controller in objectStreamController) {
      if (controller.objectId == id) {
        return controller.streamController;
      }
    }
    return null;
  }
}

class ObjectStreamController {
  StreamController streamController;
  String objectId;

  ObjectStreamController(this.streamController, this.objectId);
}
