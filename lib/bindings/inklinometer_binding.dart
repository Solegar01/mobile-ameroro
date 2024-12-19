import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/inklinometer/controllers/inklinometer_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/inklinometer/repository/inklinometer_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class InklinometerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InklinometerController>(
        () => InklinometerController(InklinometerRepository(ApiService())));
  }
}
