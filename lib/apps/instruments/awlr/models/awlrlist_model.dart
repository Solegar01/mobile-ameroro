// To parse this JSON data, do
//
//     final awlrListModel = awlrListModelFromJson(jsonString);

import 'dart:convert';

AwlrListModel awlrListModelFromJson(String str) =>
    AwlrListModel.fromJson(json.decode(str));

String awlrListModelToJson(AwlrListModel data) => json.encode(data.toJson());

class AwlrListModel {
  String? id;
  String? deviceId;
  String? name;
  double? latitude;
  double? longitude;
  double? waterLevel;
  double? debit;
  double? siaga1;
  double? siaga2;
  double? siaga3;
  String? unitDisplay;
  String? deviceStatus;
  double? battery;
  DateTime? readingAt;
  DateTime? installedDate;

  AwlrListModel({
    this.id,
    this.deviceId,
    this.name,
    this.latitude,
    this.longitude,
    this.waterLevel,
    this.debit,
    this.siaga1,
    this.siaga2,
    this.siaga3,
    this.unitDisplay,
    this.deviceStatus,
    this.battery,
    this.readingAt,
    this.installedDate,
  });

  factory AwlrListModel.fromJson(Map<String, dynamic> json) => AwlrListModel(
        id: json["id"],
        deviceId: json["device_id"],
        name: json["name"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        waterLevel: json["water_level"].toDouble(),
        debit: json["debit"]?.toDouble(),
        siaga1: json["siaga1"]?.toDouble(),
        siaga2: json["siaga2"]?.toDouble(),
        siaga3: json["siaga3"]?.toDouble(),
        unitDisplay: json["unit_display"],
        deviceStatus: json["device_status"],
        battery: json["battery"]?.toDouble(),
        readingAt: DateTime.parse(json["reading_at"]),
        installedDate: json["installed_date"] != null
            ? DateTime.parse(json["installed_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "water_level": waterLevel,
        "debit": debit,
        "siaga1": siaga1,
        "siaga2": siaga2,
        "siaga3": siaga3,
        "unit_display": unitDisplay,
        "device_status": deviceStatus,
        "battery": battery,
        "reading_at": readingAt!.toIso8601String(),
        "installed_date": (installedDate?.toIso8601String()),
      };
}
