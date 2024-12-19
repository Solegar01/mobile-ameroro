class LoginResponseModel {
  final String id;
  final String name;
  final String username;
  final String? email;

  LoginResponseModel({
    required this.id,
    required this.name,
    required this.username,
    this.email,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
    };
  }
}
