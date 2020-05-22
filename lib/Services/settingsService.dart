import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Models/ipAddressModel.dart';
import 'dart:convert';

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

  Future<bool> importSettings() async {
    File file = await FilePicker.getFile();
    String contents = await file.readAsString();
    String pages = contents.split('settingsPages:')[1];
    String favoritesTemp = contents.split('settingsPages:')[0];
    String favorites = favoritesTemp.split('settingsFavorites:')[1];
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', favorites);
    prefs.setString('pages', pages);
    return true;
  }

  void exportSettings() async {
    final file = await _localFile;

    //Datei Schreiben
    var prefs = await SharedPreferences.getInstance();
    String favorites = 'settingsFavorites:' + prefs.getString('favorites');
    String pages = 'settingsPages:' + prefs.getString('pages');

    file.writeAsString(favorites + pages);

    var bytes = await file.readAsBytes();
    await Share.file('bolio_favorites', 'bolio_favorites', bytes, 'text/plain');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/bolio_favorites.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString('$counter');
  }
}
