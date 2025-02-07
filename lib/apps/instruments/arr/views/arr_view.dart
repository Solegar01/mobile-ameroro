import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/controllers/arr_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';

class ArrView extends StatelessWidget {
  final ArrController controller = Get.find<ArrController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArrController>(builder: (controller) {
      return PopScope(
          canPop: true,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: GFColors.WHITE,
                title: Padding(
                  padding: EdgeInsets.all(10),
                  child: const Text('ARR'),
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

  _detail(BuildContext context, ArrController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.formInit();
      },
      child: _listCard(context, controller),
    );
  }

  _listCard(BuildContext context, ArrController controller) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Container(color: GFColors.LIGHT, height: 2);
      },
      padding: EdgeInsets.all(8),
      itemCount: controller.listArr.length,
      itemBuilder: (context, index) {
        final data = controller.listArr[index];

        return ListTile(
          title: Text(
            data.name ?? '-',
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
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
                          'Curah Hujan : ${AppConstants().numFormat.format(data.rainfallLastHour ?? 0)} mm',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Kapasitas Baterai : ${AppConstants().numFormat.format(data.batteryCapacity ?? 0)} %',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ((data.intensityLastHour ?? '').toLowerCase() ==
                                'tidak ada hujan')
                            ? _getImage(data)
                            : FadeTransition(
                                opacity: controller.animation,
                                child: _getImage(data),
                              ),
                        Text(
                          data.intensityLastHour ?? '',
                          style: const TextStyle(
                            color: GFColors.DARK,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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

  _getImage(ArrModel data) {
    String path = 'assets/images/arr/arr-icon-offline.png';
    String sImg = '';
    String sTime = '';
    if (data.readingAt!.hour >= 6 && data.readingAt!.hour < 12) {
      sTime = 'pagi';
    } else if (data.readingAt!.hour >= 12 && data.readingAt!.hour < 16) {
      sTime = 'siang';
    } else if (data.readingAt!.hour >= 16 && data.readingAt!.hour < 19) {
      sTime = 'sore';
    } else {
      sTime = 'malam';
    }

    if ((data.intensityLastHour ?? '').toLowerCase() == 'tidak ada hujan') {
      sImg = 'berawan';
    } else if ((data.intensityLastHour ?? '').toLowerCase() == 'hujan ringan') {
      sImg = 'hujan-ringan';
    } else if ((data.intensityLastHour ?? '').toLowerCase() == 'hujan sedang') {
      sImg = 'hujan-sedang';
    } else if ((data.intensityLastHour ?? '').toLowerCase() == 'hujan lebat') {
      sImg = 'hujan-lebat';
    } else if ((data.intensityLastHour ?? '').toLowerCase() ==
        'hujan sangat lebat') {
      sImg = 'hujan-sangat-lebat';
    }

    if (sImg.isNotEmpty && sTime.isNotEmpty) {
      if ((data.intensityLastHour ?? '').toLowerCase() == 'tidak ada hujan') {
        path = 'assets/images/arr/$sImg-$sTime-outline.png';
      } else {
        path = 'assets/images/arr/$sImg-outline.png';
      }
    }
    return Image.asset(
      path,
      width: 50,
      height: 50,
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

  Widget _buildContentCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String unit,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(icon, size: 30, color: iconColor),
        ),
        SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: const Offset(0, -8), // Move the superscript up
                      child: Text(
                        ' $unit',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey), // Smaller font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
