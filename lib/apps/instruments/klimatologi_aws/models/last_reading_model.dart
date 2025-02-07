import 'dart:convert';

LastReadingModel lastReadingModelFromJson(String str) =>
    LastReadingModel.fromJson(json.decode(str));

String lastReadingModelToJson(LastReadingModel data) =>
    json.encode(data.toJson());

class LastReadingModel {
  int? id;
  String? deviceId;
  DateTime? readingAt;
  double? humidity;
  String? humidityStatus;
  double? pressure;
  double? solarRadiation;
  double? windDirection;
  String? windDirectionStatus;
  double? windSpeed;
  double? evaporation;
  double? rainfall;
  double? rainfallLastHour;
  String? rainfallHourIntensity;
  double? sunshineHour;
  double? batteryVoltage;
  double? temperature;
  int? batteryCapacity;

  LastReadingModel({
    this.id,
    this.deviceId,
    this.readingAt,
    this.humidity,
    this.humidityStatus,
    this.pressure,
    this.solarRadiation,
    this.windDirection,
    this.windDirectionStatus,
    this.windSpeed,
    this.evaporation,
    this.rainfall,
    this.rainfallLastHour,
    this.rainfallHourIntensity,
    this.sunshineHour,
    this.batteryVoltage,
    this.temperature,
    this.batteryCapacity,
  });

  factory LastReadingModel.fromJson(Map<String, dynamic> json) =>
      LastReadingModel(
        id: json["id"],
        deviceId: json["device_id"],
        readingAt: DateTime.parse(json["reading_at"]),
        humidity: json["humidity"]?.toDouble(),
        humidityStatus: json["humidity_status"],
        pressure: json["pressure"]?.toDouble(),
        solarRadiation: json["solar_radiation"]?.toDouble(),
        windDirection: json["wind_direction"],
        windDirectionStatus: json["wind_direction_status"],
        windSpeed: json["wind_speed"]?.toDouble(),
        evaporation: json["evaporation"]?.toDouble(),
        rainfall: json["rainfall"]?.toDouble(),
        rainfallLastHour: json["rainfall_last_hour"]?.toDouble(),
        rainfallHourIntensity: json["rainfall_hour_intensity"],
        sunshineHour: json["sunshine_hour"]?.toDouble(),
        batteryVoltage: json["battery_voltage"]?.toDouble(),
        temperature: json["temperature"]?.toDouble(),
        batteryCapacity: json["battery_capacity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_id": deviceId,
        "reading_at": readingAt?.toIso8601String(),
        "humidity": humidity,
        "humidity_status": humidityStatus,
        "pressure": pressure,
        "solar_radiation": solarRadiation,
        "wind_direction": windDirection,
        "wind_direction_status": windDirectionStatus,
        "wind_speed": windSpeed,
        "evaporation": evaporation,
        "rainfall": rainfall,
        "rainfall_last_hour": rainfallLastHour,
        "rainfall_hour_intensity": rainfallHourIntensity,
        "sunshine_hour": sunshineHour,
        "battery_voltage": batteryVoltage,
        "temperature": temperature,
        "battery_capacity": batteryCapacity,
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
