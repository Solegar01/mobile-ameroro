import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/controllers/awlr_detail_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/repository/awlr_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class AwlrDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AwlrDetailController>(
        () => AwlrDetailController(AwlrRepository(ApiService())));
  }
}
