import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/controllers/open_standpipe_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/repository/open_standpipe_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class OpenStandpipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpenStandpipeController>(
        () => OpenStandpipeController(OpenStandpipeRepository(ApiService())));
  }
}
