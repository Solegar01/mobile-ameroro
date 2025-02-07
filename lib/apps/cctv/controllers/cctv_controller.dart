import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_ameroro_app/apps/cctv/models/cctv_model.dart';
import 'package:mobile_ameroro_app/apps/cctv/repository/cctv_repository.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';

class CctvController extends GetxController with StateMixin {
  final CctvRepository repository;
  CctvController(this.repository);

  Rx<CctvModel> cctv = CctvModel.empty().obs;
  RxList<CctvModel> cctvs = <CctvModel>[].obs;

  var selectedIndex = 0.obs;
  MapType currentMapType = MapType.satellite;

  @override
  void onInit() {
    super.onInit();
    fetchAllCctv();
  }

  Future<void> fetchAllCctv() async {
    change(null, status: RxStatus.loading());
    try {
      final fetchedCctvs = await repository.getAllCctvs();
      cctvs(fetchedCctvs);
      change(null, status: RxStatus.success());
    } catch (e) {
      log('Error fetching all CCTV: $e');
      change(null, status: RxStatus.error());
    }
  }

  Future<void> toDetail(CctvModel data) async {
    Get.toNamed(
      AppRoutes.CCTV_DETAIL,
      arguments: data,
    );
  }

  void toggleMapType() {
    currentMapType =
        currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    update();
  }
}
