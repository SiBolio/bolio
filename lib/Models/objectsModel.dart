class ObjectsModel {
  final String id;
  final String type;
  final String name;
  final String desc;

  ObjectsModel({this.id, this.type, this.name, this.desc});

  factory ObjectsModel.fromJson(_json) {
    var _desc = ''; 
    if (_json['common']['desc'] != null) {
      if (_json['common']['desc'] is String) {
        _desc = _json['common']['desc'];
      } else if (_json['common']['desc']['de'] is String) {
        _desc = _json['common']['desc']['de'];
      }
    }

    return ObjectsModel(
      id: _json['_id'],
      type: _json['common']['type'],
      name: _json['common']['name'],
      desc: _desc,
    );
  }
}
