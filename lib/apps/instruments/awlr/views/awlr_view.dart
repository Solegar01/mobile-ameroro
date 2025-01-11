import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  padding: EdgeInsets.all(10.r),
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
                  padding: EdgeInsets.all(8.r),
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
        return SizedBox(height: 8.r);
      },
      padding: EdgeInsets.all(8.r),
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
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10.r), // Rounded corners
              border: Border.all(
                color:
                    warningStatus != null ? warningStatus.color : Colors.grey,
                width: 2.r,
              ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name ?? '-',
                  style: TextStyle(
                    fontSize: 16.r,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.r),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ),
                SizedBox(height: 8.r),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF444b9b)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(FluentIcons.clock_48_regular,
                                      size: 30.r,
                                      color: const Color(0xFF444b9b)),
                                ),
                                SizedBox(width: 8.r),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppConstants()
                                                .hourMinuteFormat
                                                .format(data.readingAt!),
                                            style: TextStyle(
                                              fontSize: 12.r,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(0,
                                                  -8), // Move the superscript up
                                              child: Text(
                                                ' WITA',
                                                style: TextStyle(
                                                    fontSize: 8
                                                        .r), // Smaller font size
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Waktu',
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
                            SizedBox(height: 8.r),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2ac3af)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(FluentIcons.water_48_regular,
                                      size: 30.r,
                                      color: const Color(0xFF2ac3af)),
                                ),
                                SizedBox(width: 8.r),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppConstants()
                                                .numFormat
                                                .format(data.waterLevel ?? 0),
                                            style: TextStyle(
                                              fontSize: 12.r,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(0,
                                                  -8), // Move the superscript up
                                              child: Text(
                                                ' m',
                                                style: TextStyle(
                                                    fontSize: 8
                                                        .r), // Smaller font size
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'TMA',
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
                          ],
                        ),
                      ),
                      SizedBox(width: 8.r),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF2ac3af).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(CupertinoIcons.drop,
                                    size: 30.r, color: const Color(0xFF2ac3af)),
                              ),
                              SizedBox(width: 8.r),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppConstants()
                                              .numFormat
                                              .format(data.debit ?? 0),
                                          style: TextStyle(
                                            fontSize: 12.r,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(0,
                                                -8), // Move the superscript up
                                            child: Text(
                                              ' L/s',
                                              style: TextStyle(
                                                  fontSize:
                                                      8.r), // Smaller font size
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Debit',
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
                          SizedBox(height: 8.r),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: (data.battery ?? 0) > 10
                                      ? GFColors.SUCCESS.withOpacity(0.2)
                                      : (data.battery ?? 0) > 8 &&
                                              (data.battery ?? 0) <= 10
                                          ? GFColors.SUCCESS.withOpacity(0.2)
                                          : (data.battery ?? 0) > 6 &&
                                                  (data.battery ?? 0) <= 8
                                              ? GFColors.WARNING
                                                  .withOpacity(0.2)
                                              : (data.battery ?? 0) > 4 &&
                                                      (data.battery ?? 0) <= 6
                                                  ? GFColors.WARNING
                                                      .withOpacity(0.2)
                                                  : (data.battery ?? 0) > 2 &&
                                                          (data.battery ?? 0) <=
                                                              4
                                                      ? GFColors.DANGER
                                                          .withOpacity(0.2)
                                                      : GFColors.DANGER
                                                          .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  (data.battery ?? 0) > 10
                                      ? Icons.battery_full
                                      : (data.battery ?? 0) > 8 &&
                                              (data.battery ?? 0) <= 10
                                          ? Icons.battery_4_bar_rounded
                                          : (data.battery ?? 0) > 6 &&
                                                  (data.battery ?? 0) <= 8
                                              ? Icons.battery_3_bar_rounded
                                              : (data.battery ?? 0) > 4 &&
                                                      (data.battery ?? 0) <= 6
                                                  ? Icons.battery_2_bar_rounded
                                                  : (data.battery ?? 0) > 2 &&
                                                          (data.battery ?? 0) <=
                                                              4
                                                      ? Icons
                                                          .battery_1_bar_rounded
                                                      : Icons
                                                          .battery_0_bar_rounded,
                                  size: 30.r,
                                  color: (data.battery ?? 0) > 10
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
                                                          (data.battery ?? 0) <=
                                                              4
                                                      ? GFColors.DANGER
                                                      : GFColors.DANGER,
                                ),
                              ),
                              SizedBox(width: 8.r),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppConstants()
                                              .numFormat
                                              .format(data.battery ?? 0),
                                          style: TextStyle(
                                            fontSize: 12.r,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(0,
                                                -8), // Move the superscript up
                                            child: Text(
                                              ' v',
                                              style: TextStyle(
                                                  fontSize:
                                                      8.r), // Smaller font size
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Baterai',
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
                        ],
                      ),
                      SizedBox(width: 8.r),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.readingAt == null
                                ? '-'
                                : AppConstants().dateFormatID.format(
                                      data.readingAt!,
                                    ),
                            style: const TextStyle(
                                color: GFColors.DARK,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8.r),
                          (data.warningStatus ?? '').toLowerCase() == 'normal'
                              ? Column(
                                  children: [
                                    Icon(
                                        warningStatus != null
                                            ? warningStatus.icon
                                            : CupertinoIcons.question_circle,
                                        size: 50.r,
                                        color: warningStatus != null
                                            ? warningStatus.color
                                            : Colors.grey),
                                    Text(
                                      data.warningStatus == null
                                          ? '-'
                                          : data.warningStatus!.toUpperCase(),
                                      style: TextStyle(
                                          color: warningStatus != null
                                              ? warningStatus.color
                                              : Colors.grey,
                                          fontSize: 12.r,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : FadeTransition(
                                  opacity: controller.animation,
                                  child: Column(
                                    children: [
                                      Icon(
                                          warningStatus != null
                                              ? warningStatus.icon
                                              : CupertinoIcons.question_circle,
                                          size: 50.r,
                                          color: warningStatus != null
                                              ? warningStatus.color
                                              : Colors.grey),
                                      Text(
                                        data.warningStatus == null
                                            ? '-'
                                            : data.warningStatus!.toUpperCase(),
                                        style: TextStyle(
                                            color: warningStatus != null
                                                ? warningStatus.color
                                                : Colors.grey,
                                            fontSize: 12.r,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        width: 8.r,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
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
}
