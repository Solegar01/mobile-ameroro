// To parse this JSON data, do
//
//     final arrDetailDayModel = arrDetailDayModelFromJson(jsonString);

import 'dart:convert';

ArrDetailDayModel arrDetailDayModelFromJson(String str) =>
    ArrDetailDayModel.fromJson(json.decode(str));

String arrDetailDayModelToJson(ArrDetailDayModel data) =>
    json.encode(data.toJson());

class ArrDetailDayModel {
  int? id;
  String? deviceId;
  DateTime? readingDate;
  double? rainfall;
  String? intensity;
  double? rainfallMax;
  String? instrumentName;

  ArrDetailDayModel({
    this.id,
    this.deviceId,
    this.readingDate,
    this.rainfall,
    this.intensity,
    this.rainfallMax,
    this.instrumentName,
  });

  factory ArrDetailDayModel.fromJson(Map<String, dynamic> json) =>
      ArrDetailDayModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingDate: DateTime.parse(json["reading_date"]),
        rainfall: json["rainfall"]?.toDouble(),
        intensity: json["intensity"],
        rainfallMax: json["rainfall_max"],
        instrumentName: json["instrument_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_date": readingDate?.toIso8601String(),
        "rainfall": rainfall,
        "intensity": intensity,
        "rainfall_max": rainfallMax,
        "instrument_name": instrumentName,
      };
}
