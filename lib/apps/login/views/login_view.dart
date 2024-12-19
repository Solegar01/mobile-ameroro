import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/login/controllers/login_controller.dart';
import 'package:mobile_ameroro_app/apps/login/models/login_request_model.dart';
import 'package:mobile_ameroro_app/apps/login/repository/login_repository.dart';
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
            SizedBox(
              height: 80.r,
            ),
            Image.asset(
              'assets/images/logo-pu.png',
              scale: 1,
            ),
            SizedBox(
              height: 20.r,
            ),
            Text(
              'Aplikasi Monitoring',
              style: TextStyle(
                fontSize: 20.r,
                fontWeight: FontWeight.bold,
                color: GFColors.LIGHT,
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
                    color: GFColors.LIGHT,
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
            SizedBox(height: 40.r),
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
                suffixIcon: Icons.remove_red_eye_outlined,
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
            SizedBox(height: AppConfig.verticalSpace),
            GetBuilder<LoginController>(
              builder: (controller) {
                return GFButton(
                  icon: controller.status.isLoading
                      ? const GFLoader(
                          type: GFLoaderType.ios,
                          loaderColorOne: GFColors.LIGHT,
                        )
                      : null,
                  size: 45.r,
                  textStyle: TextStyle(
                      fontSize: 18.r,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.bgLogin),
                  onPressed: (controller.isLoginButtonEnabled.value ||
                          controller.status.isLoading)
                      ? () async {
                          LoginRequestModel model = LoginRequestModel(
                            username: controller.username.text,
                            password: controller.password.text,
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
