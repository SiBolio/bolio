class ObjectsModel {
  final String id;
  final String type;
  final String typeReadable;
  final String name;
  final String desc;
  final double sliderMin;
  final double sliderMax;
  bool isfavorite;

  ObjectsModel(
      {this.id,
      this.type,
      this.name,
      this.desc,
      this.typeReadable,
      this.sliderMin,
      this.sliderMax});

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

    double _sliderMin = 0;
    if (_json['common']['min'] != null) {
      _sliderMin = _json['common']['min'].toDouble();
    }

    double _sliderMax = 0;
    if (_json['common']['max'] != null) {
      _sliderMax = _json['common']['max'].toDouble();
    }

    return ObjectsModel(
      id: _json['_id'],
      type: _json['common']['type'],
      typeReadable: _typeReadable,
      name: _json['common']['name'],
      desc: _desc,
      sliderMin: _sliderMin,
      sliderMax: _sliderMax,
    );
  }
}
