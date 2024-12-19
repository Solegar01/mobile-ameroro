import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/app.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';
import 'package:mobile_ameroro_app/services/local/session_service.dart';

class SplashController extends GetxController with StateMixin<void> {
  final SessionService session = SessionService();

  @override
  void onInit() {
    super.onInit();
    navigateToLogin();
  }

  void navigateToLogin() async {
    change(null, status: RxStatus.loading());
    try {
      await Future.delayed(const Duration(seconds: 3));
      bool isLogin = await session.getSession("isLogin") == "true";
      if (isLogin) {
        Get.offAll(MyApp());
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }

      change(null, status: RxStatus.success());
    } catch (e) {
      change(null,
          status: RxStatus.error("Terjadi kesalahan saat navigasi ke login"));
    }
  }
}
