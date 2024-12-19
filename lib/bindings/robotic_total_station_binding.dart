import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/robotic_total_station/controllers/robotic_total_station_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/robotic_total_station/repository/robotic_total_station_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class RoboticTotalStationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoboticTotalStationController>(() =>
        RoboticTotalStationController(
            RoboticTotalStationRepository(ApiService())));
  }
}
