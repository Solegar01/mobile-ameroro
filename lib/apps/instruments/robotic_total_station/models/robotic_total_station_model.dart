class RoboticTotalStationModel {
  DateTime? readingAt;
  String? point;
  double? baseE;
  double? baseN;
  double? baseRl;
  double? easting;
  double? northing;
  double? reducedLevel;
  double? de;
  double? dn;
  double? drl;
  double? dx;
  double? dy;
  double? dz;

  RoboticTotalStationModel({
    this.readingAt,
    this.point,
    this.baseE,
    this.baseN,
    this.baseRl,
    this.easting,
    this.northing,
    this.reducedLevel,
    this.de,
    this.dn,
    this.drl,
    this.dx,
    this.dy,
    this.dz,
  });

  factory RoboticTotalStationModel.fromJson(Map<String, dynamic> json) =>
      RoboticTotalStationModel(
        readingAt: json["reading_at"] == null
            ? null
            : DateTime.parse(json["reading_at"]),
        point: json["point"],
        baseE: json["base_e"]?.toDouble(),
        baseN: json["base_n"]?.toDouble(),
        baseRl: json["base_rl"]?.toDouble(),
        easting: json["easting"]?.toDouble(),
        northing: json["northing"]?.toDouble(),
        reducedLevel: json["reduced_level"]?.toDouble(),
        de: json["de"]?.toDouble(),
        dn: json["dn"]?.toDouble(),
        drl: json["drl"]?.toDouble(),
        dx: json["dx"]?.toDouble(),
        dy: json["dy"]?.toDouble(),
        dz: json["dz"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "reading_at": readingAt?.toIso8601String(),
        "point": point,
        "base_e": baseE,
        "base_n": baseN,
        "base_rl": baseRl,
        "easting": easting,
        "northing": northing,
        "reduced_level": reducedLevel,
        "de": de,
        "dn": dn,
        "drl": drl,
        "dx": dx,
        "dy": dy,
        "dz": dz,
      };
}
