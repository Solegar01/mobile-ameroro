// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

InklinometerModel inklinometerFromJson(String str) =>
    InklinometerModel.fromJson(json.decode(str));

String inklinometerToJson(InklinometerModel data) => json.encode(data.toJson());

class InklinometerModel {
  int? id;
  DateTime? readingDate;
  double? depth;
  double? faceAPlus;
  double? faceAMinus;
  double? faceBPlus;
  double? faceBMinus;
  DateTime? createdAt;

  InklinometerModel({
    this.id,
    this.readingDate,
    this.depth,
    this.faceAPlus,
    this.faceAMinus,
    this.faceBPlus,
    this.faceBMinus,
    this.createdAt,
  });

  factory InklinometerModel.fromJson(Map<String, dynamic> json) =>
      InklinometerModel(
        id: json["id"],
        readingDate: DateTime.parse(json["reading_date"]),
        depth: json["depth"]?.toDouble(),
        faceAPlus: json["face_a_plus"]?.toDouble(),
        faceAMinus: json["face_a_minus"]?.toDouble(),
        faceBPlus: json["face_b_plus"]?.toDouble(),
        faceBMinus: json["face_b_minus"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reading_date": readingDate?.toIso8601String(),
        "depth": depth,
        "face_a_plus": faceAPlus,
        "face_a_minus": faceAMinus,
        "face_b_plus": faceBPlus,
        "face_b_minus": faceBMinus,
        "created_at": createdAt?.toIso8601String(),
      };
}
