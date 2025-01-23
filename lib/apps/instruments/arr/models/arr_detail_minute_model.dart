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
  double? batteryVoltage;
  int? batteryCapacity;

  ArrDetailMinuteModel({
    this.id,
    this.deviceId,
    this.readingAt,
    this.rainfall,
    this.batteryVoltage,
    this.batteryCapacity,
  });

  factory ArrDetailMinuteModel.fromJson(Map<String, dynamic> json) =>
      ArrDetailMinuteModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingAt: DateTime.parse(json["reading_at"]),
        rainfall: json["rainfall"]?.toDouble(),
        batteryVoltage: json["battery_voltage"]?.toDouble(),
        batteryCapacity: json["battery_capacity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_at": readingAt?.toIso8601String(),
        "rainfall": rainfall,
        "battery_voltage": batteryVoltage,
        "battery_capacity": batteryCapacity,
      };
}
