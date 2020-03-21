class FavoriteList {
  final List<FavoriteModel> favorites;

  FavoriteList({this.favorites});

  factory FavoriteList.fromJson(List<dynamic> json) {
    return new FavoriteList(
      favorites: json.map((i) => FavoriteModel.fromJson(i)).toList(),
    );
  }
}

class FavoriteModel {
  final String id;
  final String title;

  FavoriteModel({
    this.id,
    this.title,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
