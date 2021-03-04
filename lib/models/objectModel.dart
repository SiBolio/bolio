class ObjectsModel {
  final String id;
  final String dataType;
  final String name;
  final String desc;
  final String objectType;

  const ObjectsModel(
      {this.id, this.dataType, this.name, this.desc, this.objectType});

  factory ObjectsModel.fromJson(_json) {
    String _desc = '';
    if (_json['common']['desc'] != null) {
      if (_json['common']['desc'] is String) {
        _desc = _json['common']['desc'];
      } else if (_json['common']['desc']['de'] is String) {
        _desc = _json['common']['desc']['de'];
      }
    }

    return ObjectsModel(
      id: _json['_id'],
      dataType: _json['common']['type'],
      name: _json['common']['name'],
      desc: _desc,
      objectType: _json['type'],
    );
  }
}
