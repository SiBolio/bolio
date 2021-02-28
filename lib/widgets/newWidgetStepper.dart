/* import 'package:bolio/models/adapterModel.dart';
import 'package:bolio/services/colorService.dart';
import 'package:bolio/services/httpService.dart';
import 'package:bolio/services/saveService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:bolio/models/objectModel.dart';

class NewWidgetStepper extends StatefulWidget {
  HttpService httpService;
  SaveService saveService;

  @override
  NewWidgetStepperState createState() => NewWidgetStepperState();

  NewWidgetStepper() {
    this.httpService = new HttpService();
    this.saveService = new SaveService();
  }
}

class NewWidgetStepperState extends State<NewWidgetStepper> {
  int currentStep = 0;
  bool complete = false;
  List<Step> steps = [];
  String selectedAdapterName = '';
  String selectedObjectId = '';
  String selectedWidgetType = '';
  String selectedWidgetSize = '';
  String widgetName = '';

  static const conSingleValue = 'Einzelwert';
  static const conGraph = 'Graph';
  static const conOnOffButton = 'On/Off Button';
  static const conSlider = 'Slider';

  static const widgetSizeLarge = 'L';
  static const widgetSizeStandard = 'M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSerivce.surface,
      appBar: AppBar(
        title: Text('Neues Widget'),
      ),
      body: FutureBuilder<List<Step>>(
        future: _getSteps(),
        builder: (BuildContext context, AsyncSnapshot<List<Step>> _steps) {
          if (_steps.hasData &&
              _steps.connectionState == ConnectionState.done) {
            this.steps = _steps.data;
            return Stepper(
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Center();
              },
              steps: _steps.data,
              currentStep: currentStep,
              onStepContinue: next,
              onStepTapped: (step) => goTo(step),
              onStepCancel: cancel,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Visibility(
        visible: selectedWidgetSize != '',
        child: FloatingActionButton.extended(
          onPressed: () {
            widget.saveService.saveWidget(widgetName, selectedObjectId,
                selectedWidgetType, selectedWidgetSize);
          },
          label: Text('Widget speichern'),
          icon: Icon(Icons.save),
          backgroundColor: ColorSerivce.constMainColor,
        ),
      ),
    );
  }

  next() {
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  setObjectId(String objectId) {
    setState(() {
      selectedObjectId = objectId;
    });
    goTo(3);
  }

  Future<List<Step>> _getSteps() async {
    return [
      Step(
        title: Text('Widgettyp'),
        subtitle: selectedWidgetType == ''
            ? Text('Wählen sie den Typ des Widgets')
            : Text(selectedWidgetType),
        isActive: true,
        state: _getStepState('Widgettyp'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: new StaggeredGridView.count(
            crossAxisCount: 3,
            staggeredTiles: [
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 1)
            ],
            children: _getWidgetTypeCards(),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            padding: const EdgeInsets.all(4.0),
          ),
        ),
      ),
      Step(
        title: Text('Weitere Einstellungen'),
        isActive: selectedObjectId == '' ? false : true,
        state: _getStepState('Weitere Einstellungen'),
        content: Column(
          children: [
            TextFormField(
              initialValue: widgetName,
              decoration: InputDecoration(labelText: 'Widgetname'),
              onChanged: (value) {
                widgetName = value;
              },
            ),
          ],
        ),
      ),
      Step(
        title: Text('Widgetgröße'),
        subtitle: selectedWidgetSize == ''
            ? Text('Wählen sie die Größe des Widgets')
            : Text(selectedWidgetSize),
        isActive: selectedWidgetSize == '' ? false : true,
        state: _getStepState('Widgetgröße'),
        content: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: new StaggeredGridView.count(
                crossAxisCount: 3,
                staggeredTiles: [
                  StaggeredTile.count(3, 1.5),
                  StaggeredTile.count(1, 1),
                ],
                children: _getWidgetSizeCards(),
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                padding: const EdgeInsets.all(4.0),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _getWidgetTypeCards() {
    return [
      
    ];
  }

  List<Widget> _getWidgetSizeCards() {
    return [
      InkWell(
        borderRadius: BorderRadius.circular(4.0),
        splashColor: ColorSerivce.constMainColor,
        onTap: () {
          selectedWidgetSize = widgetSizeLarge;
          goTo(4);
        },
        child: Card(
          shape: selectedWidgetSize == widgetSizeLarge
              ? new RoundedRectangleBorder(
                  side: new BorderSide(
                      color: ColorSerivce.constMainColor, width: 2.0),
                  borderRadius: BorderRadius.circular(4.0),
                )
              : null,
          color: ColorSerivce.surfaceCard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [r
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Breites Widget',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.circular(4.0),
        splashColor: ColorSerivce.constMainColor,
        onTap: () {
          selectedWidgetSize = widgetSizeStandard;
          goTo(4); 
        },
        child: Card(
          shape: selectedWidgetSize == widgetSizeStandard
              ? new RoundedRectangleBorder(
                  side: new BorderSide(
                      color: ColorSerivce.constMainColor, width: 2.0),
                  borderRadius: BorderRadius.circular(4.0))
              : null,
          color: ColorSerivce.surfaceCard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Standard Widget',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Future<ListView> _getObjectList(
      String adapterId, List<ObjectsModel> adapterObjects) async {
    List<NodeModel> nodes = await widget.httpService.getAdapterNodes(adapterId);

    Entry root = new Entry('root', 'root', []);
    Entry current = root;

    for (ObjectsModel adapterObject in adapterObjects) {
      List<String> objectHierarchyIds =
          _getObjectHierarchyIds(adapterObject.id);
      List<String> objectHierarchyIdsFull =
          _getObjectHierarchyIdsFull(adapterObject.id);

      for (var i = 0; i < objectHierarchyIds.length; i++) {
        bool foundEntry = false;
        for (Entry child in current.children) {
          if (child.id == objectHierarchyIds[i]) {
            foundEntry = true;
            current = child;
          }
        }
        if (!foundEntry) {
          Entry newEntry = new Entry(
            objectHierarchyIds[i],
            _getNodeName(objectHierarchyIdsFull[i], nodes),
            [],
            i == objectHierarchyIds.length - 1
                ? ObjectListTile(object: adapterObject, state: this)
                : null,
          );
          current.children.add(newEntry);
          current = newEntry;
        }
      }
      current = root;
    }

    return root.children.length != 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                EntryItem(root.children[0]),
            itemCount: 1,
          )
        : Container();
  }

  List<String> _getObjectHierarchyIds(String id) {
    List<String> returnList = [];
    id.split('.').forEach((element) {
      returnList.add(element);
    });
    return returnList;
  }

  List<String> _getObjectHierarchyIdsFull(String id) {
    List<String> returnList = [];

    id.split('.').forEach((element) {
      returnList.add(element);
    });

    for (var i = 1; i < returnList.length; i++) {
      returnList[i] = returnList[i - 1] + '.' + returnList[i];
    }
    return returnList;
  }

  String _getNodeName(String objectsId, List<NodeModel> nodes) {
    for (var node in nodes) {
      if (node.id == objectsId) {
        return node.name;
      }
    }
    return objectsId;
  }

  StepState _getStepState(String step) {
    print(selectedObjectId);
    if (step == 'Widgettyp') {
      if (selectedWidgetType == '') {
        return StepState.editing;
      } else {
        return StepState.complete;
      }
    } else if (step == 'Datenpunkt') {
      if (selectedAdapterName == '') {
        return StepState.disabled;
      } else if (selectedObjectId == '') {
        return StepState.editing;
      } else {
        return StepState.complete;
      }
    } else if (step == 'Adapter') {
      if (selectedWidgetType == '') {
        return StepState.disabled;
      } else if (selectedAdapterName == '') {
        return StepState.editing;
      } else {
        return StepState.complete;
      }
    } else if (step == 'Widgetgröße') {
      if (selectedWidgetType == '') {
        return StepState.disabled;
      } else if (selectedWidgetSize == '') {
        return StepState.editing;
      } else {
        return StepState.complete;
      }
    } else if (step == 'Weitere Einstellungen') {
      if (selectedWidgetType == '') {
        return StepState.disabled;
      } else if (widgetName == '') {
        return StepState.editing;
      } else {
        return StepState.complete;
      }
    } else {
      return StepState.indexed;
    }
  }
}

class NodeModel {
  String name;
  String id;
  String type;

  NodeModel({this.name = '', this.id = '', this.type = ''});
}

class ObjectListTile extends StatelessWidget {
  final ObjectsModel object;

  var state;


  ObjectListTile(
      {this.object = const ObjectsModel('', '', '', ''), this.state});

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: ListTile(
        title: Text(object.name),
        subtitle: Text(object.id),
        onTap: () {
          this.state.setObjectId(object.id);
        },
      ),
    );
  }
}

class Entry {
  Entry(this.id, this.title,
      [this.children = const <Entry>[], this.objectTile]);

  final String id;
  final String title;
  final List<Entry> children;
  final ObjectListTile objectTile;
}

class EntryItem extends StatelessWidget {
  EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return root.objectTile;
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      leading: ClipOval(
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(4.0),
            splashColor: ColorSerivce.constMainColor,
            child: SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: Text(
                  root.children.length.toString(),
                  style: new TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        root.title,
        style: new TextStyle(fontWeight: FontWeight.w500),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
 */