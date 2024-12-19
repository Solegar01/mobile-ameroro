class IntakeModel {
  final List<WaterIntake> intake;
  final List<dynamic> rainfall;

  IntakeModel({
    required this.intake,
    required this.rainfall,
  });

  // Factory constructor to create an instance from JSON
  factory IntakeModel.fromJson(Map<String, dynamic> json) {
    return IntakeModel(
      intake: (json['intake'] as List)
          .map((item) => WaterIntake.fromJson(item))
          .toList(),
      rainfall:
          json['rainfall'], // assuming rainfall is just an empty array for now
    );
  }

  // Method to convert instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'intake': intake.map((item) => item.toJson()).toList(),
      'rainfall': rainfall,
    };
  }
}

class WaterIntake {
  int id;
  String deviceId;
  DateTime readingAt;
  double? waterLevel;
  double? waterLevelIntake;
  double? storageVolume;
  double? floodArea;
  double? debit;
  double? hollowJetAperture1000;
  double? hollowJetAperture600;
  double? overflow;
  double? totalRunoffPlusHollowJet;
  double? battery;
  DateTime createdAt;

  // Constructor
  WaterIntake({
    required this.id,
    required this.deviceId,
    required this.readingAt,
    this.waterLevel,
    this.waterLevelIntake,
    this.storageVolume,
    this.floodArea,
    this.debit,
    this.hollowJetAperture1000,
    this.hollowJetAperture600,
    this.overflow,
    this.totalRunoffPlusHollowJet,
    this.battery,
    required this.createdAt,
  });

  // Factory method to create an object from JSON
  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    return WaterIntake(
      id: json['id'],
      deviceId: json['device_id'],
      readingAt: DateTime.parse(json['reading_at']),
      waterLevel: json['water_level'],
      waterLevelIntake: json['water_level_intake'],
      storageVolume: json['storage_volume'],
      floodArea: json['flood_area'],
      debit: json['debit'],
      hollowJetAperture1000: json['hollow_jet_aperture_1000'],
      hollowJetAperture600: json['hollow_jet_aperture_600'],
      overflow: json['overflow'],
      totalRunoffPlusHollowJet: json['total_runoff_plus_hollow_jet'],
      battery: json['battery'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'reading_at': readingAt.toIso8601String(),
      'water_level': waterLevel,
      'water_level_intake': waterLevelIntake,
      'storage_volume': storageVolume,
      'flood_area': floodArea,
      'debit': debit,
      'hollow_jet_aperture_1000': hollowJetAperture1000,
      'hollow_jet_aperture_600': hollowJetAperture600,
      'overflow': overflow,
      'total_runoff_plus_hollow_jet': totalRunoffPlusHollowJet,
      'battery': battery,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
