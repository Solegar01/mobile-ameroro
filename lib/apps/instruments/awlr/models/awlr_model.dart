// To parse this JSON data, do
//
//     final awlrModel = awlrModelFromJson(jsonString);

import 'dart:convert';

AwlrModel awlrModelFromJson(String str) => AwlrModel.fromJson(json.decode(str));

String awlrModelToJson(AwlrModel data) => json.encode(data.toJson());

class AwlrModel {
  String? deviceId;
  double? battery;
  final DateTime readingAt;
  double? waterLevel;
  double? waterLevelElevation;
  double? debit;
  double? changeValue;
  String? changeStatus;
  String? warningStatus;

  AwlrModel({
    this.deviceId,
    this.battery,
    required this.readingAt,
    this.waterLevel,
    this.waterLevelElevation,
    this.debit,
    this.changeValue,
    this.changeStatus,
    this.warningStatus,
  });

  factory AwlrModel.fromJson(Map<String, dynamic> json) => AwlrModel(
        deviceId: json["device_id"],
        battery: json["battery"]?.toDouble(),
        readingAt: DateTime.parse(json["reading_at"]),
        waterLevel: json["water_level"]?.toDouble(),
        waterLevelElevation: json["water_level_elevation"]?.toDouble(),
        debit: json["debit"]?.toDouble(),
        changeValue: json["change_value"]?.toDouble(),
        changeStatus: json["change_status"],
        warningStatus: json["warning_status"],
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "battery": battery,
        "reading_at": readingAt.toIso8601String(),
        "water_level": waterLevel,
        "water_level_elevation": waterLevelElevation,
        "debit": debit,
        "change_value": changeValue,
        "change_status": changeStatus,
        "warning_status": warningStatus,
      };
}
