import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  final String id;
  String? username;
  String? name;
  String? phone;
  String? email;
  String? password;

  ProfileModel({
    required this.id,
    this.username,
    this.name,
    this.phone,
    this.email,
    this.password,
  });

  static ProfileModel empty() => ProfileModel(
        id: '',
        username: '',
        name: '',
        phone: '',
        email: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      username: json['username'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
    );
  }
}
