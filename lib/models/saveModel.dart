class SaveModel {
  String uid;
  String name;
  String objectId;
  String secondaryObjectId;
  String type;
  String size;
  String adapterId;

  SaveModel(
      {this.name,
      this.objectId,
      this.secondaryObjectId,
      this.type,
      this.size,
      this.adapterId}) {
    this.uid = new DateTime.now().millisecondsSinceEpoch.toString();
  }

  factory SaveModel.fromJson(_json) {
    SaveModel saveModel = new SaveModel();

    saveModel.name = _json['name'];
    saveModel.objectId = _json['objectId'];
    saveModel.secondaryObjectId = _json['secondaryObjectId'];
    saveModel.type = _json['type'];
    saveModel.size = _json['size'];
    saveModel.adapterId = _json['adapterId'];
    saveModel.uid = _json['uid'];

    return saveModel;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'objectId': objectId,
        'secondaryObjectId': secondaryObjectId,
        'size': size,
        'type': type,
        'adapterId': adapterId,
        'uid': uid
      };
}