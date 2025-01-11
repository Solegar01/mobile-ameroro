import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/controllers/arr_detail_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/repository/arr_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class ArrDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArrDetailController>(
        () => ArrDetailController(ArrRepository(ApiService())));
  }
}
