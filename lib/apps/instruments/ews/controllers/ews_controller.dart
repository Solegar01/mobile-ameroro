import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/ews/repository/ews_repository.dart';

class EwsController extends GetxController with StateMixin {
  final EwsRepository repository;
  EwsController(this.repository);

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }

  getData() async {
    change(null, status: RxStatus.loading());
    try {
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }
}
