import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/profile/controllers/profile_controller.dart';
import 'package:mobile_ameroro_app/apps/profile/repository/profile_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
        () => ProfileController(ProfileRepository(ApiService())));
  }
}
