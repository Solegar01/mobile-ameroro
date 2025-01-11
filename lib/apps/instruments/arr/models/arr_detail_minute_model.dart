// To parse this JSON data, do
//
//     final arrDetailMinuteModel = arrDetailMinuteModelFromJson(jsonString);

import 'dart:convert';

ArrDetailMinuteModel arrDetailMinuteModelFromJson(String str) =>
    ArrDetailMinuteModel.fromJson(json.decode(str));

String arrDetailMinuteModelToJson(ArrDetailMinuteModel data) =>
    json.encode(data.toJson());

class ArrDetailMinuteModel {
  int? id;
  String? deviceId;
  DateTime? readingAt;
  double? rainfall;
  double? battery;
  String? instrumentName;

  ArrDetailMinuteModel({
    this.id,
    this.deviceId,
    this.readingAt,
    this.rainfall,
    this.battery,
    this.instrumentName,
  });

  factory ArrDetailMinuteModel.fromJson(Map<String, dynamic> json) =>
      ArrDetailMinuteModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingAt: DateTime.parse(json["reading_at"]),
        rainfall: json["rainfall"]?.toDouble(),
        battery: json["battery"]?.toDouble(),
        instrumentName: json["instrument_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_at": readingAt?.toIso8601String(),
        "rainfall": rainfall,
        "battery": battery,
        "instrument_name": instrumentName,
      };
}
