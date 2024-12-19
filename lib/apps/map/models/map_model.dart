class MapModel {
  String? id;
  String? deviceId;
  String? name;
  String? type;
  dynamic latitude;
  dynamic longitude;
  dynamic location;
  String? url;
  dynamic note;
  dynamic lastData;
  String? warningStatus;
  String? deviceStatus;
  DateTime? last_reading;


  MapModel({
    this.id,
    this.deviceId,
    this.name,
    this.type,
    this.latitude,
    this.longitude,
    this.location,
    this.url,
    this.note,
    this.lastData,
    this.warningStatus,
    this.deviceStatus,
    this.last_reading,
  });

  // Factory method to create an instance of MapModel from JSON
  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      id: json['id'],
      deviceId: json['device_id'],
      name: json['name'],
      type: json['type'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      location: json['location'],
      url: json['url'],
      note: json['note'],
      lastData: json['last_data'],
      warningStatus: json['warning_status'],
      deviceStatus: json['device_status'],
      last_reading: json["last_reading"] != null ? DateTime.parse(json["last_reading"]) : null,
    );
  }

  // Method to convert an instance of MapModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'url': url,
      'note': note,
      'last_data': lastData,
      'warning_status': warningStatus,
      'device_status': deviceStatus,
      'last_reading': last_reading,
    };
  }
}
