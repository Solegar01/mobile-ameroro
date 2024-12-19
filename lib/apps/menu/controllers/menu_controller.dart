import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/login/repository/login_repository.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/local/session_service.dart';

class MenusController extends GetxController with StateMixin {
  final SessionService session = SessionService();
  final LoginRepository _loginRepository = LoginRepository(ApiService());

  RxString name = "".obs;
  RxString username = "".obs;

  @override
  void onInit() {
    _loadSession();
    super.onInit();
  }

  _loadSession() async {
    name.value = await session.getSession('name') ?? "";
    username.value = await session.getSession('username') ?? "";
  }

  Future<void> logout() async {
    await _loginRepository.removeAllSession();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
