import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/ews/controllers/ews_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/ews/repository/ews_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class EwsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EwsController>(
        () => EwsController(EwsRepository(ApiService())));
  }
}
