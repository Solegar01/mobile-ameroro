class VibratingWireModel {
  List<VibratingWire>? listVibratingWire;
  List<Intake>? listIntake;
  List<RainFall>? listRainFall;

  VibratingWireModel({
    this.listVibratingWire,
    this.listIntake,
    this.listRainFall,
  });
}

class VibratingWire {
  DateTime readingDate;
  double? sensorEp5Id;
  double? sensorEp5R1;
  double? sensorEp5WaterPressureE;
  double? sensorEp5WaterPressureM;
  double? sensorEp5Elevation;
  double? sensorEp9Id;
  double? sensorEp9R1;
  double? sensorEp9WaterPressureE;
  double? sensorEp9WaterPressureM;
  double? sensorEp9Elevation;
  double? sensorEp11Id;
  double? sensorEp11R1;
  double? sensorEp11WaterPressureE;
  double? sensorEp11WaterPressureM;
  double? sensorEp11Elevation;
  double? sensorEp7Id;
  double? sensorEp7R1;
  double? sensorEp7WaterPressureE;
  double? sensorEp7WaterPressureM;
  double? sensorEp7Elevation;
  double? sensorEp1Id;
  double? sensorEp1R1;
  double? sensorEp1WaterPressureE;
  double? sensorEp1WaterPressureM;
  double? sensorEp1Elevation;
  double? sensorEp8Id;
  double? sensorEp8R1;
  double? sensorEp8WaterPressureE;
  double? sensorEp8WaterPressureM;
  double? sensorEp8Elevation;
  double? sensorEp6Id;
  double? sensorEp6R1;
  double? sensorEp6WaterPressureE;
  double? sensorEp6WaterPressureM;
  double? sensorEp6Elevation;
  double? sensorEp10Id;
  double? sensorEp10R1;
  double? sensorEp10WaterPressureE;
  double? sensorEp10WaterPressureM;
  double? sensorEp10Elevation;
  double? sensorEp3Id;
  double? sensorEp3R1;
  double? sensorEp3WaterPressureE;
  double? sensorEp3WaterPressureM;
  double? sensorEp3Elevation;
  double? sensorEp2Id;
  double? sensorEp2R1;
  double? sensorEp2WaterPressureE;
  double? sensorEp2WaterPressureM;
  double? sensorEp2Elevation;
  double? sensorEp4Id;
  double? sensorEp4R1;
  double? sensorEp4WaterPressureE;
  double? sensorEp4WaterPressureM;
  double? sensorEp4Elevation;
  double? sensorEp12Id;
  double? sensorEp12R1;
  double? sensorEp12WaterPressureE;
  double? sensorEp12WaterPressureM;
  double? sensorEp12Elevation;
  double? pileElevation;

  VibratingWire({
    required this.readingDate,
    this.sensorEp5Id,
    this.sensorEp5R1,
    this.sensorEp5WaterPressureE,
    this.sensorEp5WaterPressureM,
    this.sensorEp5Elevation,
    this.sensorEp9Id,
    this.sensorEp9R1,
    this.sensorEp9WaterPressureE,
    this.sensorEp9WaterPressureM,
    this.sensorEp9Elevation,
    this.sensorEp11Id,
    this.sensorEp11R1,
    this.sensorEp11WaterPressureE,
    this.sensorEp11WaterPressureM,
    this.sensorEp11Elevation,
    this.sensorEp7Id,
    this.sensorEp7R1,
    this.sensorEp7WaterPressureE,
    this.sensorEp7WaterPressureM,
    this.sensorEp7Elevation,
    this.sensorEp1Id,
    this.sensorEp1R1,
    this.sensorEp1WaterPressureE,
    this.sensorEp1WaterPressureM,
    this.sensorEp1Elevation,
    this.sensorEp8Id,
    this.sensorEp8R1,
    this.sensorEp8WaterPressureE,
    this.sensorEp8WaterPressureM,
    this.sensorEp8Elevation,
    this.sensorEp6Id,
    this.sensorEp6R1,
    this.sensorEp6WaterPressureE,
    this.sensorEp6WaterPressureM,
    this.sensorEp6Elevation,
    this.sensorEp10Id,
    this.sensorEp10R1,
    this.sensorEp10WaterPressureE,
    this.sensorEp10WaterPressureM,
    this.sensorEp10Elevation,
    this.sensorEp3Id,
    this.sensorEp3R1,
    this.sensorEp3WaterPressureE,
    this.sensorEp3WaterPressureM,
    this.sensorEp3Elevation,
    this.sensorEp2Id,
    this.sensorEp2R1,
    this.sensorEp2WaterPressureE,
    this.sensorEp2WaterPressureM,
    this.sensorEp2Elevation,
    this.sensorEp4Id,
    this.sensorEp4R1,
    this.sensorEp4WaterPressureE,
    this.sensorEp4WaterPressureM,
    this.sensorEp4Elevation,
    this.sensorEp12Id,
    this.sensorEp12R1,
    this.sensorEp12WaterPressureE,
    this.sensorEp12WaterPressureM,
    this.sensorEp12Elevation,
    this.pileElevation,
  });

