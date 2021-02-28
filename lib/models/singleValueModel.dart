class SingleValueModel {
  final String name;
  final String objectId;
  final String size;

  SingleValueModel(this.name, this.objectId, this.size);

  factory SingleValueModel.fromJson(_json) {
    return SingleValueModel(
      _json['name'],
      _json['objectId'],
      _json['size'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'objectId': objectId,
        'size': size,
        'type': 'SingleValue'
      };
}
