import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/settlement_meter/controllers/settlement_meter_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/settlement_meter/repository/settlement_meter_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class SettlementMeterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettlementMeterController>(() =>
        SettlementMeterController(SettlementMeterRepository(ApiService())));
  }
}
