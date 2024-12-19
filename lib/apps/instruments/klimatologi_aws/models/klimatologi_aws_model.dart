// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

KlimatologiAwsModel klimManualFromJson(String str) =>
    KlimatologiAwsModel.fromJson(json.decode(str));

String klimManualToJson(KlimatologiAwsModel data) => json.encode(data.toJson());

class KlimatologiAwsModel {
  int? id;
  DateTime? readingDate;
  int? record;
  double? battery;
  double? airtempMin;
  double? airtempMax;
  double? rhMin;
  double? rhMax;
  double? dewpointMin;
  double? dewpointMax;
  double? wsMin;
  double? wsMax;
  double? solar;
  double? rainfall;
  double? bpMin;
  double? bpMax;
  DateTime? createdAt;
  String? createdBy;

  KlimatologiAwsModel({
    this.id,
    this.readingDate,
    this.record,
    this.battery,
    this.airtempMin,
    this.airtempMax,
    this.rhMin,
    this.rhMax,
    this.dewpointMin,
    this.dewpointMax,
    this.wsMin,
    this.wsMax,
    this.solar,
    this.rainfall,
    this.bpMin,
    this.bpMax,
    this.createdAt,
    this.createdBy,
  });

  factory KlimatologiAwsModel.fromJson(Map<String, dynamic> json) =>
      KlimatologiAwsModel(
        id: json["id"],
        readingDate: DateTime.parse(json["reading_date"]),
        record: json["record"],
        battery: json["battery"]?.toDouble(),
        airtempMin: (json["airtemp_min"] != "NaN")
            ? json["airtemp_min"]?.toDouble()
            : null,
        airtempMax: (json["airtemp_max"] != "NaN")
            ? json["airtemp_max"]?.toDouble()
            : null,
        rhMin: (json["rh_min"] != 'NaN') ? json["rh_min"]?.toDouble() : null,
        rhMax: (json["rh_max"] != "NaN") ? json["rh_max"]?.toDouble() : null,
        dewpointMin: json["dewpoint_min"]?.toDouble(),
        dewpointMax: json["dewpoint_max"]?.toDouble(),
        wsMin: json["ws_min"]?.toDouble(),
        wsMax: json["ws_max"]?.toDouble(),
        solar: json["solar"]?.toDouble(),
        rainfall: json["rainfall"]?.toDouble(),
        bpMin: json["bp_min"]?.toDouble(),
        bpMax: json["bp_max"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reading_date": readingDate?.toIso8601String(),
        "record": record,
        "battery": battery,
        "airtemp_min": airtempMin,
        "airtemp_max": airtempMax,
        "rh_min": rhMin,
        "rh_max": rhMax,
        "dewpoint_min": dewpointMin,
        "dewpoint_max": dewpointMax,
        "ws_min": wsMin,
        "ws_max": wsMax,
        "solar": solar,
        "rainfall": rainfall,
        "bp_min": bpMin,
        "bp_max": bpMax,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
      };
}
