import 'dart:convert';

AwlrDetailHourModel awlrDetailHourModelFromJson(String str) =>
    AwlrDetailHourModel.fromJson(json.decode(str));

String awlrDetailHourModelToJson(AwlrDetailHourModel data) =>
    json.encode(data.toJson());

class AwlrDetailHourModel {
  int? id;
  String? deviceId;
  DateTime? readingHour;
  double? waterLevel;
  double? debit;
  String? warningStatus;
  double? battery;
  String? instrumentName;
  String? statusTma;

  AwlrDetailHourModel({
    this.id,
    this.deviceId,
    this.readingHour,
    this.waterLevel,
    this.debit,
    this.warningStatus,
    this.battery,
    this.instrumentName,
    this.statusTma,
  });

  factory AwlrDetailHourModel.fromJson(Map<String, dynamic> json) =>
      AwlrDetailHourModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingHour: DateTime.parse(json["reading_hour"]),
        waterLevel: json["water_level"]?.toDouble(),
        debit: json["debit"]?.toDouble,
        warningStatus: json["warning_status"],
        battery: json["battery"]?.toDouble(),
        instrumentName: json["instrument_name"],
        statusTma: json["status_tma"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_hour": readingHour?.toIso8601String(),
        "water_level": waterLevel,
        "debit": debit,
        "warning_status": warningStatus,
        "battery": battery,
        "instrument_name": instrumentName,
        "status_tma": statusTma,
      };
}
