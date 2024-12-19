class ObservationWellModel {
  List<ObservationWell>? listObservationWell;
  List<Intake>? listIntake;
  List<RainFall>? listRainFall;

  ObservationWellModel({
    this.listObservationWell,
    this.listIntake,
    this.listRainFall,
  });
}

class ObservationWell {
  DateTime readingDate;
  double? sensorOw8Pengukuran;
  double? sensorOw8Elevasi;
  double? sensorOw8Keterangan;
  double? sensorOw1Pengukuran;
  double? sensorOw1Elevasi;
  double? sensorOw1Keterangan;
  double? sensorOw4Pengukuran;
  double? sensorOw4Elevasi;
  double? sensorOw4Keterangan;
  double? sensorOw2Pengukuran;
  double? sensorOw2Elevasi;
  double? sensorOw2Keterangan;
  double? sensorOw5Pengukuran;
  double? sensorOw5Elevasi;
  double? sensorOw5Keterangan;
  double? sensorOw7Pengukuran;
  double? sensorOw7Elevasi;
  double? sensorOw7Keterangan;
  double? sensorOw3Pengukuran;
  double? sensorOw3Elevasi;
  double? sensorOw3Keterangan;
  double? sensorOw6Pengukuran;
  double? sensorOw6Elevasi;
  double? sensorOw6Keterangan;

  ObservationWell({
    required this.readingDate,
    this.sensorOw8Pengukuran,
    this.sensorOw8Elevasi,
    this.sensorOw8Keterangan,
    this.sensorOw1Pengukuran,
    this.sensorOw1Elevasi,
    this.sensorOw1Keterangan,
    this.sensorOw4Pengukuran,
    this.sensorOw4Elevasi,
    this.sensorOw4Keterangan,
    this.sensorOw2Pengukuran,
    this.sensorOw2Elevasi,
    this.sensorOw2Keterangan,
    this.sensorOw5Pengukuran,
    this.sensorOw5Elevasi,
    this.sensorOw5Keterangan,
    this.sensorOw7Pengukuran,
    this.sensorOw7Elevasi,
    this.sensorOw7Keterangan,
    this.sensorOw3Pengukuran,
    this.sensorOw3Elevasi,
    this.sensorOw3Keterangan,
    this.sensorOw6Pengukuran,
    this.sensorOw6Elevasi,
    this.sensorOw6Keterangan,
  });

  factory ObservationWell.fromJson(Map<String, dynamic> json) =>
      ObservationWell(
        readingDate: DateTime.parse(json["reading_date"]),
        sensorOw8Pengukuran: (json["sensor_ow_8_pengukuran"])?.toDouble(),
        sensorOw8Elevasi: (json["sensor_ow_8_elevasi"])?.toDouble(),
        sensorOw8Keterangan: (json["sensor_ow_8_keterangan"])?.toDouble(),
        sensorOw1Pengukuran: (json["sensor_ow_1_pengukuran"])?.toDouble(),
        sensorOw1Elevasi: (json["sensor_ow_1_elevasi"])?.toDouble(),
        sensorOw1Keterangan: (json["sensor_ow_1_keterangan"])?.toDouble(),
        sensorOw4Pengukuran: (json["sensor_ow_4_pengukuran"])?.toDouble(),
        sensorOw4Elevasi: (json["sensor_ow_4_elevasi"])?.toDouble(),
        sensorOw4Keterangan: (json["sensor_ow_4_keterangan"])?.toDouble(),
        sensorOw2Pengukuran: (json["sensor_ow_2_pengukuran"])?.toDouble(),
        sensorOw2Elevasi: (json["sensor_ow_2_elevasi"])?.toDouble(),
        sensorOw2Keterangan: (json["sensor_ow_2_keterangan"])?.toDouble(),
        sensorOw5Pengukuran: (json["sensor_ow_5_pengukuran"])?.toDouble(),
        sensorOw5Elevasi: (json["sensor_ow_5_elevasi"])?.toDouble(),
        sensorOw5Keterangan: (json["sensor_ow_5_keterangan"])?.toDouble(),
        sensorOw7Pengukuran: (json["sensor_ow_7_pengukuran"])?.toDouble(),
        sensorOw7Elevasi: (json["sensor_ow_7_elevasi"])?.toDouble(),
        sensorOw7Keterangan: (json["sensor_ow_7_keterangan"])?.toDouble(),
        sensorOw3Pengukuran: (json["sensor_ow_3_pengukuran"])?.toDouble(),
        sensorOw3Elevasi: (json["sensor_ow_3_elevasi"])?.toDouble(),
        sensorOw3Keterangan: (json["sensor_ow_3_keterangan"])?.toDouble(),
        sensorOw6Pengukuran: (json["sensor_ow_6_pengukuran"])?.toDouble(),
        sensorOw6Elevasi: (json["sensor_ow_6_elevasi"])?.toDouble(),
        sensorOw6Keterangan: (json["sensor_ow_6_keterangan"])?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "reading_date": readingDate.toIso8601String(),
        "sensor_ow_8_pengukuran": sensorOw8Pengukuran,
        "sensor_ow_8_elevasi": sensorOw8Elevasi,
        "sensor_ow_8_keterangan": sensorOw8Keterangan,
        "sensor_ow_1_pengukuran": sensorOw1Pengukuran,
        "sensor_ow_1_elevasi": sensorOw1Elevasi,
        "sensor_ow_1_keterangan": sensorOw1Keterangan,
        "sensor_ow_4_pengukuran": sensorOw4Pengukuran,
        "sensor_ow_4_elevasi": sensorOw4Elevasi,
        "sensor_ow_4_keterangan": sensorOw4Keterangan,
        "sensor_ow_2_pengukuran": sensorOw2Pengukuran,
        "sensor_ow_2_elevasi": sensorOw2Elevasi,
        "sensor_ow_2_keterangan": sensorOw2Keterangan,
        "sensor_ow_5_pengukuran": sensorOw5Pengukuran,
        "sensor_ow_5_elevasi": sensorOw5Elevasi,
        "sensor_ow_5_keterangan": sensorOw5Keterangan,
        "sensor_ow_7_pengukuran": sensorOw7Pengukuran,
        "sensor_ow_7_elevasi": sensorOw7Elevasi,
        "sensor_ow_7_keterangan": sensorOw7Keterangan,
        "sensor_ow_3_pengukuran": sensorOw3Pengukuran,
        "sensor_ow_3_elevasi": sensorOw3Elevasi,
        "sensor_ow_3_keterangan": sensorOw3Keterangan,
        "sensor_ow_6_pengukuran": sensorOw6Pengukuran,
        "sensor_ow_6_elevasi": sensorOw6Elevasi,
        "sensor_ow_6_keterangan": sensorOw6Keterangan,
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
