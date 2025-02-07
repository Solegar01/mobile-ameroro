import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/controllers/awlr_controller.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';

class AwlrView extends StatelessWidget {
  final AwlrController controller = Get.find<AwlrController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AwlrController>(builder: (controller) {
      return PopScope(
          canPop: true,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: GFColors.WHITE,
                title: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('AWLR'),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info_outlined,
                    ),
                  ),
                ],
              ),
              body: controller.obx(
                (state) => _detail(context, controller),
                // onLoading: _loader(context, controller),
                onLoading: const Center(
                  child: CircularProgressIndicator(),
                ),
                onEmpty: const Text('Empty Data'),
                onError: (error) => Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(child: Text(error!)),
                ),
              ),
            ),
          ));
    });
  }

  _detail(BuildContext context, AwlrController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.formInit();
      },
      child: _listCard(context, controller),
    );
  }

  _listCard(BuildContext context, AwlrController controller) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: Colors.grey[400], height: 2);
      },
      padding: EdgeInsets.all(10),
      itemCount: controller.listAwlr.length,
      itemBuilder: (context, index) {
        final data = controller.listAwlr[index];
        WarningStatus? warningStatus;
        switch (data.warningStatus?.toLowerCase()) {
          case 'normal':
            warningStatus = WarningStatus.normal;
            break;
          case 'awas':
            warningStatus = WarningStatus.awas;
            break;
          case 'waspada':
            warningStatus = WarningStatus.waspada;
            break;
          case 'siaga':
            warningStatus = WarningStatus.siaga;
            break;
          default:
        }
        return ListTile(
          title: Text(
            data.stationName ?? '-',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConfig.primaryColor),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoBadge(GFColors.INFO, data.brandName ?? '-'),
                    SizedBox(width: 8),
                    _buildInfoBadge(GFColors.DARK, data.deviceId ?? '-'),
                    SizedBox(width: 8),
                    _buildInfoBadge(
                      (data.status ?? '').toLowerCase() == 'offline'
                          ? GFColors.DANGER
                          : GFColors.SUCCESS,
                      data.status ?? '-',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Waktu : ${AppConstants().dateTimeFullFormatID.format(data.readingAt!)} WITA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Debit : ${AppConstants().numFormat.format(data.debit ?? 0)} L/s',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tegangan Baterai : ${AppConstants().numFormat.format(data.batteryVoltage ?? 0)} v',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kapasitas Baterai : ${(data.batteryCapacity ?? 0)} %',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (data.warningStatus ?? '').toLowerCase() == 'normal' ||
                              (data.warningStatus ?? '').toLowerCase() == ''
                          ? Column(
                              children: [
                                Text(
                                  '${AppConstants().numFormat.format(data.waterLevel ?? 0)} mdpl',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppConfig.primaryColor,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: warningStatus != null
                                        ? warningStatus.color.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    data.warningStatus == null
                                        ? 'Tanpa Status'
                                        : data.warningStatus!.toUpperCase(),
                                    style: TextStyle(
                                        color: warningStatus != null
                                            ? warningStatus.color
                                            : Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          : FadeTransition(
                              opacity: controller.animation,
                              child: Column(
                                children: [
                                  Text(
                                    '${AppConstants().numFormat.format(data.waterLevel ?? 0)} mdpl',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppConfig.primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: warningStatus != null
                                          ? warningStatus.color.withOpacity(0.2)
                                          : Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      data.warningStatus == null
                                          ? 'Tanpa Status'
                                          : data.warningStatus!.toUpperCase(),
                                      style: TextStyle(
                                          color: warningStatus != null
                                              ? warningStatus.color
                                              : Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ],
          ),
          onTap: () async {
            await controller.toDetail(data);
          },
        );
      },
    );
  }

  Widget _buildInfoBadge(Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(4),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
