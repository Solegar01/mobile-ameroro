import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/repository/awlr_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';

class AwlrController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  final AwlrRepository repository;
  AwlrController(this.repository);
  late AnimationController animationController;
  late Animation<double> animation;

  RxList<AwlrModel> listAwlr = RxList.empty(growable: true);

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

  formInit() async {
    await getData();
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    listAwlr.clear();
    try {
      var listResponse = await repository.getData();
      if (listResponse.isNotEmpty) {
        listResponse.sort((a, b) => b.readingAt!.compareTo(a.readingAt!));
        for (var item in listResponse) {
          listAwlr.add(item);
        }
      }
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      msgToast(e.toString());
    }
  }

  Future<void> toDetail(AwlrModel model) async {
    await repository.cacheData(model);
    Get.toNamed(AppRoutes.AWLR_DETAIL);
  }
}
