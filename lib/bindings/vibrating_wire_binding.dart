import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/vibrating_wire/controllers/vibrating_wire_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/vibrating_wire/repository/vibrating_wire_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class VibratingWireBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VibratingWireController>(
        () => VibratingWireController(VibratingWireRepository(ApiService())));
  }
}
