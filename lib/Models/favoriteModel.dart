class FavoriteModel {
  final String id;
  String title;
  String tileSize;
  String objectType;
  String timeSpan;
  double sliderMin;
  double sliderMax;
  int setPointMin;
  int setPointMax;

  FavoriteModel(
      {this.id,
      this.title,
      this.tileSize,
      this.objectType,
      this.timeSpan,
      this.sliderMin,
      this.sliderMax,
      this.setPointMin,
      this.setPointMax});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      title: json['title'],
      tileSize: json['tileSize'],
      objectType: json['objectType'],
      timeSpan: json['timeSpan'],
      sliderMin: json['sliderMax'],
      sliderMax: json['sliderMax'],
      setPointMin: json['setPointMin'],
      setPointMax: json['setPointMax'],
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

  setSetPointMin(String setPointMin) {
    if (setPointMin != '-' && setPointMin != '') {
      this.setPointMin = int.parse(setPointMin);
    } else {
      this.setPointMin = null;
    }
  }

  setSetPointMax(String setPointMax) {
    if (setPointMax != '-' && setPointMax != '') {
      this.setPointMax = int.parse(setPointMax);
    } else {
      this.setPointMax = null;
    }
  }
}
