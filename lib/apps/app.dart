import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/app_controller.dart';
import 'package:mobile_ameroro_app/apps/cctv/controllers/cctv_controller.dart';
import 'package:mobile_ameroro_app/apps/cctv/repository/cctv_repository.dart';
import 'package:mobile_ameroro_app/apps/cctv/views/cctv_view.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/home/controllers/home_controller.dart';
import 'package:mobile_ameroro_app/apps/home/repository/home_repository.dart';
import 'package:mobile_ameroro_app/apps/home/views/home_view.dart';
import 'package:mobile_ameroro_app/apps/instrument/controllers/instrument_controller.dart';
import 'package:mobile_ameroro_app/apps/instrument/views/instrument_view.dart';
import 'package:mobile_ameroro_app/apps/map/controllers/map_controller.dart';
import 'package:mobile_ameroro_app/apps/map/repository/map_repository.dart';
import 'package:mobile_ameroro_app/apps/map/views/map_view.dart';
import 'package:mobile_ameroro_app/apps/profile/controllers/profile_controller.dart';
import 'package:mobile_ameroro_app/apps/profile/repository/profile_repository.dart';
import 'package:mobile_ameroro_app/apps/profile/views/profile_view.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class MyApp extends StatelessWidget {
  final AppController controller = Get.put(AppController());
  final List<Widget> _screens = [
    GetBuilder<HomeController>(
      init: HomeController(HomeRepository(ApiService())),
      builder: (controller) => HomeView(),
    ),
    GetBuilder<InstrumentController>(
      init: InstrumentController(),
      builder: (controller) => InstrumentView(),
    ),
    GetBuilder<MapController>(
      init: MapController(MapRepository(ApiService())),
      builder: (controller) => PetaView(),
    ),
    GetBuilder<CctvController>(
      init: CctvController(CctvRepository(ApiService())),
      builder: (controller) => CctvView(),
    ),
    GetBuilder<ProfileController>(
      init: ProfileController(ProfileRepository(ApiService())),
      builder: (controller) => ProfileView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[controller.currentIndex.value]),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(
            () => BottomNavigationBar(
              backgroundColor: const Color(0xFFE6E9EE),
              currentIndex: controller.currentIndex.value,
              onTap: (index) {
                controller.changeTab(index);
              },
              selectedItemColor: AppConfig.primaryColor,
              unselectedItemColor: const Color(0xFF6B7E8D),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(FluentIcons.home_16_filled),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sensors),
                  label: "Instrument",
                ),
                BottomNavigationBarItem(
                  icon:
                      SizedBox.shrink(), // Placeholder for the floating button
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(FluentIcons.video_16_filled),
                  label: "CCTV",
                ),
                BottomNavigationBarItem(
                  icon: Icon(FluentIcons.person_16_filled),
                  label: "Profile",
                ),
              ],
            ),
          ),
          // Add the floating button
          Positioned(
            bottom: 8.0,
            left:
                MediaQuery.of(context).size.width / 2 - 30, // Center the button
            child: Obx(
              () => Column(
                children: [
                  FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () {
                      controller
                          .changeTab(2); // Set index for floating button action
                    },
                    backgroundColor: controller.currentIndex.value == 2
                        ? AppConfig.primaryColor
                        : const Color(0xFF6B7E8D),
                    child: const Icon(Icons.pin_drop_outlined,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Peta Lokasi',
                    style: controller.currentIndex.value == 2
                        ? const TextStyle(
                            fontSize: 12, color: AppConfig.primaryColor)
                        : const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7E8D),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
