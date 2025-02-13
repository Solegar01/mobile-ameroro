// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

KlimatologiAwsHourModel klimManualFromJson(String str) =>
    KlimatologiAwsHourModel.fromJson(json.decode(str));

String klimManualToJson(KlimatologiAwsHourModel data) =>
    json.encode(data.toJson());

class KlimatologiAwsHourModel {
  int? id;
  String? deviceId;
  DateTime? readingHour;
  double? humidity;
  String? humidityStatus;
  double? rainfall;
  double? intensity;
  double? pressure;
  double? temperature;
  double? windDirection;
  String? windDirectionStatus;
  double? windSpeed;
  double? evaporation;
  double? solarRadiation;

  KlimatologiAwsHourModel({
    this.id,
    this.deviceId,
    this.readingHour,
    this.humidity,
    this.humidityStatus,
    this.rainfall,
    this.intensity,
    this.pressure,
    this.temperature,
    this.windDirection,
    this.windDirectionStatus,
    this.windSpeed,
    this.evaporation,
    this.solarRadiation,
  });

  factory KlimatologiAwsHourModel.fromJson(Map<String, dynamic> json) =>
      KlimatologiAwsHourModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingHour: DateTime.parse(json["reading_hour"]),
        humidity: json["humidity"]?.toDouble(),
        humidityStatus: json["humidity_status"],
        rainfall: json["rainfall"]?.toDouble(),
        intensity: json["intensity"]?.toDouble(),
        pressure: json["pressure"]?.toDouble(),
        temperature: json["temperature"]?.toDouble(),
        windDirection: json["wind_direction"]?.toDouble(),
        windDirectionStatus: json["wind_direction_status"],
        windSpeed: json["wind_speed"]?.toDouble(),
        evaporation: json["evaporation"]?.toDouble(),
        solarRadiation: json["solar_radiation"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_hour": readingHour?.toIso8601String(),
        "humidity": humidity,
        "humidity_status": humidityStatus,
        "rainfall": rainfall,
        "intensity": intensity,
        "pressure": pressure,
        "temperature": temperature,
        "wind_direction": windDirection,
        "wind_direction_status": windDirectionStatus,
        "wind_speed": windSpeed,
        "evaporation": evaporation,
        "solar_radiation": solarRadiation,
      };
}
