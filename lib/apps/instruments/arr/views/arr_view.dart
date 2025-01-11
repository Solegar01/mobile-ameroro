import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/controllers/arr_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_model.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

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
                  padding: EdgeInsets.all(10.r),
                  child: Text('Automatic Rainfall Recorder'),
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
                  padding: EdgeInsets.all(8.r),
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
        return SizedBox(height: 8.r);
      },
      padding: EdgeInsets.all(8.r),
      itemCount: controller.listArr.length,
      itemBuilder: (context, index) {
        final data = controller.listArr[index];
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name ?? '-',
                  style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.r,
                ),
                // Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildInfoBadge(GFColors.INFO, data.brandName ?? '-'),
                    SizedBox(width: 8.r),
                    _buildInfoBadge(GFColors.DARK, data.deviceId ?? '-'),
                    SizedBox(width: 8.r),
                    _buildInfoBadge(
                      (data.status ?? '').toLowerCase() == 'offline'
                          ? GFColors.DANGER
                          : GFColors.SUCCESS,
                      data.status ?? '-',
                    ),
                  ],
                ),
                SizedBox(height: 10.r),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildContentCard(
                                    icon: FluentIcons.clock_48_regular,
                                    iconColor: const Color(0xFF444b9b),
                                    title: AppConstants()
                                        .hourMinuteFormat
                                        .format(data.readingAt!),
                                    subtitle: 'Waktu',
                                    unit: 'WITA'),
                                SizedBox(height: 5.r),
                                _buildContentCard(
                                    icon: FluentIcons.weather_rain_48_regular,
                                    iconColor: GFColors.INFO,
                                    title: AppConstants()
                                        .numFormat
                                        .format(data.rainfallLastHour ?? 0),
                                    subtitle: 'Curah Hujan',
                                    unit: 'mm'),
                                SizedBox(height: 5.r),
                                _buildContentCard(
                                    icon: (data.battery ?? 0) > 10
                                        ? Icons.battery_full
                                        : (data.battery ?? 0) > 8 &&
                                                (data.battery ?? 0) <= 10
                                            ? Icons.battery_4_bar_rounded
                                            : (data.battery ?? 0) > 6 &&
                                                    (data.battery ?? 0) <= 8
                                                ? Icons.battery_3_bar_rounded
                                                : (data.battery ?? 0) > 4 &&
                                                        (data.battery ?? 0) <= 6
                                                    ? Icons
                                                        .battery_2_bar_rounded
                                                    : (data.battery ?? 0) > 2 &&
                                                            (data.battery ??
                                                                    0) <=
                                                                4
                                                        ? Icons
                                                            .battery_1_bar_rounded
                                                        : Icons
                                                            .battery_0_bar_rounded,
                                    iconColor: (data.battery ?? 0) > 10
                                        ? GFColors.SUCCESS
                                        : (data.battery ?? 0) > 8 &&
                                                (data.battery ?? 0) <= 10
                                            ? GFColors.SUCCESS
                                            : (data.battery ?? 0) > 6 &&
                                                    (data.battery ?? 0) <= 8
                                                ? GFColors.WARNING
                                                : (data.battery ?? 0) > 4 &&
                                                        (data.battery ?? 0) <= 6
                                                    ? GFColors.WARNING
                                                    : (data.battery ?? 0) > 2 &&
                                                            (data.battery ??
                                                                    0) <=
                                                                4
                                                        ? GFColors.DANGER
                                                        : GFColors.DANGER,
                                    title: AppConstants()
                                        .numFormat
                                        .format(data.battery ?? 0),
                                    subtitle: 'Baterai',
                                    unit: 'v'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.r,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (data.deviceId != null)
                                ? AppConstants()
                                    .dateFormatID
                                    .format(data.readingAt!)
                                : '-',
                            style: const TextStyle(
                                color: Color(0xFF6C757D),
                                fontWeight: FontWeight.w500),
                          ),
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
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.r,
                      ),
                      Icon(
                        FluentIcons.chevron_right_32_filled,
                        size: 30.r,
                        color: AppConfig.primaryColor,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () async {
            await controller.toDetail(data);
          },
        );
      },
    );
  }

  _wBattery(BuildContext context, ArrModel data) {}

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
      width: 100.r,
      height: 100.r,
    );
  }

  Widget _buildInfoBadge(Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.r),
      ),
      padding: EdgeInsets.all(4.r),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12.r,
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
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Icon(icon, size: 30.r, color: iconColor),
        ),
        SizedBox(
          width: 5.r,
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
                      fontSize: 14.r,
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
                            fontSize: 8.r,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey), // Smaller font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.r,
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.r,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
