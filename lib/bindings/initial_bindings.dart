import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/login/controllers/login_controller.dart';
import 'package:mobile_ameroro_app/apps/login/repository/login_repository.dart';
import 'package:mobile_ameroro_app/apps/splash/controllers/splash_controller.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/global_connectivity_observer.dart';
import 'package:mobile_ameroro_app/services/local/preference_utils.dart';
import 'package:mobile_ameroro_app/services/mqtt/mqtt_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() async {
    await Get.putAsync(() => ConnectivityService().initialize());
    await Get.putAsync(() async => await PreferenceUtils.init(),
        permanent: true);
    await Get.putAsync<MqttService>(
      () => MqttService().initialize(),
    );
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<LoginController>(
        () => LoginController(LoginRepository(ApiService())));
    Get.put(() => GlobalConnectivityObserver().observe());
  }
}
