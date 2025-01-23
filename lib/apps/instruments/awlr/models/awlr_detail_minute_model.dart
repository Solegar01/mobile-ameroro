import 'dart:convert';

AwlrDetailMinuteModel awlrDetailMinuteModelFromJson(String str) =>
    AwlrDetailMinuteModel.fromJson(json.decode(str));

String awlrDetailMinuteModelToJson(AwlrDetailMinuteModel data) =>
    json.encode(data.toJson());

class AwlrDetailMinuteModel {
  int? id;
  String? deviceId;
  DateTime? readingAt;
  double? waterLevel;
  double? debit;
  double? changeValue;
  String? changeStatus;
  String? warningStatus;
  double? batteryVoltage;
  int? batteryCapacity;

  AwlrDetailMinuteModel({
    this.id,
    this.deviceId,
    this.readingAt,
    this.waterLevel,
    this.debit,
    this.changeValue,
    this.changeStatus,
    this.warningStatus,
    this.batteryVoltage,
    this.batteryCapacity,
  });

  factory AwlrDetailMinuteModel.fromJson(Map<String, dynamic> json) =>
      AwlrDetailMinuteModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingAt: DateTime.parse(json["reading_at"]),
        waterLevel: json["water_level"]?.toDouble(),
        debit: json["debit"]?.toDouble(),
        changeValue: json["change_value"]?.toDouble(),
        changeStatus: json["change_status"],
        warningStatus: json["warning_status"],
        batteryVoltage: json["battery_voltage"]?.toDouble(),
        batteryCapacity: json["battery_capacity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_at": readingAt?.toIso8601String(),
        "water_level": waterLevel,
        "debit": debit,
        "change_value": changeValue,
        "change_status": changeStatus,
        "warning_status": warningStatus,
        "battery_voltage": batteryVoltage,
        "battery_capacity": batteryCapacity,
      };
}
