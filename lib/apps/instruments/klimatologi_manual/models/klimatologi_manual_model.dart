// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

KlimatologiManualModel klimatologiManualModelFromJson(String str) =>
    KlimatologiManualModel.fromJson(json.decode(str));

String klimatologiManualModelToJson(KlimatologiManualModel data) =>
    json.encode(data.toJson());

class KlimatologiManualModel {
  String id;
  String stationId;
  DateTime readingDate;
  double? thermometerMin;
  double? thermometerMax;
  double? thermometerAvg;
  double? psychrometerDryBall;
  double? psychrometerWetBall;
  double? psycrometerDepresi;
  double? pychrometerRh;
  double? thermometerApungMin;
  double? thermometerApungMax;
  double? thermometerApungAvg;
  double? evaporationWaterRemoved;
  double? evaporationWaterAdded;
  double? evaporationWaterSum;
  double? anemometerWind;
  double? anemometerSpeed;
  double? rainfallManual;
  double? rainfalAutomatic;
  String? note;
  DateTime createdAt;
  String createdBy;

  KlimatologiManualModel({
    required this.id,
    required this.stationId,
    required this.readingDate,
    this.thermometerMin,
    this.thermometerMax,
    this.thermometerAvg,
    this.psychrometerDryBall,
    this.psychrometerWetBall,
    this.psycrometerDepresi,
    this.pychrometerRh,
    this.thermometerApungMin,
    this.thermometerApungMax,
    this.thermometerApungAvg,
    this.evaporationWaterRemoved,
    this.evaporationWaterAdded,
    this.evaporationWaterSum,
    this.anemometerWind,
    this.anemometerSpeed,
    this.rainfallManual,
    this.rainfalAutomatic,
    this.note,
    required this.createdAt,
    required this.createdBy,
  });

  factory KlimatologiManualModel.fromJson(Map<String, dynamic> json) =>
      KlimatologiManualModel(
        id: json["id"],
        stationId: json["station_id"],
        readingDate: DateTime.parse(json["reading_date"]),
        thermometerMin: json["thermometer_min"],
        thermometerMax: json["thermometer_max"],
        thermometerAvg: json["thermometer_avg"],
        psychrometerDryBall: json["psychrometer_dry_ball"],
        psychrometerWetBall: json["psychrometer_wet_ball"],
        psycrometerDepresi: json["psycrometer_depresi"],
        pychrometerRh: json["pychrometer_rh"],
        thermometerApungMin: json["thermometer_apung_min"],
        thermometerApungMax: json["thermometer_apung_max"],
        thermometerApungAvg: json["thermometer_apung_avg"],
        evaporationWaterRemoved: json["evaporation_water_removed"],
        evaporationWaterAdded: json["evaporation_water_added"],
        evaporationWaterSum: json["evaporation_water_sum"],
        anemometerWind: json["anemometer_wind"],
        anemometerSpeed: json["anemometer_speed"],
        rainfallManual: json["rainfall_manual"],
        rainfalAutomatic: json["rainfal_automatic"],
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "station_id": stationId,
        "reading_date": readingDate.toIso8601String(),
        "thermometer_min": thermometerMin,
        "thermometer_max": thermometerMax,
        "thermometer_avg": thermometerAvg,
        "psychrometer_dry_ball": psychrometerDryBall,
        "psychrometer_wet_ball": psychrometerWetBall,
        "psycrometer_depresi": psycrometerDepresi,
        "pychrometer_rh": pychrometerRh,
        "thermometer_apung_min": thermometerApungMin,
        "thermometer_apung_max": thermometerApungMax,
        "thermometer_apung_avg": thermometerApungAvg,
        "evaporation_water_removed": evaporationWaterRemoved,
        "evaporation_water_added": evaporationWaterAdded,
        "evaporation_water_sum": evaporationWaterSum,
        "anemometer_wind": anemometerWind,
        "anemometer_speed": anemometerSpeed,
        "rainfall_manual": rainfallManual,
        "rainfal_automatic": rainfalAutomatic,
        "note": note,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
      };
}
