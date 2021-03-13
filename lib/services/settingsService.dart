import 'package:bolio/models/ipAddressModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<String> getIpAddress() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('ipAddress');
  }

  setIpAddress(ipAddress) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('ipAddress', ipAddress);
  }

  getSimpleAPIPort() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('port');
  }

  getSocketIOPort() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('port_socketio');
  }

  setPortSimpleAPI(port) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('port', port);
  }

  setPortSocketIO(port) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('port_socketio', port);
  }

  Future<IpAddressModel> getIpAddressPort() async {
    var ipAddress = await getIpAddress();
    var portSimpleAPI = await getSimpleAPIPort();
    var portSocketIO = await getSocketIOPort();

    if (ipAddress != null && portSimpleAPI != null && portSocketIO != null) {
      return new IpAddressModel(
          ipAddress: ipAddress,
          portSimpleAPI: portSimpleAPI,
          portSocketIO: portSocketIO);
    } else {
      return null;
    }
  }

  getCrossAxisCount(context) {
    int axisCount;
    double width = MediaQuery.of(context).size.width;
    if (width > 1300) {
      axisCount = 10;
    } else if (width > 1000) {
      axisCount = 8;
    } else if (width > 600) {
      axisCount = 6;
    } else {
      axisCount = 3;
    }
    return axisCount;
  }
}
