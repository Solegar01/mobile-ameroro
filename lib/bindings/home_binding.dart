import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/home/controllers/home_controller.dart';
import 'package:mobile_ameroro_app/apps/home/repository/home_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class HomeBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut<HomeController>(
        () => HomeController(HomeRepository(ApiService())));
  }
}
