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

  getPort() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('port');
  }

  setPort(port) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('port', port);
  }

  Future<String> getIpAddress_Port() async {
    var ipAddress = await getIpAddress();
    var port = await getPort();
    if (ipAddress != null && port != null) {
      return ipAddress + ':' + port;
    } else {
      return null;
    }
  }
}