  factory VibratingWire.fromJson(Map<String, dynamic> json) => VibratingWire(
        readingDate: DateTime.parse(json["reading_date"]),
        sensorEp5Id: json["sensor_ep_5_id"]?.toDouble(),
        sensorEp5R1: json["sensor_ep_5_r1"]?.toDouble(),
        sensorEp5WaterPressureE:
            json["sensor_ep_5_water_pressure_e"]?.toDouble(),
        sensorEp5WaterPressureM:
            json["sensor_ep_5_water_pressure_m"]?.toDouble(),
        sensorEp5Elevation: json["sensor_ep_5_elevation"]?.toDouble(),
        sensorEp9Id: json["sensor_ep_9_id"]?.toDouble(),
        sensorEp9R1: json["sensor_ep_9_r1"]?.toDouble(),
        sensorEp9WaterPressureE:
            json["sensor_ep_9_water_pressure_e"]?.toDouble(),
        sensorEp9WaterPressureM:
            json["sensor_ep_9_water_pressure_m"]?.toDouble(),
        sensorEp9Elevation: json["sensor_ep_9_elevation"]?.toDouble(),
        sensorEp11Id: json["sensor_ep_11_id"]?.toDouble(),
        sensorEp11R1: json["sensor_ep_11_r1"]?.toDouble(),
        sensorEp11WaterPressureE:
            json["sensor_ep_11_water_pressure_e"]?.toDouble(),
        sensorEp11WaterPressureM:
            json["sensor_ep_11_water_pressure_m"]?.toDouble(),
        sensorEp11Elevation: json["sensor_ep_11_elevation"]?.toDouble(),
        sensorEp7Id: json["sensor_ep_7_id"]?.toDouble(),
        sensorEp7R1: json["sensor_ep_7_r1"]?.toDouble(),
        sensorEp7WaterPressureE:
            json["sensor_ep_7_water_pressure_e"]?.toDouble(),
        sensorEp7WaterPressureM:
            json["sensor_ep_7_water_pressure_m"]?.toDouble(),
        sensorEp7Elevation: json["sensor_ep_7_elevation"]?.toDouble(),
        sensorEp1Id: json["sensor_ep_1_id"]?.toDouble(),
        sensorEp1R1: json["sensor_ep_1_r1"]?.toDouble(),
        sensorEp1WaterPressureE:
            json["sensor_ep_1_water_pressure_e"]?.toDouble(),
        sensorEp1WaterPressureM:
            json["sensor_ep_1_water_pressure_m"]?.toDouble(),
        sensorEp1Elevation: json["sensor_ep_1_elevation"]?.toDouble(),
        sensorEp8Id: json["sensor_ep_8_id"]?.toDouble(),
        sensorEp8R1: json["sensor_ep_8_r1"]?.toDouble(),
        sensorEp8WaterPressureE:
            json["sensor_ep_8_water_pressure_e"]?.toDouble(),
        sensorEp8WaterPressureM:
            json["sensor_ep_8_water_pressure_m"]?.toDouble(),
        sensorEp8Elevation: json["sensor_ep_8_elevation"]?.toDouble(),
        sensorEp6Id: json["sensor_ep_6_id"]?.toDouble(),
        sensorEp6R1: json["sensor_ep_6_r1"]?.toDouble(),
        sensorEp6WaterPressureE:
            json["sensor_ep_6_water_pressure_e"]?.toDouble(),
        sensorEp6WaterPressureM:
            json["sensor_ep_6_water_pressure_m"]?.toDouble(),
        sensorEp6Elevation: json["sensor_ep_6_elevation"]?.toDouble(),
        sensorEp10Id: json["sensor_ep_10_id"]?.toDouble(),
        sensorEp10R1: json["sensor_ep_10_r1"]?.toDouble(),
        sensorEp10WaterPressureE:
            json["sensor_ep_10_water_pressure_e"]?.toDouble(),
        sensorEp10WaterPressureM:
            json["sensor_ep_10_water_pressure_m"]?.toDouble(),
        sensorEp10Elevation: json["sensor_ep_10_elevation"]?.toDouble(),
        sensorEp3Id: json["sensor_ep_3_id"]?.toDouble(),
        sensorEp3R1: json["sensor_ep_3_r1"]?.toDouble(),
        sensorEp3WaterPressureE:
            json["sensor_ep_3_water_pressure_e"]?.toDouble(),
        sensorEp3WaterPressureM:
            json["sensor_ep_3_water_pressure_m"]?.toDouble(),
        sensorEp3Elevation: json["sensor_ep_3_elevation"]?.toDouble(),
        sensorEp2Id: json["sensor_ep_2_id"]?.toDouble(),
        sensorEp2R1: json["sensor_ep_2_r1"]?.toDouble(),
        sensorEp2WaterPressureE:
            json["sensor_ep_2_water_pressure_e"]?.toDouble(),
        sensorEp2WaterPressureM:
            json["sensor_ep_2_water_pressure_m"]?.toDouble(),
        sensorEp2Elevation: json["sensor_ep_2_elevation"]?.toDouble(),
        sensorEp4Id: json["sensor_ep_4_id"]?.toDouble(),
        sensorEp4R1: json["sensor_ep_4_r1"]?.toDouble(),
        sensorEp4WaterPressureE:
            json["sensor_ep_4_water_pressure_e"]?.toDouble(),
        sensorEp4WaterPressureM:
            json["sensor_ep_4_water_pressure_m"]?.toDouble(),
        sensorEp4Elevation: json["sensor_ep_4_elevation"]?.toDouble(),
        sensorEp12Id: json["sensor_ep_12_id"]?.toDouble(),
        sensorEp12R1: json["sensor_ep_12_r1"]?.toDouble(),
        sensorEp12WaterPressureE:
            json["sensor_ep_12_water_pressure_e"]?.toDouble(),
        sensorEp12WaterPressureM:
            json["sensor_ep_12_water_pressure_m"]?.toDouble(),
        sensorEp12Elevation: json["sensor_ep_12_elevation"]?.toDouble(),
        pileElevation: json["pile_elevation"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "reading_date": readingDate.toIso8601String(),
        "sensor_ep_5_id": sensorEp5Id,
        "sensor_ep_5_r1": sensorEp5R1,
        "sensor_ep_5_water_pressure_e": sensorEp5WaterPressureE,
        "sensor_ep_5_water_pressure_m": sensorEp5WaterPressureM,
        "sensor_ep_5_elevation": sensorEp5Elevation,
        "sensor_ep_9_id": sensorEp9Id,
        "sensor_ep_9_r1": sensorEp9R1,
        "sensor_ep_9_water_pressure_e": sensorEp9WaterPressureE,
        "sensor_ep_9_water_pressure_m": sensorEp9WaterPressureM,
        "sensor_ep_9_elevation": sensorEp9Elevation,
        "sensor_ep_11_id": sensorEp11Id,
        "sensor_ep_11_r1": sensorEp11R1,
        "sensor_ep_11_water_pressure_e": sensorEp11WaterPressureE,
        "sensor_ep_11_water_pressure_m": sensorEp11WaterPressureM,
        "sensor_ep_11_elevation": sensorEp11Elevation,
        "sensor_ep_7_id": sensorEp7Id,
        "sensor_ep_7_r1": sensorEp7R1,
        "sensor_ep_7_water_pressure_e": sensorEp7WaterPressureE,
        "sensor_ep_7_water_pressure_m": sensorEp7WaterPressureM,
        "sensor_ep_7_elevation": sensorEp7Elevation,
        "sensor_ep_1_id": sensorEp1Id,
        "sensor_ep_1_r1": sensorEp1R1,
        "sensor_ep_1_water_pressure_e": sensorEp1WaterPressureE,
        "sensor_ep_1_water_pressure_m": sensorEp1WaterPressureM,
        "sensor_ep_1_elevation": sensorEp1Elevation,
        "sensor_ep_8_id": sensorEp8Id,
        "sensor_ep_8_r1": sensorEp8R1,
        "sensor_ep_8_water_pressure_e": sensorEp8WaterPressureE,
        "sensor_ep_8_water_pressure_m": sensorEp8WaterPressureM,
        "sensor_ep_8_elevation": sensorEp8Elevation,
        "sensor_ep_6_id": sensorEp6Id,
        "sensor_ep_6_r1": sensorEp6R1,
        "sensor_ep_6_water_pressure_e": sensorEp6WaterPressureE,
        "sensor_ep_6_water_pressure_m": sensorEp6WaterPressureM,
        "sensor_ep_6_elevation": sensorEp6Elevation,
        "sensor_ep_10_id": sensorEp10Id,
        "sensor_ep_10_r1": sensorEp10R1,
        "sensor_ep_10_water_pressure_e": sensorEp10WaterPressureE,
        "sensor_ep_10_water_pressure_m": sensorEp10WaterPressureM,
        "sensor_ep_10_elevation": sensorEp10Elevation,
        "sensor_ep_3_id": sensorEp3Id,
        "sensor_ep_3_r1": sensorEp3R1,
        "sensor_ep_3_water_pressure_e": sensorEp3WaterPressureE,
        "sensor_ep_3_water_pressure_m": sensorEp3WaterPressureM,
        "sensor_ep_3_elevation": sensorEp3Elevation,
        "sensor_ep_2_id": sensorEp2Id,
        "sensor_ep_2_r1": sensorEp2R1,
        "sensor_ep_2_water_pressure_e": sensorEp2WaterPressureE,
        "sensor_ep_2_water_pressure_m": sensorEp2WaterPressureM,
        "sensor_ep_2_elevation": sensorEp2Elevation,
        "sensor_ep_4_id": sensorEp4Id,
        "sensor_ep_4_r1": sensorEp4R1,
        "sensor_ep_4_water_pressure_e": sensorEp4WaterPressureE,
        "sensor_ep_4_water_pressure_m": sensorEp4WaterPressureM,
        "sensor_ep_4_elevation": sensorEp4Elevation,
        "sensor_ep_12_id": sensorEp12Id,
        "sensor_ep_12_r1": sensorEp12R1,
        "sensor_ep_12_water_pressure_e": sensorEp12WaterPressureE,
        "sensor_ep_12_water_pressure_m": sensorEp12WaterPressureM,
        "sensor_ep_12_elevation": sensorEp12Elevation,
        "pile_elevation": pileElevation,
      };
}

class RainFall {
  DateTime? readingDate;
  double? curahHujan;

  RainFall({
    this.readingDate,
    this.curahHujan,
  });
}

class Intake {
  DateTime? readingDate;
  double? waterLevel;

  Intake({
    this.readingDate,
    this.waterLevel,
  });
}
