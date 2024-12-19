import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/cctv/controllers/cctv_controller.dart';
import 'package:mobile_ameroro_app/apps/cctv/repository/cctv_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class CctvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CctvController>(
        () => CctvController(CctvRepository(ApiService())));
  }
}
