import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/controllers/awlr_controller.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
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
        var warningStatus = WarningStatus.normal;
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
                color: warningStatus.color,
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
                                  child: Icon(FontAwesomeIcons.clock,
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
                                  child: Icon(
                                      FontAwesomeIcons.arrowUpFromGroundWater,
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
                                child: Icon(FontAwesomeIcons.droplet,
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
                                  color:
                                      const Color(0xFF65d697).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(FontAwesomeIcons.batteryFull,
                                    size: 30.r, color: const Color(0xFF65d697)),
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
                                : AppConstants()
                                    .dateFormatID
                                    .format(data.readingAt!),
                          ),
                          SizedBox(height: 8.r),
                          Icon(warningStatus.icon,
                              size: 50.r, color: warningStatus.color),
                          Text(
                            data.warningStatus == null
                                ? '-'
                                : data.warningStatus!.toUpperCase(),
                            style: TextStyle(
                                color: warningStatus.color,
                                fontSize: 12.r,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            msgToast('TEST');
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
