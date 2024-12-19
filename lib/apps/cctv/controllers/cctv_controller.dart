import 'dart:developer';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/cctv/models/cctv_model.dart';
import 'package:mobile_ameroro_app/apps/cctv/repository/cctv_repository.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class CctvController extends GetxController {
  final CctvRepository repository;
  CctvController(this.repository);

  Rx<CctvModel> cctv = CctvModel.empty().obs;
  RxList<CctvModel> cctvs = <CctvModel>[].obs;
  RxBool isLoading = true.obs;

  // TextEditingController untuk input form update CCTV
  TextEditingController name = TextEditingController();
  TextEditingController url = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController note = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllCctv();
  }

  Future<void> fetchAllCctv() async {
    isLoading.value = true;
    try {
      final fetchedCctvs = await repository.getAllCctvs();
      cctvs(fetchedCctvs);
    } catch (e) {
      log('Error fetching all CCTV: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCctv(String id) async {
    try {
      isLoading.value = true;
      final updatedCctv = CctvModel(
        id: id,
        name: name.text,
        url: url.text,
        latitude: double.tryParse(latitude.text),
        longitude: double.tryParse(longitude.text),
        note: note.text,
      );

      await repository.update(id, updatedCctv);

      // Perbarui data di list lokal
      int index = cctvs.indexWhere((cctv) => cctv.id == id);
      if (index != -1) {
        cctvs[index] = updatedCctv;
      }

      // Get.back();
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        titleText: Text(
          'Update CCTV Berhasil',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        messageText: SizedBox.shrink(),
        margin: EdgeInsets.all(10),
      );
    } catch (e) {
      print('Error in updateCctv: $e');
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        titleText: Text(
          'Update CCTV Gagal',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        messageText: SizedBox.shrink(),
        margin: EdgeInsets.all(10),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toDetail(int index) async {
    clearTextEditingController();

    var currentCctv = cctvs[index];
    name.text = currentCctv.name;
    url.text = currentCctv.url;
    latitude.text =
        currentCctv.latitude?.toString() ?? ''; // Convert to string if not null
    longitude.text = currentCctv.longitude?.toString() ??
        ''; // Convert to string if not null
    note.text = currentCctv.note ?? '';

    Get.toNamed(
      AppRoutes.CCTV_DETAIL,
      arguments: currentCctv.id,
    );
  }

  void clearTextEditingController() {
    name.clear();
    url.clear();
    latitude.clear();
    longitude.clear();
    note.clear();
  }
}
