import 'dart:convert';

AwlrModel awlrModelFromJson(String str) => AwlrModel.fromJson(json.decode(str));

String awlrModelToJson(AwlrModel data) => json.encode(data.toJson());

class AwlrModel {
  String? stationName;
  String? deviceId;
  String? brandName;
  DateTime? readingAt;
  double? waterLevel;
  double? debit;
  double? changeValue;
  String? changeStatus;
  String? warningStatus;
  double? batteryVoltage;
  int? batteryCapacity;
  String? status;

  AwlrModel({
    this.stationName,
    this.deviceId,
    this.brandName,
    this.readingAt,
    this.waterLevel,
    this.debit,
    this.changeValue,
    this.changeStatus,
    this.warningStatus,
    this.batteryVoltage,
    this.batteryCapacity,
    this.status,
  });

  factory AwlrModel.fromJson(Map<String, dynamic> json) => AwlrModel(
        stationName: json["station_name"],
        deviceId: json["device_id"],
        brandName: json["brand_name"],
        readingAt: DateTime.parse(json["reading_at"]),
        waterLevel: json["water_level"]?.toDouble(),
        debit: json["debit"]?.toDouble(),
        changeValue: json["change_value"]?.toDouble(),
        changeStatus: json["change_status"],
        warningStatus: json["warning_status"],
        batteryVoltage: json["battery_voltage"]?.toDouble(),
        batteryCapacity: json["battery_capacity"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "station_name": stationName,
        "device_id": deviceId,
        "brand_name": brandName,
        "reading_at": readingAt?.toIso8601String(),
        "water_level": waterLevel,
        "debit": debit,
        "change_value": changeValue,
        "change_status": changeStatus,
        "warning_status": warningStatus,
        "battery_voltage": batteryVoltage,
        "battery_capacity": batteryCapacity,
        "status": status,
      };
}
