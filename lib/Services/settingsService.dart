import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/ipAddressModel.dart';

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
}
