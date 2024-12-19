import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/login/controllers/login_controller.dart';
import 'package:mobile_ameroro_app/apps/login/repository/login_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
        () => LoginController(LoginRepository(ApiService())));
  }
}
