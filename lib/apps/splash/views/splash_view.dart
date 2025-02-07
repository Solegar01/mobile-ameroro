import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/splash/controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<SplashController>(
          init: controller,
          builder: (controller) {
            if (controller.status.isLoading) {
              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/icons/splash_image.png', // Path to your image
                              ), // Image source
                              fit: BoxFit
                                  .cover, // Adjust the image to cover the entire container
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Space between image and title
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'BENDUNGAN ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppConfig.bgLogin,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'AMERORO',
                                  style: TextStyle(
                                      color: AppConfig.focusTextField,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GFShimmer(
                          mainColor: Colors.transparent, // Transparent base
                          secondaryColor: Colors.white.withOpacity(0.5),
                          duration: const Duration(seconds: 2),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: GFColors.WHITE,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Space between image and title
                        GFShimmer(
                          mainColor: Colors.transparent, // Transparent base
                          secondaryColor: GFColors.WHITE.withOpacity(0.5),
                          duration: const Duration(seconds: 2),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'BENDUNGAN ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppConfig.bgLogin,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'AMERORO',
                                    style: TextStyle(
                                        color: AppConfig.focusTextField,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (controller.status.isError) {
              return Text(
                  controller.status.errorMessage ?? 'Error tidak diketahui');
            } else {
              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/icons/splash_image.png', // Path to your image
                              ), // Image source
                              fit: BoxFit
                                  .cover, // Adjust the image to cover the entire container
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Space between image and title
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'BENDUNGAN ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppConfig.bgLogin,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'AMERORO',
                                  style: TextStyle(
                                      color: AppConfig.focusTextField,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
