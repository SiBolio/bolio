class FavoriteModel {
  final String id;
  String title;
  String tileSize;
  String objectType;
  String timeSpan;

  FavoriteModel(
      {this.id, this.title, this.tileSize, this.objectType, this.timeSpan});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
        id: json['id'],
        title: json['title'],
        tileSize: json['tileSize'],
        objectType: json['objectType'],
        timeSpan: json['timeSpan']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'tileSize': tileSize,
        'objectType': objectType,
        'timeSpan': timeSpan
      };

  setTitle(String title) {
    this.title = title;
  }

  setTimeSpan(String timeSpan) {
    this.timeSpan = timeSpan;
  }

  setTileSize(String tileSize) {
    this.tileSize = tileSize;
  }

  setObjectType(String objectType) {
    this.objectType = objectType;
  }
}
