class OpenStandpipeModel {
  List<OpenStandpipe>? listOpenStandpipe;
  List<Intake>? listIntake;

  OpenStandpipeModel({
    this.listOpenStandpipe,
    this.listIntake,
  });
}

class OpenStandpipe {
  DateTime? readingDate;
  double? sensorOsp11WaterLevel;
  double? sensorOsp11ElvWaterLevel;
  double? sensorOsp11TekananPori;
  double? sensorOsp62WaterLevel;
  double? sensorOsp62ElvWaterLevel;
  double? sensorOsp62TekananPori;
  double? sensorOsp32WaterLevel;
  double? sensorOsp32ElvWaterLevel;
  double? sensorOsp32TekananPori;
  double? sensorOsp31WaterLevel;
  double? sensorOsp31ElvWaterLevel;
  double? sensorOsp31TekananPori;
  double? sensorOsp61WaterLevel;
  double? sensorOsp61ElvWaterLevel;
  double? sensorOsp61TekananPori;
  double? sensorOsp22WaterLevel;
  double? sensorOsp22ElvWaterLevel;
  double? sensorOsp22TekananPori;
  double? sensorOsp41WaterLevel;
  double? sensorOsp41ElvWaterLevel;
  double? sensorOsp41TekananPori;
  double? sensorOsp42WaterLevel;
  double? sensorOsp42ElvWaterLevel;
  double? sensorOsp42TekananPori;
  double? sensorOsp21WaterLevel;
  double? sensorOsp21ElvWaterLevel;
  double? sensorOsp21TekananPori;
  double? sensorOsp12WaterLevel;
  double? sensorOsp12ElvWaterLevel;
  double? sensorOsp12TekananPori;
  double? sensorOsp52WaterLevel;
  double? sensorOsp52ElvWaterLevel;
  double? sensorOsp52TekananPori;
  double? sensorOsp51WaterLevel;
  double? sensorOsp51ElvWaterLevel;
  double? sensorOsp51TekananPori;

  OpenStandpipe({
    this.readingDate,
    this.sensorOsp11WaterLevel,
    this.sensorOsp11ElvWaterLevel,
    this.sensorOsp11TekananPori,
    this.sensorOsp62WaterLevel,
    this.sensorOsp62ElvWaterLevel,
    this.sensorOsp62TekananPori,
    this.sensorOsp32WaterLevel,
    this.sensorOsp32ElvWaterLevel,
    this.sensorOsp32TekananPori,
    this.sensorOsp31WaterLevel,
    this.sensorOsp31ElvWaterLevel,
    this.sensorOsp31TekananPori,
    this.sensorOsp61WaterLevel,
    this.sensorOsp61ElvWaterLevel,
    this.sensorOsp61TekananPori,
    this.sensorOsp22WaterLevel,
    this.sensorOsp22ElvWaterLevel,
    this.sensorOsp22TekananPori,
    this.sensorOsp41WaterLevel,
    this.sensorOsp41ElvWaterLevel,
    this.sensorOsp41TekananPori,
    this.sensorOsp42WaterLevel,
    this.sensorOsp42ElvWaterLevel,
    this.sensorOsp42TekananPori,
    this.sensorOsp21WaterLevel,
    this.sensorOsp21ElvWaterLevel,
    this.sensorOsp21TekananPori,
    this.sensorOsp12WaterLevel,
    this.sensorOsp12ElvWaterLevel,
    this.sensorOsp12TekananPori,
    this.sensorOsp52WaterLevel,
    this.sensorOsp52ElvWaterLevel,
    this.sensorOsp52TekananPori,
    this.sensorOsp51WaterLevel,
    this.sensorOsp51ElvWaterLevel,
    this.sensorOsp51TekananPori,
  });

