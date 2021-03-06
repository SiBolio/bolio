class AdapterModel {
  final String id;
  final String title;
  final String name;
  final String desc;
  final String iconUrl;


  AdapterModel({this.id, this.title, this.name, this.desc, this.iconUrl});

  factory AdapterModel.fromJson(_json) {
    var _desc = '';
    if (_json['common']['desc'] != null) {
      if (_json['common']['desc'] is String) {
        _desc = _json['common']['desc'];
      } else if (_json['common']['desc']['de'] is String) {
        _desc = _json['common']['desc']['de'];
      }
    }
    return AdapterModel(
      id: _json['_id'],
      title: _json['common']['title'],
      name: _json['common']['name'],
      desc: _desc,
      iconUrl: _json['common']['extIcon'],
    );
  }
}
