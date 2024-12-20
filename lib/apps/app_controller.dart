import 'dart:developer';

import 'package:get/get.dart';

class AppController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxString x = "".obs;

  void updateScreen() {
    currentIndex.value = 2;
    log(currentIndex.value.toString());
    update();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
