class FavoriteModel {
  final String id;
  String title;
  String tileSize;
  String objectType;

  FavoriteModel({this.id, this.title, this.tileSize, this.objectType});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      title: json['title'],
      tileSize: json['tileSize'],
      objectType: json['objectType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'tileSize': tileSize,
        'objectType': objectType
      };

  setTitle(String title) {
    this.title = title;
  }

  setTileSize(String tileSize) {
    this.tileSize = tileSize;
  }

  setObjectType(String objectType) {
    this.objectType = objectType;
  }
}
