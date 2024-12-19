// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

VNotchModel vnotchFromJson(String str) =>
    VNotchModel.fromJson(json.decode(str));

String vnotchToJson(VNotchModel data) => json.encode(data.toJson());

class VNotchModel {
  String? deviceId;
  DateTime? readingAt;
  double? waterLevel;
  double? debit;
  double? changeValue;
  String? changeStatus;
  String? warningStatus;
  double? battery;

  VNotchModel({
    this.deviceId,
    this.readingAt,
    this.waterLevel,
    this.debit,
    this.changeValue,
    this.changeStatus,
    this.warningStatus,
    this.battery,
  });

  factory VNotchModel.fromJson(Map<String, dynamic> json) => VNotchModel(
        deviceId: json["device_id"],
        readingAt: DateTime.parse(json["reading_at"]),
        waterLevel: json["water_level"]?.toDouble(),
        debit: json["debit"]?.toDouble(),
        changeValue: json["change_value"]?.toDouble(),
        changeStatus: json["change_status"],
        warningStatus: json["warning_status"],
        battery: json["battery"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "reading_at": readingAt?.toIso8601String(),
        "water_level": waterLevel,
        "debit": debit,
        "change_value": changeValue,
        "change_status": changeStatus,
        "warning_status": warningStatus,
        "battery": battery,
      };
}
