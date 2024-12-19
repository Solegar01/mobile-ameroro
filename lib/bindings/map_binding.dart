import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/map/controllers/map_controller.dart';
import 'package:mobile_ameroro_app/apps/map/repository/map_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(
        () => MapController(MapRepository(ApiService())));
  }
}
