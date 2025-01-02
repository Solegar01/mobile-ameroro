// To parse this JSON data, do
//
//     final arrModel = arrModelFromJson(jsonString);

import 'dart:convert';

ArrModel arrModelFromJson(String str) => ArrModel.fromJson(json.decode(str));

String arrModelToJson(ArrModel data) => json.encode(data.toJson());

class ArrModel {
  double? rainfall;
  int? rainfallLastHour;
  String? intensityLastHour;
  int? id;
  String? name;
  String? deviceId;
  String? brandName;
  DateTime? readingAt;
  double? battery;
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
    this.battery,
    this.status,
  });

  factory ArrModel.fromJson(Map<String, dynamic> json) => ArrModel(
        rainfall: json["rainfall"]?.toDouble(),
        rainfallLastHour: json["rainfall_last_hour"]?.toInt(),
        intensityLastHour: json["intensity_last_hour"],
        id: json["id"],
        name: json["name"],
        deviceId: json["device_id"],
        brandName: json["brand_name"],
        readingAt: DateTime.parse(json["reading_at"]),
        battery: json["battery"]?.toDouble(),
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
        "battery": battery,
        "status": status,
      };
}
