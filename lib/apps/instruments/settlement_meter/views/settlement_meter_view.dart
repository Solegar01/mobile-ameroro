import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/instruments/settlement_meter/controllers/settlement_meter_controller.dart';

class SettlementMeterView extends StatelessWidget {
  final SettlementMeterController controller =
      Get.find<SettlementMeterController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<SettlementMeterController>(
                builder: (controller) => const Text(
                  'SETTLEMENT METER',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              actions: const [],
            ),
            body: controller.obx(
              (state) => _detail(context, controller),
              onLoading: const Center(child: CircularProgressIndicator()),
              onEmpty: const Text('Empty Data'),
              onError: (error) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(error!)),
              ),
            ),
          ),
        ));
  }

  _detail(BuildContext context, SettlementMeterController controller) {
    return GetBuilder<SettlementMeterController>(
      builder: (controller) => const Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('SETTLEMENT METER')),
          ],
        ),
      ),
    );
  }
}
