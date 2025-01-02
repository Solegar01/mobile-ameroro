import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/controllers/arr_controller.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
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
    return ListView.builder(
      padding: EdgeInsets.all(8.r),
      itemCount: controller.listArr.length,
      itemBuilder: (context, index) {
        final data = controller.listArr[index];
        return GestureDetector(
          child: GFCard(
            margin: EdgeInsets.all(8.r),
            padding: EdgeInsets.zero,
            boxFit: BoxFit.cover,
            color: Colors.white,
            elevation: 5.r,
            content: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        data.name ?? '-',
                        style: TextStyle(
                            fontSize: 16.r, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.r),
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
                      SizedBox(height: 8.r),
                      // Content Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildContentCard(
                              icon: FontAwesomeIcons.clock,
                              iconColor: const Color(0xFF444b9b),
                              title:
                                  '${AppConstants().hourMinuteFormat.format(data.readingAt!)} WITA',
                              subtitle: 'Waktu',
                            ),
                            SizedBox(width: 5.r),
                            _buildContentCard(
                              icon: FontAwesomeIcons.cloudRain,
                              iconColor: GFColors.INFO,
                              title:
                                  '${AppConstants().numFormat.format(data.rainfallLastHour ?? 0)} mm',
                              subtitle: 'Curah Hujan',
                            ),
                            SizedBox(width: 5.r),
                            _buildContentCard(
                              icon: FontAwesomeIcons.batteryFull,
                              iconColor: GFColors.SUCCESS,
                              title:
                                  '${AppConstants().numFormat.format(data.battery ?? 0)} v',
                              subtitle: 'Baterai',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 30.r,
                  color: AppConfig.primaryColor,
                )
              ],
            ),
          ),
          onTap: () => msgToast('Test'),
        );
      },
    );
  }

  Widget _buildInfoBadge(Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.35),
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
  }) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: GFColors.LIGHT.withOpacity(0.35),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30.r, color: iconColor),
          SizedBox(width: 8.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.r,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12.r,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
