import 'dart:convert';
import 'package:mobile_ameroro_app/apps/login/models/login_request_model.dart';
import 'package:mobile_ameroro_app/apps/login/models/login_response_model.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/local/session_service.dart';

class LoginRepository {
  final ApiService apiService;
  final SessionService session = SessionService();
  LoginRepository(this.apiService);

  Future<LoginResponseModel> postData(LoginRequestModel model) async {
    final response = await apiService.post('login', model.toJson());
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return (LoginResponseModel.fromJson(jsonResponse['data']));
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  Future<void> saveAllSession(LoginResponseModel data) async {
    try {
      session.saveSession("id", data.id);
      session.saveSession("name", data.name);
      session.saveSession("username", data.username);
      session.saveSession("email", data.email ?? "");
      session.saveSession("isLogin", "true");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeAllSession() async {
    try {
      session.removeSession("id");
      session.removeSession("name");
      session.removeSession("username");
      session.removeSession("email");
      session.removeSession("isLogin");
    } catch (e) {
      rethrow;
    }
  }
}
