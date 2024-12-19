class MetaData {
  final int code;
  final String message;

  MetaData({required this.code, required this.message});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}
