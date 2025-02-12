class CctvModel {
  String id;
  String name;
  String url;
  double? latitude;
  double? longitude;
  String? note;
  DateTime createdAt;
  DateTime updatedAt;

  CctvModel({
    required this.id,
    required this.name,
    required this.url,
    this.latitude,
    this.longitude,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  // static function to create an empty user model.
  static CctvModel empty() => CctvModel(
      id: '',
      name: '',
      url: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());

  // Convert model to JSON structure
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'latitude': latitude,
      'longitude': longitude,
      'note': note,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory CctvModel.fromJson(Map<String, dynamic> json) => CctvModel(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        note: json['note'],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  // Factory method to create a CctvModel
  factory CctvModel.fromMap(Map<String, dynamic> map) {
    return CctvModel(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      note: map['note'],
      createdAt: DateTime.parse(map["created_at"]),
      updatedAt: DateTime.parse(map["updated_at"]),
    );
  }
}
