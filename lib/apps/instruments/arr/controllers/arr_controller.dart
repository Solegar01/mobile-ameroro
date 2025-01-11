import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/repository/arr_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';

class ArrController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  final ArrRepository repository;
  ArrController(this.repository);

  late AnimationController animationController;
  late Animation<double> animation;
  List<ArrModel> listArr = List.empty(growable: true);

  @override
  void onInit() async {
    // Initialize the AnimationController
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat animation back and forth

    // Define the animation as a tween between 0.0 (invisible) and 1.0 (fully visible)
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    await formInit();
    super.onInit();
  }

  formInit() async {
    await getData();
    update();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.dispose();
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

  Future<void> toDetail(ArrModel model) async {
    await repository.cacheData(model);
    Get.toNamed(AppRoutes.ARR_DETAIL);
  }
}
