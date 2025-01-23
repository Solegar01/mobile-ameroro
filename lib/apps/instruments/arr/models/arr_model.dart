// To parse this JSON data, do
//
//     final arrModel = arrModelFromJson(jsonString);

import 'dart:convert';

ArrModel arrModelFromJson(String str) => ArrModel.fromJson(json.decode(str));

String arrModelToJson(ArrModel data) => json.encode(data.toJson());

class ArrModel {
  double? rainfall;
  double? rainfallLastHour;
  String? intensityLastHour;
  int? id;
  String? name;
  String? deviceId;
  String? brandName;
  DateTime? readingAt;
  double? batteryVoltage;
  int? batteryCapacity;
  String? status;

  ArrModel({
    this.rainfall,
    this.rainfallLastHour,
    this.intensityLastHour,
    this.id,
    this.name,
    this.deviceId,
    this.brandName,
    this.readingAt,
    this.batteryVoltage,
    this.batteryCapacity,
    this.status,
  });

  factory ArrModel.fromJson(Map<String, dynamic> json) => ArrModel(
        rainfall: json["rainfall"]?.toDouble(),
        rainfallLastHour: json["rainfall_last_hour"]?.toDouble(),
        intensityLastHour: json["intensity_last_hour"],
        id: json["id"],
        name: json["name"],
        deviceId: json["device_id"],
        brandName: json["brand_name"],
        readingAt: DateTime.parse(json["reading_at"]),
        batteryVoltage: json["battery_voltage"]?.toDouble(),
        batteryCapacity: json["battery_capacity"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "rainfall": rainfall,
        "rainfall_last_hour": rainfallLastHour,
        "intensity_last_hour": intensityLastHour,
        "id": id,
        "name": name,
        "device_id": deviceId,
        "brand_name": brandName,
        "reading_at": readingAt?.toIso8601String(),
        "battery_voltage": batteryVoltage,
        "battery_capacity": batteryCapacity,
        "status": status,
      };
}
