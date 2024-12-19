import 'dart:convert';

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel data) => json.encode(data.toJson());

class WeatherModel {
  final Lokasi lokasi;
  final List<Datum> data;

  WeatherModel({
    required this.lokasi,
    required this.data,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        lokasi: Lokasi.fromJson(json["lokasi"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lokasi": lokasi.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final Lokasi lokasi;
  final List<List<Cuaca>> cuaca;

  Datum({
    required this.lokasi,
    required this.cuaca,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lokasi: Lokasi.fromJson(json["lokasi"]),
        cuaca: List<List<Cuaca>>.from(json["cuaca"]
            .map((x) => List<Cuaca>.from(x.map((x) => Cuaca.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "lokasi": lokasi.toJson(),
        "cuaca": List<dynamic>.from(
            cuaca.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class Cuaca {
  final DateTime datetime;
  final int t;
  final int tcc;
  final double tp;
  final int weather;
  final String weatherDesc;
  final String weatherDescEn;
  final int wdDeg;
  final String wd;
  final String wdTo;
  final double ws;
  final int hu;
  final int vs;
  final String vsText;
  final String timeIndex;
  final DateTime analysisDate;
  final String image;
  final DateTime utcDatetime;
  final DateTime localDatetime;

  Cuaca({
    required this.datetime,
    required this.t,
    required this.tcc,
    required this.tp,
    required this.weather,
    required this.weatherDesc,
    required this.weatherDescEn,
    required this.wdDeg,
    required this.wd,
    required this.wdTo,
    required this.ws,
    required this.hu,
    required this.vs,
    required this.vsText,
    required this.timeIndex,
    required this.analysisDate,
    required this.image,
    required this.utcDatetime,
    required this.localDatetime,
  });

  factory Cuaca.fromJson(Map<String, dynamic> json) => Cuaca(
        datetime: DateTime.parse(json["datetime"]),
        t: json["t"],
        tcc: json["tcc"],
        tp: json["tp"]?.toDouble(),
        weather: json["weather"],
        weatherDesc: json["weather_desc"]!,
        weatherDescEn: json["weather_desc_en"]!,
        wdDeg: json["wd_deg"],
        wd: json["wd"],
        wdTo: json["wd_to"],
        ws: json["ws"]?.toDouble(),
        hu: json["hu"],
        vs: json["vs"],
        vsText: json["vs_text"]!,
        timeIndex: json["time_index"],
        analysisDate: DateTime.parse(json["analysis_date"]),
        image: json["image"],
        utcDatetime: DateTime.parse(json["utc_datetime"]),
        localDatetime: DateTime.parse(json["local_datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "datetime": datetime.toIso8601String(),
        "t": t,
        "tcc": tcc,
        "tp": tp,
        "weather": weather,
        "weather_desc": weatherDesc,
        "weather_desc_en": weatherDescEn,
        "wd_deg": wdDeg,
        "wd": wd,
        "wd_to": wdTo,
        "ws": ws,
        "hu": hu,
        "vs": vs,
        "vs_text": vsText,
        "time_index": timeIndex,
        "analysis_date": analysisDate.toIso8601String(),
        "image": image,
        "utc_datetime": utcDatetime.toIso8601String(),
        "local_datetime": localDatetime.toIso8601String(),
      };
}

class Lokasi {
  final String adm1;
  final String adm2;
  final String adm3;
  final String adm4;
  final String provinsi;
  final String? kotkab;
  final String kecamatan;
  final String desa;
  final double lon;
  final double lat;
  final String timezone;
  final String? type;
  final String? kota;

  Lokasi({
    required this.adm1,
    required this.adm2,
    required this.adm3,
    required this.adm4,
    required this.provinsi,
    this.kotkab,
    required this.kecamatan,
    required this.desa,
    required this.lon,
    required this.lat,
    required this.timezone,
    this.type,
    this.kota,
  });

  factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
        adm1: json["adm1"],
        adm2: json["adm2"],
        adm3: json["adm3"],
        adm4: json["adm4"],
        provinsi: json["provinsi"],
        kotkab: json["kotkab"],
        kecamatan: json["kecamatan"],
        desa: json["desa"],
        lon: json["lon"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
        timezone: json["timezone"],
        type: json["type"],
        kota: json["kota"],
      );

  Map<String, dynamic> toJson() => {
        "adm1": adm1,
        "adm2": adm2,
        "adm3": adm3,
        "adm4": adm4,
        "provinsi": provinsi,
        "kotkab": kotkab,
        "kecamatan": kecamatan,
        "desa": desa,
        "lon": lon,
        "lat": lat,
        "timezone": timezone,
        "type": type,
        "kota": kota,
      };
}
