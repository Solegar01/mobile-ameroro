import 'dart:convert';

AwlrModel awlrModelFromJson(String str) => AwlrModel.fromJson(json.decode(str));

String awlrModelToJson(AwlrModel data) => json.encode(data.toJson());

class AwlrModel {
  double? waterLevel;
  double? debit;
  double? changeValue;
  String? changeStatus;
  String? warningStatus;
  int? id;
  String? name;
  String? deviceId;
  String? brandName;
  DateTime? readingAt;
  double? battery;
  String? status;

  AwlrModel({
    this.waterLevel,
    this.debit,
    this.changeValue,
    this.changeStatus,
    this.warningStatus,
    this.id,
    this.name,
    this.deviceId,
    this.brandName,
    this.readingAt,
    this.battery,
    this.status,
  });

  factory AwlrModel.fromJson(Map<String, dynamic> json) => AwlrModel(
        waterLevel: json["water_level"]?.toDouble(),
        debit: json["debit"]?.toDouble(),
        changeValue: json["change_value"]?.toDouble(),
        changeStatus: json["change_status"],
        warningStatus: json["warning_status"],
        id: json["id"],
        name: json["name"],
        deviceId: json["device_id"],
        brandName: json["brand_name"],
        readingAt: DateTime.parse(json["reading_at"]),
        battery: json["battery"]?.toDouble(),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "water_level": waterLevel,
        "debit": debit,
        "change_value": changeValue,
        "change_status": changeStatus,
        "warning_status": warningStatus,
        "id": id,
        "name": name,
        "device_id": deviceId,
        "brand_name": brandName,
        "reading_at": readingAt?.toIso8601String(),
        "battery": battery,
        "status": status,
      };
}
