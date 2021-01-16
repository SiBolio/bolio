class ObjectsModel {
  final String id;
  final String type;
  final String name;
  final String desc;

  const ObjectsModel(this.id, this.type, this.name, this.desc);

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
      _json['_id'],
      _json['common']['type'],
      _json['common']['name'],
      _desc,
    );
  }
}
