// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

KlimatologiAwsDayModel klimManualFromJson(String str) =>
    KlimatologiAwsDayModel.fromJson(json.decode(str));

String klimManualToJson(KlimatologiAwsDayModel data) =>
    json.encode(data.toJson());

class KlimatologiAwsDayModel {
  int? id;
  String? deviceId;
  DateTime? readingDate;
  double? evaporationAvg;
  double? evaporationMin;
  double? evaporationMax;
  double? humidityAvg;
  double? humidityMin;
  double? humidityMax;
  double? pressureAvg;
  double? pressureMin;
  double? pressureMax;
  double? solarRadiationAvg;
  double? solarRadiationMin;
  double? solarRadiationMax;
  double? sunshineHour;
  double? temperatureAvg;
  double? temperatureMin;
  double? temperatureMax;
  double? windDirectionAvg;
  double? windDirectionMin;
  double? windDirectionMax;
  double? windSpeedAvg;
  double? windSpeedMin;
  double? windSpeedMax;
  double? intensity;
  double? rainfall;
  double? rainfallMax;
  DateTime? rainfallDate;

  KlimatologiAwsDayModel({
    this.id,
    this.deviceId,
    this.readingDate,
    this.evaporationAvg,
    this.evaporationMin,
    this.evaporationMax,
    this.humidityAvg,
    this.humidityMin,
    this.humidityMax,
    this.pressureAvg,
    this.pressureMin,
    this.pressureMax,
    this.solarRadiationAvg,
    this.solarRadiationMin,
    this.solarRadiationMax,
    this.sunshineHour,
    this.temperatureAvg,
    this.temperatureMin,
    this.temperatureMax,
    this.windDirectionAvg,
    this.windDirectionMin,
    this.windDirectionMax,
    this.windSpeedAvg,
    this.windSpeedMin,
    this.windSpeedMax,
    this.intensity,
    this.rainfall,
    this.rainfallMax,
    this.rainfallDate,
  });

  factory KlimatologiAwsDayModel.fromJson(Map<String, dynamic> json) =>
      KlimatologiAwsDayModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingDate: DateTime.parse(json["reading_date"]),
        evaporationAvg: json["evaporation_avg"]?.toDouble(),
        evaporationMin: json["evaporation_min"]?.toDouble(),
        evaporationMax: json["evaporation_max"]?.toDouble(),
        humidityAvg: json["humidity_avg"]?.toDouble(),
        humidityMin: json["humidity_min"]?.toDouble(),
        humidityMax: json["humidity_max"]?.toDouble(),
        pressureAvg: json["pressure_avg"]?.toDouble(),
        pressureMin: json["pressure_min"]?.toDouble(),
        pressureMax: json["pressure_max"]?.toDouble(),
        solarRadiationAvg: json["solar_radiation_avg"]?.toDouble(),
        solarRadiationMin: json["solar_radiation_min"]?.toDouble(),
        solarRadiationMax: json["solar_radiation_max"]?.toDouble(),
        sunshineHour: json["sunshine_hour"]?.toDouble(),
        temperatureAvg: json["temperature_avg"]?.toDouble(),
        temperatureMin: json["temperature_min"]?.toDouble(),
        temperatureMax: json["temperature_max"]?.toDouble(),
        windDirectionAvg: json["wind_direction_avg"]?.toDouble(),
        windDirectionMin: json["wind_direction_min"]?.toDouble(),
        windDirectionMax: json["wind_direction_max"]?.toDouble(),
        windSpeedAvg: json["wind_speed_avg"]?.toDouble(),
        windSpeedMin: json["wind_speed_min"]?.toDouble(),
        windSpeedMax: json["wind_speed_max"]?.toDouble(),
        intensity: json["intensity"]?.toDouble(),
        rainfall: json["rainfall"]?.toDouble(),
        rainfallMax: json["rainfall_max"]?.toDouble(),
        rainfallDate: DateTime.parse(json["rainfall_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_date": readingDate?.toIso8601String(),
        "evaporation_avg": evaporationAvg,
        "evaporation_min": evaporationMin,
        "evaporation_max": evaporationMax,
        "humidity_avg": humidityAvg,
        "humidity_min": humidityMin,
        "humidity_max": humidityMax,
        "pressure_avg": pressureAvg,
        "pressure_min": pressureMin,
        "pressure_max": pressureMax,
        "solar_radiation_avg": solarRadiationAvg,
        "solar_radiation_min": solarRadiationMin,
        "solar_radiation_max": solarRadiationMax,
        "sunshine_hour": sunshineHour,
        "temperature_avg": temperatureAvg,
        "temperature_min": temperatureMin,
        "temperature_max": temperatureMax,
        "wind_direction_avg": windDirectionAvg,
        "wind_direction_min": windDirectionMin,
        "wind_direction_max": windDirectionMax,
        "wind_speed_avg": windSpeedAvg,
        "wind_speed_min": windSpeedMin,
        "wind_speed_max": windSpeedMax,
        "intensity": intensity,
        "rainfall": rainfall,
        "rainfall_max": rainfallMax,
        "rainfall_date": rainfallDate?.toIso8601String(),
      };
}
