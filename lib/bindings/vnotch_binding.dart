import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/vnotch/controllers/vnotch_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/vnotch/repository/vnotch_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class VNotchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VNotchController>(
        () => VNotchController(VNotchRepository(ApiService())));
  }
}
