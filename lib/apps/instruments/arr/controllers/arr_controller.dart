import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/repository/arr_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';

class ArrController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  final ArrRepository repository;
  ArrController(this.repository);

  List<ArrModel> listArr = List.empty(growable: true);

  @override
  void onInit() async {
    await formInit();
    super.onInit();
  }

  formInit() async {
    await getData();
    update();
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    listArr.clear();
    try {
      await repository.getList().then((value) {
        listArr = value;
      });
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      msgToast(e.toString());
    }
  }
}
