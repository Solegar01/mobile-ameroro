// To parse this JSON data, do
//
//     final arrDetailHourModel = arrDetailHourModelFromJson(jsonString);

import 'dart:convert';

ArrDetailHourModel arrDetailHourModelFromJson(String str) =>
    ArrDetailHourModel.fromJson(json.decode(str));

String arrDetailHourModelToJson(ArrDetailHourModel data) =>
    json.encode(data.toJson());

class ArrDetailHourModel {
  int? id;
  String? deviceId;
  DateTime? readingHour;
  double? rainfall;
  String? intensity;

  ArrDetailHourModel({
    this.id,
    this.deviceId,
    this.readingHour,
    this.rainfall,
    this.intensity,
  });

  factory ArrDetailHourModel.fromJson(Map<String, dynamic> json) =>
      ArrDetailHourModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingHour: DateTime.parse(json["reading_hour"]),
        rainfall: json["rainfall"]?.toDouble(),
        intensity: json["intensity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_hour": readingHour?.toIso8601String(),
        "rainfall": rainfall,
        "intensity": intensity,
      };
}
