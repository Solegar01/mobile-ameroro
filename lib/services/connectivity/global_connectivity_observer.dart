import 'package:get/get.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class GlobalConnectivityObserver {
  final ConnectivityService connectivityService = Get.find();

  void observe() {
    ever(connectivityService.isConnected, (bool isConnected) {
      if (isConnected) {
        Get.snackbar('Internet Connection', 'You are back online!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Internet Connection', 'You are offline!',
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }
}
