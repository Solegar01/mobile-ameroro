import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/observation_well/controllers/observation_well_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/observation_well/repository/observation_well_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class ObservationWellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ObservationWellController>(() =>
        ObservationWellController(ObservationWellRepository(ApiService())));
  }
}
