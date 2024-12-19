import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/controllers/klimatologi_aws_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/repository/klimatologi_aws_repository.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class KlimatologiAwsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KlimatologiAwsController>(
        () => KlimatologiAwsController(KlimatologiAwsRepository(ApiService())));
  }
}
