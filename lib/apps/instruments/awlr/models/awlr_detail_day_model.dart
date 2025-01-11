import 'dart:convert';

AwlrDetailDayModel awlrDetailDayModelFromJson(String str) =>
    AwlrDetailDayModel.fromJson(json.decode(str));

String awlrDetailDayModelToJson(AwlrDetailDayModel data) =>
    json.encode(data.toJson());

class AwlrDetailDayModel {
  int? id;
  String? deviceId;
  DateTime? readingDate;
  double? waterLevelMin;
  double? waterLevelMax;
  double? waterLevelAvg;
  String? instrumentName;

  AwlrDetailDayModel({
    this.id,
    this.deviceId,
    this.readingDate,
    this.waterLevelMin,
    this.waterLevelMax,
    this.waterLevelAvg,
    this.instrumentName,
  });

  factory AwlrDetailDayModel.fromJson(Map<String, dynamic> json) =>
      AwlrDetailDayModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingDate: DateTime.parse(json["reading_date"]),
        waterLevelMin: json["water_level_min"]?.toDouble(),
        waterLevelMax: json["water_level_max"]?.toDouble(),
        waterLevelAvg: json["water_level_avg"]?.toDouble(),
        instrumentName: json["instrument_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_date": readingDate?.toIso8601String(),
        "water_level_min": waterLevelMin,
        "water_level_max": waterLevelMax,
        "water_level_avg": waterLevelAvg,
        "instrument_name": instrumentName,
      };
}
