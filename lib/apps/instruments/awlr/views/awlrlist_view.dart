import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/controllers/awlrlist_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlrlist_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';

class AwlrListView extends GetView<AwlrListController> {
  AwlrListView({super.key});
  DateTime now = DateTime.now();

  Widget _detail(BuildContext context, AwlrListController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () => controller.getAwlrList(),
      child: controller.isLoading.isTrue
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 10.r),
              padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
              itemCount: controller.listModel.length,
              itemBuilder: (context, i) {
                AwlrListModel model = controller.listModel[i];

                return GestureDetector(
                  onTap: () async {
                    await Get.toNamed(
                      AppRoutes.AWLR_DETAIL,
                      arguments: [model.deviceId, model.name],
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    padding: EdgeInsets.all(15.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                // width: 80.r,
                                // height: 50.r,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.name ?? "",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15.r,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                            (model.deviceStatus ?? "")
                                                        .toLowerCase() ==
                                                    'online'
                                                ? Icons.remove_circle
                                                : Icons.error,
                                            size: 20.r,
                                            color: (model.deviceStatus ?? "")
                                                        .toLowerCase() ==
                                                    'online'
                                                ? GFColors.SUCCESS
                                                : GFColors.DANGER),
                                        SizedBox(
                                          width: 5.r,
                                        ),
                                        Text(
                                          model.deviceStatus ?? "",
                                          style: TextStyle(fontSize: 12.r),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.r),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'TMA : ${model.waterLevel.toString()} (m)',
                                        style: TextStyle(
                                          fontSize: 18.r,
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                      (model.readingAt!.day == now.day &&
                                              model.readingAt!.month ==
                                                  now.month &&
                                              model.readingAt!.year == now.year)
                                          ? Text(
                                              'Update : Hari ini ${AppConstants().hourMinuteFormat.format(model.readingAt!)}',
                                              style: TextStyle(
                                                fontSize: 13.r,
                                                color: Colors.black
                                                    .withOpacity(0.6.r),
                                                fontWeight: FontWeight.w300,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            )
                                          : Text(
                                              'Update : ${AppConstants().dateTimeFormatID.format(model.readingAt!)}',
                                              style: TextStyle(
                                                fontSize: 13.r,
                                                color: Colors.black
                                                    .withOpacity(0.6.r),
                                                fontWeight: FontWeight.w300,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black.withOpacity(0.5.r),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildShimmerPlaceholder(BuildContext context) {
    return GFShimmer(
      mainColor: Colors.grey[400]!,
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 80.r,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(15.r),
            ),
            SizedBox(
              height: 10.r,
            ),
            Container(
              width: double.infinity,
              height: 80.r,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(15.r),
            ),
            SizedBox(
              height: 10.r,
            ),
            Container(
              width: double.infinity,
              height: 80.r,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(15.r),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AwlrListController>(
      builder: (controller) => Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            leading: GestureDetector(
              child: const Icon(
                Icons.arrow_back,
              ),
              onTap: () async {
                Get.back();
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AWLR',
                  style: TextStyle(
                    fontSize: 20.r,
                  ),
                ),
              ],
            ),
          ),
          body: controller.obx((state) => _detail(context, controller),
              onLoading: _buildShimmerPlaceholder(context))),
    );
  }
}
