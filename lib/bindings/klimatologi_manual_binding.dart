import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/Repository/klimatologi_manual_repository.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/controllers/klimatologi_manual_controller.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class KlimatologiManualBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KlimatologiManualController>(() =>
        KlimatologiManualController(KlimatologiManualRepository(ApiService())));
  }
}
