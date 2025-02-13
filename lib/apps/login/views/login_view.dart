import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/login/controllers/login_controller.dart';
import 'package:mobile_ameroro_app/apps/login/models/login_request_model.dart';
import 'package:mobile_ameroro_app/apps/login/repository/login_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/loader_animation.dart';
import 'package:mobile_ameroro_app/apps/widgets/text_input_custom.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class LoginView extends StatelessWidget {
  final LoginController controller =
      Get.put(LoginController(LoginRepository(ApiService())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.bgLogin,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset(
              'assets/images/logo-pu.png',
              scale: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Aplikasi Monitoring',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: GFColors.WHITE,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BENDUNGAN ',
                  style: TextStyle(
                    fontSize: AppConfig.fontSizeXL,
                    fontWeight: FontWeight.bold,
                    color: GFColors.WHITE,
                  ),
                ),
                Text(
                  'AMERORO',
                  style: TextStyle(
                    fontSize: AppConfig.fontSizeXL,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.focusTextField,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextInputCustom(
              controller: controller.username,
              label: 'Username',
              icon: Icons.person,
              onChanged: (value) {
                controller.username.text = value;
                controller.isButtonActive(
                    controller.username, controller.password);
              },
            ),
            SizedBox(height: AppConfig.verticalSpace),
            Obx(() => TextInputCustom(
                controller: controller.password,
                label: 'Password',
                icon: Icons.lock,
                suffixIcon: controller.obscurePassword.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onTapSuffixIcon: () {
                  controller.obscurePassword.value =
                      !controller.obscurePassword.value;
                },
                enableSuffixIcon: true,
                obscureText: controller.obscurePassword.value,
                onChanged: (value) {
                  controller.password.text = value;
                  controller.isButtonActive(
                      controller.username, controller.password);
                })),
            SizedBox(height: AppConfig.verticalSpace),
            Obx(
              () => GestureDetector(
                onTap: () {
                  controller.rememberMe.toggle();
                  controller.isButtonActive(
                      controller.username, controller.password);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      value: controller.rememberMe.value,
                      activeColor: AppConfig.focusTextField,
                      checkColor: AppConfig.primaryColor,
                      side: BorderSide(color: AppConfig.focusTextField),
                      onChanged: (value) {
                        controller.rememberMe.toggle();
                        controller.isButtonActive(
                            controller.username, controller.password);
                      },
                    ),
                    Text(
                      'Ingatkan Saya',
                      style: TextStyle(
                        fontSize: AppConfig.fontMedion,
                        color: controller.rememberMe.value
                            ? AppConfig.focusTextField
                            : GFColors.WHITE,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppConfig.verticalSpace),
            GetBuilder<LoginController>(
              builder: (controller) {
                return GFButton(
                  icon: controller.status.isLoading
                      ? const LoaderAnimation()
                      : null,
                  size: 45,
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.bgLogin),
                  onPressed: (controller.isLoginButtonEnabled.value ||
                          controller.status.isLoading)
                      ? () async {
                          LoginRequestModel model = LoginRequestModel(
                            username: controller.username.text,
                            password: controller.password.text,
                            rememberme: controller.rememberMe.value,
                          );
                          await controller.signIn(context, model);
                        }
                      : null,
                  text: controller.status.isLoading ? '' : 'Login',
                  shape: GFButtonShape.standard,
                  color: AppConfig.focusTextField,
                  fullWidthButton: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
