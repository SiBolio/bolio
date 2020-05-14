class FavoriteModel {
  final String id;
  String title;
  String tileSize;
  String objectType;
  String timeSpan;
  double sliderMin;
  double sliderMax;
  double setPointMin;
  double setPointMax;
  String pageId;
  int icon;
  bool secured;

  FavoriteModel(
      {this.id,
      this.title,
      this.tileSize,
      this.objectType,
      this.timeSpan,
      this.sliderMin,
      this.sliderMax,
      this.setPointMin,
      this.setPointMax,
      this.pageId,
      this.secured,
      this.icon});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      title: json['title'],
      tileSize: json['tileSize'],
      objectType: json['objectType'],
      timeSpan: json['timeSpan'],
      sliderMin: json['sliderMin'],
      sliderMax: json['sliderMax'],
      setPointMin:
          json['setPointMin'] != null ? json['setPointMin'].toDouble() : null,
      setPointMax:
          json['setPointMax'] != null ? json['setPointMax'].toDouble() : null,
      pageId: json['pageId'] != null ? json['pageId'] : null,
      secured: json['secured'] != null ? json['secured'] : false,
      icon: json['icon'] != null ? json['icon'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'tileSize': tileSize,
        'objectType': objectType,
        'timeSpan': timeSpan,
        'sliderMin': sliderMin,
        'sliderMax': sliderMax,
        'setPointMin': setPointMin,
        'setPointMax': setPointMax,
        'pageId': pageId,
        'secured': secured,
        'icon': icon,
      };

  setSecured(bool secured) {
    this.secured = secured;
  }

  setPageId(String pageId) {
    this.pageId = pageId;
  }

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

  setSetPointMin(String setPointMin) {
    if (setPointMin != null && setPointMin != '-' && setPointMin != '') {
      this.setPointMin = double.parse(setPointMin);
    } else {
      this.setPointMin = null;
    }
  }

  setSetPointMax(String setPointMax) {
    if (setPointMax != null && setPointMax != '-' && setPointMax != '') {
      this.setPointMax = double.parse(setPointMax);
    } else {
      this.setPointMax = null;
    }
  }

  setIcon(String icon) {
    if (icon != null && icon != '') {
      this.icon = int.parse(icon);
    } else {
      this.icon = null;
    }
  }
}
