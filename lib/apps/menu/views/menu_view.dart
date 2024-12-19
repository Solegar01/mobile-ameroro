import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/menu/controllers/menu_controller.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';

class MenuView extends StatelessWidget {
  final MenusController controller = Get.find<MenusController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: GFColors.WHITE,
        title: InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.PROFILE);
            },
            child: GetBuilder<MenusController>(
              builder: (controller) => Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                height: 100,
                child: Row(
                  children: [
                    const GFAvatar(
                      backgroundImage: AssetImage('assets/images/logo-pu.png'),
                    ),
                    SizedBox(
                      width: 10.r,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name.value,
                          style: TextStyle(fontSize: AppConfig.fontSize),
                        ),
                        Text(controller.username.value,
                            style: TextStyle(fontSize: 12.r)),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Halaman Menu"),
            GFButton(
              onPressed: () async {
                await controller.logout();
              },
              text: 'Logout',
              color: GFColors.DANGER,
            )
          ],
        ),
      ),
    );
  }
}
