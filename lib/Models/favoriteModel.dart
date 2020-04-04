class FavoriteModel {
  final String id;
  String title;

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };

  setTitle(String title) {
    this.title = title;
  }
}
