class FavoriteModel {
  final String id;
  final String title;

  FavoriteModel({
    this.id,
    this.title,
  });

  Map<String, dynamic> toJson() => {'id': id, 'title': title};

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
