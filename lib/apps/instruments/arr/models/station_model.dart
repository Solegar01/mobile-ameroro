// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

Station stationFromJson(String str) => Station.fromJson(json.decode(str));

String stationToJson(Station data) => json.encode(data.toJson());

class Station {
  String? id;
  String? deviceId;
  String? type;
  double? latitude;
  double? longitude;
  double? siagaKekeringan;
  double? normal;
  double? waspadaBanjir;
  double? siagaBanjir;
  double? awasBanjir;
  double? koreksi;
  double? siaga1;
  double? siaga2;
  double? siaga3;
  String? unitDisplay;
  String? warningStatus;
  double? lastData;
  DateTime? lastReading;
  DateTime? installedDate;

  Station({
    this.id,
    this.deviceId,
    this.type,
    this.latitude,
    this.longitude,
    this.siagaKekeringan,
    this.normal,
    this.waspadaBanjir,
    this.siagaBanjir,
    this.awasBanjir,
    this.koreksi,
    this.siaga1,
    this.siaga2,
    this.siaga3,
    this.unitDisplay,
    this.warningStatus,
    this.lastData,
    this.lastReading,
    this.installedDate,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json["id"],
        deviceId: json["device_id"],
        type: json["type"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        siagaKekeringan: json["siaga_kekeringan"]?.toDouble(),
        normal: json["normal"]?.toDouble(),
        waspadaBanjir: json["waspada_banjir"]?.toDouble(),
        siagaBanjir: json["siaga_banjir"]?.toDouble(),
        awasBanjir: json["awas_banjir"]?.toDouble(),
        koreksi: json["koreksi"]?.toDouble(),
        siaga1: json["siaga1"]?.toDouble(),
        siaga2: json["siaga2"]?.toDouble(),
        siaga3: json["siaga3"]?.toDouble(),
        unitDisplay: json["unit_display"],
        warningStatus: json["warning_status"],
        lastData: json["last_data"]?.toDouble(),
        lastReading: json["last_reading"] == null
            ? null
            : DateTime.parse(json["last_reading"]),
        installedDate: json["installed_date"] == null
            ? null
            : DateTime.parse(json["installed_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "siaga_kekeringan": siagaKekeringan,
        "normal": normal,
        "waspada_banjir": waspadaBanjir,
        "siaga_banjir": siagaBanjir,
        "awas_banjir": awasBanjir,
        "koreksi": koreksi,
        "siaga1": siaga1,
        "siaga2": siaga2,
        "siaga3": siaga3,
        "unit_display": unitDisplay,
        "warning_status": warningStatus,
        "last_data": lastData,
        "last_reading": lastReading?.toIso8601String(),
        "installed_date": lastReading?.toIso8601String(),
      };
}
