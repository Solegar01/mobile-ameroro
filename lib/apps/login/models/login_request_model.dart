class LoginRequestModel {
  String username;
  String password;
  bool rememberme;

  LoginRequestModel(
      {required this.username,
      required this.password,
      required this.rememberme});

  // Factory method untuk membuat instance dari JSON
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      username: json['username'],
      password: json['password'],
      rememberme: json['rememberme'],
    );
  }

  // Method untuk mengonversi instance ke JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'rememberme': rememberme,
    };
  }
}
