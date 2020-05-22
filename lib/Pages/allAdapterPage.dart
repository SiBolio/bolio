import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:package_info/package_info.dart';
import 'package:smarthome/Models/adapterModel.dart';
import 'package:smarthome/Models/favoriteModel.dart';
import 'package:smarthome/Models/ipAddressModel.dart';
import 'package:smarthome/Models/pageModel.dart';
import 'package:smarthome/Pages/singleAdapterPage.dart';
import 'package:smarthome/Pages/start.dart';
import 'package:smarthome/Services/colorsService.dart';
import 'package:smarthome/Services/favoriteService.dart';
import 'package:smarthome/Services/httpService.dart';
import 'package:smarthome/Services/iconButtonService.dart';
import 'package:smarthome/Services/settingsService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

HttpService httpService = new HttpService();
FavoriteService favoriteService = new FavoriteService();
SettingsService settingsService = new SettingsService();

class AllAdapterPage extends StatefulWidget {
  @override
  _AllAdapterPageState createState() => _AllAdapterPageState();

  AllAdapterPage({this.mainSocket});
  IO.Socket mainSocket;
}

class _AllAdapterPageState extends State<AllAdapterPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Favoriten'),
    Tab(text: 'Seiten'),
    Tab(text: 'Adapter'),
    Tab(text: 'Sonstiges')
  ];

  TabController _tabController;
  Icon _selectedPageIcon;
  Icon _selectedFavoriteIcon;
  List<AdapterModel> _adapters;
  IconButtonService _iconButtonSrv = new IconButtonService();
  bool _selectingFavorites = false;
  List<String> _selectedFavoritesIDs = new List<String>();
  List<FavoriteModel> _displayedFavorites = new List<FavoriteModel>();
  List<FavoriteModel> _allFavorites = new List<FavoriteModel>();
  String _filterFavorite = 'Alle';
  bool darkThemeSwitch = true;
  BolioColors bolioColors = new BolioColors();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<FavoriteModel> _favorites;
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartPage(mainSocket: widget.mainSocket),
          ),
        ).then((value) {
          setState(() {});
        });
        return null;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? BolioColors.surface
            : null,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StartPage(mainSocket: widget.mainSocket)),
                ).then((value) {
                  setState(() {});
                });
              }),
          title: const Text('Einstellungen'),
          actions: <Widget>[
            _tabController.index == 0
                ? FutureBuilder(
                    future: favoriteService.getPages(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PageModel>> snapshotFilterPages) {
                      if (snapshotFilterPages.hasData) {
                        return PopupMenuButton(
                          itemBuilder: (context) {
                            var list = List<PopupMenuEntry<Object>>();
                            list.add(PopupMenuItem(
                              child: Text('Alle'),
                              value: 'Alle',
                            ));
                            for (var page in snapshotFilterPages.data) {
                              list.add(
                                PopupMenuItem(
                                  child: Text(page.title),
                                  value: page.id,
                                ),
                              );
                            }
                            return list;
                          },
                          onSelected: (value) {
                            setState(() {
                              _filterFavorite = value;
                            });
                          },
                          icon: Icon(
                            Icons.filter_list,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : Container(),
            _tabController.index == 0
                ? IconButton(
                    icon: _selectingFavorites
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        _selectingFavorites = !_selectingFavorites;
                      });
                      if (_selectingFavorites) {
                        _selectedFavoritesIDs.clear();
                      }
                    },
                  )
                : Container(),
            _tabController.index == 0
                ? PopupMenuButton(
                    itemBuilder: (context) {
                      var list = List<PopupMenuEntry<Object>>();
                      list.add(
                        PopupMenuItem(
                          child: Text("Favoriten zuordnen"),
                          value: 1,
                          enabled: _selectingFavorites &&
                                  _selectedFavoritesIDs.length > 0
                              ? true
                              : false,
                        ),
                      );
                      return list;
                    },
                    onSelected: (value) {
                      if (value == 1) {
                        _showAddToPagePopup();
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                    ),
                  )
                : Container()
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
        floatingActionButton: _getFloatingButton(),
        body: TabBarView(
          controller: _tabController,
          children: myTabs.map(
            (Tab tab) {
              if (tab.text == 'Sonstiges') {
                return _getTabOthers();
              } else if (tab.text == 'Adapter') {
                return _getTabAdapters();
              } else if (tab.text == 'Seiten') {
                return _getTabPages();
              } else if (tab.text == 'Favoriten') {
                if (_favorites == null) {
                  return Container(
                    child: FutureBuilder(
                      future: favoriteService.getFavorites(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _favorites = snapshot.data ?? [];
                          if (_favorites.length == 0) {
                            return Center(
                              child: Text(
                                'Fügen sie im Tab Adapter neue Favoriten hinzu',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          } else {
                            return _getFavoriteList(_favorites, context);
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  );
                } else {
                  return _getFavoriteList(_favorites, context);
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ).toList(),
        ),
      ),
    );
  }

  Center _getTabAdapters() {
    if (_adapters == null) {
      return Center(
        child: FutureBuilder(
          future: httpService.getAllAdapters(),
          builder: (context, snapshot) {
            if (snapshot.data == null &&
                snapshot.connectionState == ConnectionState.done) {
              return Text('Keine Adapter gefunden.');
            }
            if (snapshot.hasError) {
              return new CircularProgressIndicator();
            } else {
              List<AdapterModel> _adapters = snapshot.data ?? [];
              return buildAdapterList(_adapters);
            }
          },
        ),
      );
    } else {
      return Center(
        child: buildAdapterList(_adapters),
      );
    }
  }

  ListView buildAdapterList(List<AdapterModel> adapters) {
    return ListView.builder(
      itemCount: adapters.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: adapters[index].iconUrl != null
              ? CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  backgroundImage: NetworkImage(adapters[index].iconUrl),
                )
              : null,
          title: Text(adapters[index].title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleAdapterPage(
                  title: adapters[index].title,
                  name: adapters[index].name,
                  adapterId: adapters[index].id,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getFavoriteList(List<FavoriteModel> objects, context) {
    return ReorderableListView(
      onReorder: (int oldIndexCurrentList, int newIndexCurrentList) {
        int oldIndexCompleteList = 0;
        int newIndexCompleteList = 0;

        for (var i = 0; i < _allFavorites.length; i++) {
          if (_allFavorites[i] == _displayedFavorites[oldIndexCurrentList]) {
            oldIndexCompleteList = i;
            break;
          }
        }

        for (var i = 0; i < _allFavorites.length; i++) {
          if (_allFavorites[i] == _displayedFavorites[newIndexCurrentList]) {
            newIndexCompleteList = i;
            break;
          }
        }

        setState(
          () {
            favoriteService.reorderFavorites(
                oldIndexCompleteList, newIndexCompleteList, context);
          },
        );
      },
      children: _getListTiles(objects, context),
    );
  }

  List<ListTile> _getListTiles(List<FavoriteModel> favorites, context) {
    List<ListTile> listTiles = new List<ListTile>();

    _displayedFavorites.clear();
    _allFavorites.clear();
    _allFavorites = favorites;

    for (var favorite in favorites) {
      if (_filterFavorite == 'Alle' || _filterFavorite == favorite.pageId) {
        var tile = new ListTile(
          key: ValueKey(favorite),
          title: Text(favorite.title),
          subtitle: FutureBuilder(
            future: favoriteService.getPageName(favorite.pageId, context),
            builder:
                (BuildContext context, AsyncSnapshot<String> snapshotPages) {
              if (snapshotPages.hasData) {
                return Text(snapshotPages.data);
              } else {
                return Text('');
              }
            },
          ),
          leading: _selectingFavorites
              ? _iconButtonSrv
                  .getSelectIcon(_selectedFavoritesIDs.contains(favorite.id))
              : _iconButtonSrv.getItemIcon(favorite.objectType),
          onTap: () {
            if (_selectingFavorites) {
              if (!_selectedFavoritesIDs.contains(favorite.id)) {
                setState(() {
                  _selectedFavoritesIDs.add(favorite.id);
                });
              } else {
                setState(() {
                  _selectedFavoritesIDs.remove(favorite.id);
                });
              }
            } else {
              _showEditFavoriteDialog(context, favorite);
            }
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              FavoriteService favoriteService = new FavoriteService();
              setState(
                () {
                  favoriteService.removeObjectFromFavorites(
                      favorite.id, context);
                },
              );
              final snackBar = SnackBar(
                content: Text('Favorit entfernt'),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
        );
        listTiles.add(tile);
        _displayedFavorites.add(favorite);
      }
    }
    return listTiles;
  }

  Future<void> _showEditFavoriteDialog(context, FavoriteModel object) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = new TextEditingController();
        nameController.text = object.title;

        TextEditingController setpointMinController =
            new TextEditingController();

        if (object.setPointMin == null) {
          setpointMinController.text = '';
        } else {
          setpointMinController.text = object.setPointMin.toString();
        }

        TextEditingController setpointMaxController =
            new TextEditingController();

        if (object.setPointMax == null) {
          setpointMaxController.text = '';
        } else {
          setpointMaxController.text = object.setPointMax.toString();
        }

        GlobalKey<FormState> _setpointMinKey = GlobalKey();

        List _isSelected = <bool>[
          object.tileSize == 'S',
          object.tileSize == 'M',
          object.tileSize == 'L'
        ];

        String _isSelectedDropdownObjectType = object.objectType;
        String _isSelectedDropdownTimespan = object.timeSpan;
        String _isSelectedDropdownPage = object.pageId;
        bool _isSecured = object.secured;

        if (object.icon != null) {
          IconData _iconData = IconData(object.icon,
              fontFamily: 'MaterialIcons', matchTextDirection: false);
          _selectedFavoriteIcon = Icon(_iconData);
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: bolioColors.getPopupColor(context),
              title: Text('Objekt bearbeiten'),
              content: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Objektname'),
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: object.id,
                      decoration: InputDecoration(labelText: 'Objekt ID'),
                    ),
                    FutureBuilder(
                      future: favoriteService.getPages(context),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PageModel>> snapshotPages) {
                        if (snapshotPages.hasData &&
                            snapshotPages.data.length > 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Seite: '),
                                DropdownButton<String>(
                                  value: _isSelectedDropdownPage,
                                  items:
                                      _getDropDownPageItems(snapshotPages.data),
                                  onChanged: (String newValue) {
                                    setState(
                                      () {
                                        _isSelectedDropdownPage = newValue;
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Größe: '),
                          ToggleButtons(
                            fillColor: BolioColors.primary,
                            selectedColor: Colors.black,
                            children: <Widget>[
                              Text('S'),
                              Text('M'),
                              Text('L'),
                            ],
                            onPressed: (int index) {
                              setState(
                                () {
                                  for (int buttonIndex = 0;
                                      buttonIndex < _isSelected.length;
                                      buttonIndex++) {
                                    if (buttonIndex == index) {
                                      _isSelected[buttonIndex] = true;
                                    } else {
                                      _isSelected[buttonIndex] = false;
                                    }
                                  }
                                },
                              );
                            },
                            isSelected: _isSelected,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Objekttyp: '),
                          DropdownButton<String>(
                            value: _isSelectedDropdownObjectType,
                            items: <String>[
                              'Einzelwert',
                              'On/Off Button',
                              'Graph',
                              'Slider',
                              'Tür/Fensterkontakt'
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(
                                () {
                                  _isSelectedDropdownObjectType = newValue;
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _isSelectedDropdownObjectType == 'Graph',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Zeitraum: '),
                            DropdownButton<String>(
                              value: _isSelectedDropdownTimespan,
                              items: <String>[
                                '24 Stunden',
                                '7 Tage',
                                '30 Tag',
                              ].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(
                                  () {
                                    _isSelectedDropdownTimespan = newValue;
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isSelectedDropdownObjectType == 'Einzelwert' ||
                          _isSelectedDropdownObjectType == 'Graph',
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 30.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Sollbereich:'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isSelectedDropdownObjectType == 'Einzelwert' ||
                          _isSelectedDropdownObjectType == 'Graph',
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Form(
                                key: _setpointMinKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if ((value != '') &&
                                        (setpointMaxController.text != '')) {
                                      if (int.parse(value) >=
                                          int.parse(
                                              setpointMaxController.text)) {
                                        return 'Falscher Sollbereich';
                                      }
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: setpointMinController,
                                  decoration:
                                      InputDecoration(labelText: 'Minimum'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: TextFormField(
                                validator: (value) {
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                controller: setpointMaxController,
                                decoration:
                                    InputDecoration(labelText: 'Maximum'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _isSelectedDropdownObjectType == 'On/Off Button',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Geschützte Änderung: '),
                            Checkbox(
                              checkColor: Colors.black,
                              value: _isSecured,
                              onChanged: (bool newValue) {
                                setState(() {
                                  _isSecured = newValue;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          _isSelectedDropdownObjectType == 'Tür/Fensterkontakt',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              color: bolioColors.getButtonColor(context),
                              onPressed: () async {
                                IconData icon =
                                    await FlutterIconPicker.showIconPicker(
                                        context,
                                        iconPackMode: IconPack.material);

                                if (icon != null) {
                                  setState(() {
                                    _selectedFavoriteIcon = Icon(icon);
                                  });
                                }
                              },
                              child: Text('Anderes Icon verwenden'),
                            ),
                            _selectedFavoriteIcon != null
                                ? Icon(_selectedFavoriteIcon.icon, size: 35)
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Abbrechen'),
                  color: bolioColors.getButtonColor(context),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  child: Text('Speichern'),
                  color: BolioColors.primary,
                  onPressed: () async {
                    if (_isSelectedDropdownObjectType == 'Einzelwert') {
                      if (!_setpointMinKey.currentState.validate()) {
                        return null;
                      }
                    }
                    FavoriteService favoriteService = new FavoriteService();

                    setState(
                      () {
                        var tileSize = 'S';
                        if (_isSelected[1]) {
                          tileSize = 'M';
                        } else if (_isSelected[2]) {
                          tileSize = 'L';
                        }

                        String _icon;
                        _selectedFavoriteIcon == null
                            ? _icon = ''
                            : _icon =
                                _selectedFavoriteIcon.icon.codePoint.toString();

                        favoriteService.updateFavorite(
                          object.id,
                          nameController.text,
                          tileSize,
                          _isSelectedDropdownObjectType,
                          _isSelectedDropdownTimespan,
                          setpointMinController.text,
                          setpointMaxController.text,
                          _isSelectedDropdownPage,
                          _isSecured,
                          _icon,
                          context,
                        );
                      },
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllAdapterPage()),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _getDropDownPageItems(List<PageModel> pages) {
    List<DropdownMenuItem<String>> _dropDownList = new List();
    for (PageModel page in pages) {
      var item = DropdownMenuItem<String>(
        value: page.id,
        child: new Text(page.title),
      );
      _dropDownList.add(item);
    }
    return _dropDownList;
  }

  Future<String> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  FutureBuilder<IpAddressModel> _getTabOthers() {
    return FutureBuilder<IpAddressModel>(
      future: settingsService.getIpAddressPort(),
      builder: (BuildContext context, AsyncSnapshot<IpAddressModel> snapshot) {
        if (snapshot.hasData) {
          TextEditingController ipController = new TextEditingController();
          ipController.text = snapshot.data.ipAddress;
          TextEditingController portSimpleAPIController =
              new TextEditingController();
          portSimpleAPIController.text = snapshot.data.portSimpleAPI;

          TextEditingController portSocketIoController =
              new TextEditingController();
          portSocketIoController.text = snapshot.data.portSocketIO;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/logo.png'),
                  height: 50,
                ),
                FutureBuilder<String>(
                  future: _getVersion(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Version ' + snapshot.data,
                          style: new TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Version konnte nicht geladen werden');
                    } else {
                      return Container(color: Colors.white);
                    }
                  },
                ),
                TextFormField(
                  controller: ipController,
                  decoration: InputDecoration(labelText: 'IP Adresse'),
                ),
                TextFormField(
                  controller: portSimpleAPIController,
                  decoration: InputDecoration(labelText: 'simpleAPI Port'),
                ),
                TextFormField(
                  controller: portSocketIoController,
                  decoration: InputDecoration(labelText: 'socket.io Port'),
                ),
                ListTile(
                  leading: Icon(Icons.brightness_medium),
                  title: Text('Dunkler Modus'),
                  trailing: Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (value) {
                      setState(
                        () {
                          DynamicTheme.of(context).setBrightness(
                              Theme.of(context).brightness == Brightness.dark
                                  ? Brightness.light
                                  : Brightness.dark);
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Einstellungen exportieren'),
                  onTap: () {
                    settingsService.exportSettings();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.file_upload),
                  title: Text('Einstellungen importieren'),
                  onTap: () {
                    settingsService.importSettings().then((hasImported) {
                      final snackBar = SnackBar(
                        content: Text('Einstellungen wurden importiert'),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    color: BolioColors.primary,
                    child: const Text('Speichern',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    onPressed: () {
                      setState(
                        () {
                          settingsService.setIpAddress(ipController.text);
                          settingsService
                              .setPortSimpleAPI(portSimpleAPIController.text);
                          settingsService
                              .setPortSocketIO(portSocketIoController.text);
                        },
                      );
                      var snackBar = SnackBar(
                        content: Text('Einstellungen gespeichert'),
                      );
                      FocusScope.of(context).requestFocus(FocusNode());
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Linkify(
                          onOpen: _onOpen,
                          text:
                              "Icons erstellt von Freepik ( https://www.flaticon.com/de/autoren/freepik ) from https://www.flaticon.com",
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
    );
  }

  Widget _getFloatingButton() {
    return _tabController.index == 1
        ? FloatingActionButton(
            onPressed: () {
              _addPage();
            },
            child: Icon(Icons.library_add),
          )
        : null;
  }

  FutureBuilder _getTabPages() {
    return FutureBuilder<List<PageModel>>(
      future: favoriteService.getPages(context),
      builder: (context, AsyncSnapshot<List<PageModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var _iconData = new IconData(snapshot.data[index].icon,
                    fontFamily: 'MaterialIcons', matchTextDirection: false);
                return ListTile(
                  leading: _iconButtonSrv.getPageIcon(Icon(
                    _iconData,
                    color: Colors.grey[900],
                  )),
                  title: Text(snapshot.data[index].title),
                  onTap: () {
                    _editPage(snapshot.data[index]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: 'Seite löschen',
                    onPressed: () {
                      setState(() {
                        favoriteService.removePageFromPages(
                            snapshot.data[index].id, context);
                      });
                      final snackBar = SnackBar(
                        content: Text('Seite entfernt'),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Sie haben keine Seite angelegt.'));
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  _editPage(PageModel page) async {
    TextEditingController pageTitleController = new TextEditingController();
    pageTitleController.text = page.title;
    var _iconData = IconData(page.icon,
        fontFamily: 'MaterialIcons', matchTextDirection: false);
    _selectedPageIcon = Icon(_iconData);
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext _context) {
        return StatefulBuilder(builder: (_context, setState) {
          return AlertDialog(
            backgroundColor: bolioColors.getPopupColor(context),
            title: Text('Seite bearbeiten'),
            content: SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: pageTitleController,
                    decoration: InputDecoration(labelText: 'Seitenname'),
                  ),
                  _selectedPageIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Icon(_selectedPageIcon.icon, size: 35),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: BolioColors.surfaceCard,
                      onPressed: () async {
                        IconData icon = await FlutterIconPicker.showIconPicker(
                            _context,
                            iconPackMode: IconPack.material);
                        setState(() {
                          _selectedPageIcon = Icon(icon);
                        });
                      },
                      child: Text('Icon wählen'),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Abbrechen'),
                onPressed: () {
                  _selectedPageIcon = null;
                  Navigator.of(_context).pop();
                },
              ),
              RaisedButton(
                child: Text('Speichern'),
                color: BolioColors.primary,
                onPressed: () {
                  int _codePoint;
                  _selectedPageIcon == null
                      ? _codePoint = 0
                      : _codePoint = _selectedPageIcon.icon.codePoint;

                  page.setTite(pageTitleController.text);
                  page.setIcon(_codePoint);
                  _selectedPageIcon = null;
                  Navigator.of(_context).pop();
                },
              )
            ],
          );
        });
      },
    ).then(
      (value) => {
        if (page != null)
          {
            setState(
              () {
                favoriteService.updatePage(page, context);
              },
            )
          }
      },
    );
  }

  _addPage() async {
    TextEditingController pageTitleController = new TextEditingController();
    PageModel _pageToAdd;
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext _context) {
        return StatefulBuilder(builder: (_context, setState) {
          return AlertDialog(
            backgroundColor: bolioColors.getPopupColor(context),
            title: Text('Seite anlegen'),
            content: SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: pageTitleController,
                    decoration: InputDecoration(labelText: 'Seitenname'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          color: bolioColors.getButtonColor(context),
                          onPressed: () async {
                            IconData icon =
                                await FlutterIconPicker.showIconPicker(_context,
                                    iconPackMode: IconPack.material);

                            if (icon == icon) {}
                            setState(() {
                              _selectedPageIcon = Icon(icon);
                            });
                          },
                          child: Text('Icon wählen'),
                        ),
                        _selectedPageIcon != null
                            ? Icon(_selectedPageIcon.icon, size: 35)
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Abbrechen'),
                onPressed: () {
                  _selectedPageIcon = null;
                  Navigator.of(_context).pop();
                },
              ),
              RaisedButton(
                child: Text('Speichern'),
                color: BolioColors.primary,
                onPressed: () {
                  setState(() {
                    int _codePoint;
                    _selectedPageIcon == null
                        ? _codePoint = 0
                        : _codePoint = _selectedPageIcon.icon.codePoint;

                    PageModel page = new PageModel(
                        id: new DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        title: pageTitleController.text,
                        icon: _codePoint);
                    _pageToAdd = page;
                  });
                  _selectedPageIcon = null;
                  Navigator.of(_context).pop();
                },
              )
            ],
          );
        });
      },
    ).then(
      (value) => {
        if (_pageToAdd != null)
          {
            setState(
              () {
                favoriteService.addPageToPages(_pageToAdd, context);
              },
            )
          }
      },
    );
  }

  _showAddToPagePopup() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seite auswählen'),
          content: Container(
            height: 200,
            width: 300,
            child: FutureBuilder(
              future: favoriteService.getPages(context),
              builder: (context, AsyncSnapshot<List<PageModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        var iconData = new IconData(snapshot.data[index].icon,
                            fontFamily: 'MaterialIcons',
                            matchTextDirection: false);

                        return ListTile(
                          leading: Icon(iconData),
                          title: Text(snapshot.data[index].title),
                          onTap: () async {
                            for (var favorite in _selectedFavoritesIDs) {
                              await favoriteService.updateFavoritePageId(
                                  favorite, snapshot.data[index].id, context);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllAdapterPage(
                                    mainSocket: widget.mainSocket),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('Keine Seiten angelegt'));
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