  factory OpenStandpipe.fromJson(Map<String, dynamic> json) => OpenStandpipe(
        readingDate: json["reading_date"] == null
            ? null
            : DateTime.parse(json["reading_date"]),
        sensorOsp11WaterLevel: json["sensor_osp_1_1_water_level"]?.toDouble(),
        sensorOsp11ElvWaterLevel:
            json["sensor_osp_1_1_elv_water_level"]?.toDouble(),
        sensorOsp11TekananPori: json["sensor_osp_1_1_tekanan_pori"]?.toDouble(),
        sensorOsp62WaterLevel: json["sensor_osp_6_2_water_level"]?.toDouble(),
        sensorOsp62ElvWaterLevel:
            json["sensor_osp_6_2_elv_water_level"]?.toDouble(),
        sensorOsp62TekananPori: json["sensor_osp_6_2_tekanan_pori"]?.toDouble(),
        sensorOsp32WaterLevel: json["sensor_osp_3_2_water_level"]?.toDouble(),
        sensorOsp32ElvWaterLevel:
            json["sensor_osp_3_2_elv_water_level"]?.toDouble(),
        sensorOsp32TekananPori: json["sensor_osp_3_2_tekanan_pori"]?.toDouble(),
        sensorOsp31WaterLevel: json["sensor_osp_3_1_water_level"]?.toDouble(),
        sensorOsp31ElvWaterLevel:
            json["sensor_osp_3_1_elv_water_level"]?.toDouble(),
        sensorOsp31TekananPori: json["sensor_osp_3_1_tekanan_pori"]?.toDouble(),
        sensorOsp61WaterLevel: json["sensor_osp_6_1_water_level"]?.toDouble(),
        sensorOsp61ElvWaterLevel:
            json["sensor_osp_6_1_elv_water_level"]?.toDouble(),
        sensorOsp61TekananPori: json["sensor_osp_6_1_tekanan_pori"]?.toDouble(),
        sensorOsp22WaterLevel: json["sensor_osp_2_2_water_level"]?.toDouble(),
        sensorOsp22ElvWaterLevel:
            json["sensor_osp_2_2_elv_water_level"]?.toDouble(),
        sensorOsp22TekananPori: json["sensor_osp_2_2_tekanan_pori"]?.toDouble(),
        sensorOsp41WaterLevel: json["sensor_osp_4_1_water_level"]?.toDouble(),
        sensorOsp41ElvWaterLevel:
            json["sensor_osp_4_1_elv_water_level"]?.toDouble(),
        sensorOsp41TekananPori: json["sensor_osp_4_1_tekanan_pori"]?.toDouble(),
        sensorOsp42WaterLevel: json["sensor_osp_4_2_water_level"]?.toDouble(),
        sensorOsp42ElvWaterLevel:
            json["sensor_osp_4_2_elv_water_level"]?.toDouble(),
        sensorOsp42TekananPori: json["sensor_osp_4_2_tekanan_pori"]?.toDouble(),
        sensorOsp21WaterLevel: json["sensor_osp_2_1_water_level"]?.toDouble(),
        sensorOsp21ElvWaterLevel:
            json["sensor_osp_2_1_elv_water_level"]?.toDouble(),
        sensorOsp21TekananPori: json["sensor_osp_2_1_tekanan_pori"]?.toDouble(),
        sensorOsp12WaterLevel: json["sensor_osp_1_2_water_level"]?.toDouble(),
        sensorOsp12ElvWaterLevel:
            json["sensor_osp_1_2_elv_water_level"]?.toDouble(),
        sensorOsp12TekananPori: json["sensor_osp_1_2_tekanan_pori"]?.toDouble(),
        sensorOsp52WaterLevel: json["sensor_osp_5_2_water_level"]?.toDouble(),
        sensorOsp52ElvWaterLevel:
            json["sensor_osp_5_2_elv_water_level"]?.toDouble(),
        sensorOsp52TekananPori: json["sensor_osp_5_2_tekanan_pori"]?.toDouble(),
        sensorOsp51WaterLevel: json["sensor_osp_5_1_water_level"]?.toDouble(),
        sensorOsp51ElvWaterLevel:
            json["sensor_osp_5_1_elv_water_level"]?.toDouble(),
        sensorOsp51TekananPori: json["sensor_osp_5_1_tekanan_pori"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "reading_date": readingDate?.toIso8601String(),
        "sensor_osp_1_1_water_level": sensorOsp11WaterLevel,
        "sensor_osp_1_1_elv_water_level": sensorOsp11ElvWaterLevel,
        "sensor_osp_1_1_tekanan_pori": sensorOsp11TekananPori,
        "sensor_osp_6_2_water_level": sensorOsp62WaterLevel,
        "sensor_osp_6_2_elv_water_level": sensorOsp62ElvWaterLevel,
        "sensor_osp_6_2_tekanan_pori": sensorOsp62TekananPori,
        "sensor_osp_3_2_water_level": sensorOsp32WaterLevel,
        "sensor_osp_3_2_elv_water_level": sensorOsp32ElvWaterLevel,
        "sensor_osp_3_2_tekanan_pori": sensorOsp32TekananPori,
        "sensor_osp_3_1_water_level": sensorOsp31WaterLevel,
        "sensor_osp_3_1_elv_water_level": sensorOsp31ElvWaterLevel,
        "sensor_osp_3_1_tekanan_pori": sensorOsp31TekananPori,
        "sensor_osp_6_1_water_level": sensorOsp61WaterLevel,
        "sensor_osp_6_1_elv_water_level": sensorOsp61ElvWaterLevel,
        "sensor_osp_6_1_tekanan_pori": sensorOsp61TekananPori,
        "sensor_osp_2_2_water_level": sensorOsp22WaterLevel,
        "sensor_osp_2_2_elv_water_level": sensorOsp22ElvWaterLevel,
        "sensor_osp_2_2_tekanan_pori": sensorOsp22TekananPori,
        "sensor_osp_4_1_water_level": sensorOsp41WaterLevel,
        "sensor_osp_4_1_elv_water_level": sensorOsp41ElvWaterLevel,
        "sensor_osp_4_1_tekanan_pori": sensorOsp41TekananPori,
        "sensor_osp_4_2_water_level": sensorOsp42WaterLevel,
        "sensor_osp_4_2_elv_water_level": sensorOsp42ElvWaterLevel,
        "sensor_osp_4_2_tekanan_pori": sensorOsp42TekananPori,
        "sensor_osp_2_1_water_level": sensorOsp21WaterLevel,
        "sensor_osp_2_1_elv_water_level": sensorOsp21ElvWaterLevel,
        "sensor_osp_2_1_tekanan_pori": sensorOsp21TekananPori,
        "sensor_osp_1_2_water_level": sensorOsp12WaterLevel,
        "sensor_osp_1_2_elv_water_level": sensorOsp12ElvWaterLevel,
        "sensor_osp_1_2_tekanan_pori": sensorOsp12TekananPori,
        "sensor_osp_5_2_water_level": sensorOsp52WaterLevel,
        "sensor_osp_5_2_elv_water_level": sensorOsp52ElvWaterLevel,
        "sensor_osp_5_2_tekanan_pori": sensorOsp52TekananPori,
        "sensor_osp_5_1_water_level": sensorOsp51WaterLevel,
        "sensor_osp_5_1_elv_water_level": sensorOsp51ElvWaterLevel,
        "sensor_osp_5_1_tekanan_pori": sensorOsp51TekananPori,
      };
}

class Intake {
  DateTime? readingDate;
  double? waterLevel;

  Intake({
    this.readingDate,
    this.waterLevel,
  });
}
