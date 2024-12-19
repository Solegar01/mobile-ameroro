import 'package:mobile_ameroro_app/services/api/metadata_model.dart';

class ApiResponse<T> {
  final MetaData metaData;
  final T? response;

  ApiResponse({required this.metaData, this.response});

  factory ApiResponse.fromJson(dynamic json, T Function(dynamic)? create) {
    return ApiResponse(
      metaData: MetaData.fromJson(json['metaData']),
      response: json['response'] != null && create != null
          ? create(json['response'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metaData': metaData.toJson(),
      'response': response != null ? (response as dynamic).toJson() : null,
    };
  }

  // Konstruktor khusus untuk timeout
  factory ApiResponse.timeout() {
    return ApiResponse(
      metaData: MetaData(
        code: 408,
        message: "Timeout. Silahkan coba lagi",
      ),
      response: null,
    );
  }

  // Konstruktor khusus untuk error umum
  factory ApiResponse.error(String message) {
    return ApiResponse(
      metaData: MetaData(
        code: 500,
        message: message,
      ),
      response: null,
    );
  }
}
