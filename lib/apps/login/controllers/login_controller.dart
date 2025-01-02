import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/app.dart';
import 'package:mobile_ameroro_app/apps/login/models/login_request_model.dart';
import 'package:mobile_ameroro_app/apps/login/models/login_response_model.dart';
import 'package:mobile_ameroro_app/apps/login/repository/login_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class LoginController extends GetxController
    with StateMixin<LoginResponseModel> {
  final LoginRepository repository;
  LoginController(this.repository);

  // variables
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool rememberMe = false.obs;
  RxBool isLoginButtonEnabled = false.obs;
  RxBool obscurePassword = true.obs;

  final connectivityService = Get.find<ConnectivityService>();

  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  void isButtonActive(
      TextEditingController username, TextEditingController password) {
    if (username.text != '' && password.text != '') {
      isLoginButtonEnabled.value = true;
    } else {
      isLoginButtonEnabled.value = false;
    }

    update();
  }

  Future<void> signIn(BuildContext context, LoginRequestModel model) async {
    change(null, status: RxStatus.loading());
    try {
      if (!connectivityService.isConnected.value) {
        msgToast('No Internet Connection');
        change(null, status: RxStatus.success());
      } else {
        final login = await repository.postData(model);
        GFToast.showToast(
            // ignore: use_build_context_synchronously
            'Login success',
            // ignore: use_build_context_synchronously
            context);
        change(login, status: RxStatus.success());
        await repository.saveAllSession(login, rememberMe.value);
        await repository.cacheLogin(login);
        Get.offAll(MyApp());
      }
    } catch (e) {
      log(e.toString());
      GFToast.showToast(
          // ignore: use_build_context_synchronously
          e.toString(),
          // ignore: use_build_context_synchronously
          context);
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      if (!connectivityService.isConnected.value) {
        msgToast('No Internet Connection');
      } else {
        await repository.removeAllSession();
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      rethrow;
    }
  }
}
