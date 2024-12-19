class GraphicModel {
  List<Intake>? listIntake;
  List<RainFall>? listRainFall;
  List<Vnotch>? listVnotch;
  List<Awlr>? listAwlr;

  GraphicModel({
    this.listIntake,
    this.listRainFall,
    this.listVnotch,
    this.listAwlr,
  });
}

class Intake {
  final DateTime readingAt;
  final double waterLevel;
  final double debit;
  final String status;

  // Constructor
  Intake({
    required this.readingAt,
    required this.waterLevel,
    required this.debit,
    required this.status,
  });

  // Factory method to create an object from JSON
  factory Intake.fromJson(Map<String, dynamic> json) {
    return Intake(
      readingAt: DateTime.parse(json['reading_at']),
      waterLevel: json['water_level'] ?? 0,
      debit: json['debit'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'reading_at': readingAt.toIso8601String(),
      'water_level': waterLevel,
      'debit': debit,
      'status': status,
    };
  }
}

class Vnotch {
  final DateTime readingAt;
  final double waterLevel;
  final double debit;

  // Constructor
  Vnotch({
    required this.readingAt,
    required this.waterLevel,
    required this.debit,
  });

  // Factory method to create an object from JSON
  factory Vnotch.fromJson(Map<String, dynamic> json) {
    return Vnotch(
      readingAt: DateTime.parse(json['reading_at']),
      waterLevel: json['water_level'] ?? 0,
      debit: json['debit'] ?? 0,
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'reading_at': readingAt.toIso8601String(),
      'water_level': waterLevel,
      'debit': debit,
    };
  }
}

class RainFall {
  DateTime? readingAt;
  double? rainFall;

  // Constructor
  RainFall({
    this.readingAt,
    this.rainFall,
  });
}

class Awlr {
  final String name;
  final String deviceId;
  final double waterLevel;
  final double debit;
  final DateTime readingAt;
  final String warningStatus;

  // Constructor
  Awlr({
    required this.name,
    required this.deviceId,
    required this.waterLevel,
    required this.debit,
    required this.readingAt,
    required this.warningStatus,
  });

  // Factory method to create an object from JSON
  factory Awlr.fromJson(Map<String, dynamic> json) {
    return Awlr(
      name: json['name'],
      deviceId: json['device_id'],
      waterLevel: json['water_level'],
      debit: json['debit'] ?? 0,
      readingAt: DateTime.parse(json['reading_at']),
      warningStatus: json['warning_status'],
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'device_id': deviceId,
      'water_level': waterLevel,
      'debit': debit,
      'reading_at': readingAt.toIso8601String(),
      'warning_status': warningStatus,
    };
  }
}
