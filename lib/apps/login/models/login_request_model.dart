class LoginRequestModel {
  String username;
  String password;

  LoginRequestModel({required this.username, required this.password});

  // Factory method untuk membuat instance dari JSON
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      username: json['username'],
      password: json['password'],
    );
  }

  // Method untuk mengonversi instance ke JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
