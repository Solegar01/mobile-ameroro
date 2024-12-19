import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/app_controller.dart';
import 'package:mobile_ameroro_app/apps/cctv/controllers/cctv_controller.dart';
import 'package:mobile_ameroro_app/apps/cctv/repository/cctv_repository.dart';
import 'package:mobile_ameroro_app/apps/cctv/views/cctv_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Gunakan IndexedStack untuk menampilkan halaman yang sesuai
        return IndexedStack(
          index: controller.currentIndex.value,
          children: [
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
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => SizedBox(
          width: double.infinity,
          child: CustomNavigationBar(
            items: [
              CustomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 20.r,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 12.r,
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(
                  Icons.sensors,
                  size: 20.r,
                ),
                title: Text(
                  'Instrument',
                  style: TextStyle(
                    fontSize: 12.r,
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: const SizedBox(),
                title: Text(
                  'Peta Lokasi',
                  style: TextStyle(
                    fontSize: 12.r,
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(
                  Icons.video_call,
                  size: 20.r,
                ),
                title: Text(
                  'CCTV',
                  style: TextStyle(
                    fontSize: 12.r,
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 20.r,
                ),
                title: Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: 12.r,
                  ),
                ),
              ),
            ],
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.currentIndex.value = index;
            },
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => controller.x.value == ""
            ? FloatingActionButton(
                heroTag: null,
                backgroundColor: const Color(0xFF696FDB),
                elevation: 5.r,
                onPressed: () {
                  controller.currentIndex.value = 2;
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.r, color: const Color(0xFF696FDB)),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Icon(
                  Icons.pin_drop_outlined,
                  size: 20.r,
                ),
              )
            : const SizedBox(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
