
class PageModel {
  String id;
  String title;
  int icon;

  PageModel({this.title, this.icon, this.id});

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'],
      title: json['title'],
      icon: int.parse(json['icon']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon': icon.toString(),
      };

  setTite(String title) {
    this.title = title;
  }

  setIcon(int icon) {
    this.icon = icon;
  }
}
