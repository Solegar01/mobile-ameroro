import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';

class ConnectivityService extends GetxService {
  // Reactive variable to track connectivity status
  final RxBool isConnected = false.obs;

  @override
  void onInit() async {
    await initialize();
    super.onInit();
  }

  Future<ConnectivityService> initialize() async {
    Connectivity().checkConnectivity().then((results) {
      isConnected.value = !results.contains(ConnectivityResult.none);
    });
    _monitorConnectivity();
    return this;
  }

  void _monitorConnectivity() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Update connectivity status
      isConnected.value = !results.contains(ConnectivityResult.none);
    });
  }

  Future<bool> checkInternetConnection() async {
    if (!isConnected.value) {
      // Show an error message
      msgToast('No Internet, \nPlease check your internet connection.');
      // Get.snackbar(
      //   "No Internet",
      //   "Please check your internet connection.",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      // );
    }
    return isConnected.value;
  }
}
