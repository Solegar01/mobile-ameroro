import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/controllers/awlr_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/repository/awlr_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class AwlrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AwlrController>(
        () => AwlrController(AwlrRepository(ApiService())));
  }
}
