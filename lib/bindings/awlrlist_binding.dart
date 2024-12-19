import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/controllers/awlrlist_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/repository/awlr_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class AwlrListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AwlrListController>(
        () => AwlrListController(AwlrRepository(ApiService())));
  }
}
