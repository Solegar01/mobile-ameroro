import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/instruments/ews/controllers/ews_controller.dart';

class EwsView extends StatelessWidget {
  final EwsController controller = Get.find<EwsController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true; // Mengizinkan dialog untuk ditutup
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<EwsController>(
                builder: (controller) => Text(
                  'EARLY WARNING SYSTEM',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              actions: [],
            ),
            body: controller.obx(
              (state) => _detail(context, controller),
              onLoading: const Center(child: CircularProgressIndicator()),
              onEmpty: const Text('Tidak ada data yang tersedia'),
              onError: (error) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(error ?? 'Terjadi kesalahan saat memuat data')),
              ),
            ),
          ),
        ));
  }

  _detail(BuildContext context, EwsController controller) {
    return GetBuilder<EwsController>(
      builder: (controller) => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('EARLY WARNING SYSTEM')),
          ],
        ),
      ),
    );
  }
}
