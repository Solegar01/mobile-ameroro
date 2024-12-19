import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/settlement_meter/repository/settlement_meter_repository.dart';

class SettlementMeterController extends GetxController with StateMixin {
  final SettlementMeterRepository repository;
  SettlementMeterController(this.repository);

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }

  getData() async {
    change(null, status: RxStatus.loading());
    try {
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }
}
