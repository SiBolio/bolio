class HistoryModel {
  final DateTime timeStamp;
  final double value;

  HistoryModel(this.timeStamp, this.value);

  factory HistoryModel.fromJson(_json) {
    return HistoryModel(
      DateTime.fromMillisecondsSinceEpoch(_json['ts']),
      _json['val'] != null ? _json['val'].toDouble() : 0,
    );
  }
}
