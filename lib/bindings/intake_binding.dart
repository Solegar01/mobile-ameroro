import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/controllers/intake_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/repository/intake_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class IntakeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntakeController>(
        () => IntakeController(IntakeRepository(ApiService())));
  }
}
