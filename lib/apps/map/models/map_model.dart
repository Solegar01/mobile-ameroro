class MapModel {
  String? deviceId;
  String? instrumentType;
  String? name;
  double? latitude;
  double? longitude;
  String? url;
  String? note;
  String? lastData;
  String? unitDisplay;
  String? warningStatus;
  String? deviceStatus;
  DateTime? lastReading;

  MapModel({
    this.deviceId,
    this.instrumentType,
    this.name,
    this.latitude,
    this.longitude,
    this.url,
    this.note,
    this.lastData,
    this.unitDisplay,
    this.warningStatus,
    this.deviceStatus,
    this.lastReading,
  });

  // Factory method to create an instance of MapModel from JSON
  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      deviceId: json["device_id"],
      instrumentType: json["instrument_type"],
      name: json["name"],
      latitude: json["latitude"]?.toDouble(),
      longitude: json["longitude"]?.toDouble(),
      url: json["url"],
      note: json["note"],
      lastData: json["last_data"],
      unitDisplay: json["unit_display"],
      warningStatus: json["warning_status"],
      deviceStatus: json["device_status"],
      lastReading: json["last_reading"] == null
          ? null
          : DateTime.parse(json["last_reading"]),
    );
  }

  // Method to convert an instance of MapModel to JSON
  Map<String, dynamic> toJson() {
    return {
      "device_id": deviceId,
      "instrument_type": instrumentType,
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
      "url": url,
      "note": note,
      "last_data": lastData,
      "unit_display": unitDisplay,
      "warning_status": warningStatus,
      "device_status": deviceStatus,
      "last_reading": lastReading?.toIso8601String(),
    };
  }
}
