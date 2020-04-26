class ObjectsModel {
  final String id;
  final String type;
  final String typeReadable;
  final String name;
  final String desc;
  bool isfavorite;

  ObjectsModel({this.id, this.type, this.name, this.desc, this.typeReadable});

  factory ObjectsModel.fromJson(_json) {
    String _desc = '';
    if (_json['common']['desc'] != null) {
      if (_json['common']['desc'] is String) {
        _desc = _json['common']['desc'];
      } else if (_json['common']['desc']['de'] is String) {
        _desc = _json['common']['desc']['de'];
      }
    }

    String _typeReadable;
    switch (_json['common']['type']) {
      case 'boolean':
        {
          _typeReadable = 'On/Off';
          break;
        }
      case 'number':
        {
          _typeReadable = 'Zahl';
          break;
        }
      case 'value':
        {
          _typeReadable = 'Wert';
          break;
        }
      case 'string':
        {
          _typeReadable = 'Text';
          break;
        }
      case 'object':
        {
          _typeReadable = 'Objekt';
          break;
        }
      default:
        {
          _typeReadable = 'Unbekannt';
          break;
        }
    }

    return ObjectsModel(
      id: _json['_id'],
      type: _json['common']['type'],
      typeReadable: _typeReadable,
      name: _json['common']['name'],
      desc: _desc,
    );
  }
}
