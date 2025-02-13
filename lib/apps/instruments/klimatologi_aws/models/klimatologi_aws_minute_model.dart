// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

KlimatologiAwsMinuteModel klimManualFromJson(String str) =>
    KlimatologiAwsMinuteModel.fromJson(json.decode(str));

String klimManualToJson(KlimatologiAwsMinuteModel data) =>
    json.encode(data.toJson());

class KlimatologiAwsMinuteModel {
  int? id;
  String? deviceId;
  DateTime? readingAt;
  double? humadity;
  double? rainFall;
  String? humadityStatus;
  double? pressure;
  double? solarRadiation;
  double? temperature;
  double? windDirection;
  String? windDirectionStatus;
  double? windSpeed;
  double? evaporation;
  double? batteryVoltage;
  int? batteryCapacity;

  KlimatologiAwsMinuteModel({
    this.id,
    this.deviceId,
    this.readingAt,
    this.humadity,
    this.rainFall,
    this.humadityStatus,
    this.pressure,
    this.solarRadiation,
    this.temperature,
    this.windDirection,
    this.windDirectionStatus,
    this.windSpeed,
    this.evaporation,
    this.batteryVoltage,
    this.batteryCapacity,
  });

  factory KlimatologiAwsMinuteModel.fromJson(Map<String, dynamic> json) =>
      KlimatologiAwsMinuteModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingAt: DateTime.parse(json["reading_at"]),
        humadity: json["humadity"]?.toDouble(),
        rainFall: json["rainFall"]?.toDouble(),
        pressure: json["pressure"]?.toDouble(),
        solarRadiation: json["solar_radiation"]?.toDouble(),
        temperature: json["temperature"]?.toDouble(),
        windDirection: json["wind_direction"]?.toDouble(),
        windDirectionStatus: json["wind_direction_status"],
        windSpeed: json["wind_speed"]?.toDouble(),
        evaporation: json["evaporation"]?.toDouble(),
        batteryVoltage: json["battery_voltage"]?.toDouble(),
        batteryCapacity: json["battery_capacity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_at": readingAt?.toIso8601String(),
        "humidity": humadity,
        "rainfall": rainFall,
        "humidity_status": humadityStatus,
        "pressure": pressure,
        "solar_radiation": solarRadiation,
        "temperature": temperature,
        "wind_direction": windDirection,
        "wind_direction_status": windDirectionStatus,
        "wind_speed": windSpeed,
        "evaporation": evaporation,
        "battery_voltage": batteryVoltage,
        "battery_capacity": batteryCapacity
      };
}
