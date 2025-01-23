import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/controllers/arr_detail_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_day_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_hour_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_minute_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ArrDetailView extends StatelessWidget {
  final ArrDetailController controller = Get.find<ArrDetailController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArrDetailController>(builder: (controller) {
      return PopScope(
          canPop: true,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: GFColors.WHITE,
                title: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Text(controller.model?.name ?? '-'),
                ),
                actions: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Icons.info_outlined,
                  //   ),
                  // ),
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

  _detail(BuildContext context, ArrDetailController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          _forms(context, controller),
          SizedBox(
            height: 650.r,
            child: _graphTableTab(context, controller),
          ),
        ],
      ),
    );
  }

  _forms(BuildContext context, ArrDetailController controller) {
    return Container(
      padding: EdgeInsets.all(10.r),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<DataFilterType>(
              dropdownColor: GFColors.WHITE,
              decoration: InputDecoration(
                labelText: "Interval",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              value: controller.filterType.value,
              items: controller.listFilterType.map((DataFilterType item) {
                return DropdownMenuItem<DataFilterType>(
                  value: item,
                  child: Text(item.name),
                );
              }).toList(),
              onChanged: (DataFilterType? newValue) async {
                if (newValue != null) {
                  controller.filterType.value = newValue;
                  if (_formKey.currentState?.validate() ?? false) {
                    if (controller.filterType.value ==
                        DataFilterType.fiveMinutely) {
                      await controller.getDataMinute();
                    }
                    if (controller.filterType.value == DataFilterType.hourly) {
                      await controller.getDataHour();
                    }
                    if (controller.filterType.value == DataFilterType.daily) {
                      await controller.getDataDay();
                    }
                  }
                }
              },
            ),
            SizedBox(height: 10.r),
            TextFormField(
              onTap: () async {
                await _selectDate(context, controller);
              },
              validator: (value) =>
                  value == null || value.isEmpty ? 'Pilih periode' : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: const BorderSide(color: GFColors.DARK)),
                labelText: 'Periode',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    await _selectDate(context, controller);
                  },
                ),
              ),
              controller: controller.dateRangeController,
              readOnly: true,
            ),
            SizedBox(height: 10.r),
            ElevatedButton(
              onPressed: () async {
                // Validate form and show a message if valid
                if (_formKey.currentState?.validate() ?? false) {
                  if (controller.filterType.value ==
                      DataFilterType.fiveMinutely) {
                    await controller.getDataMinute();
                  }
                  if (controller.filterType.value == DataFilterType.hourly) {
                    await controller.getDataHour();
                  }
                  if (controller.filterType.value == DataFilterType.daily) {
                    await controller.getDataDay();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GFColors.WHITE,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: AppConfig.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(30.r), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Tampilkan',
                    style: TextStyle(
                      fontSize: 16.r,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context, ArrDetailController controller) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
      initialDateRange: controller.selectedDateRange.value,
    );
    if (picked != null) {
      controller.selectedDateRange.value = picked;
      var start = picked.start;
      var end = picked.end;
      controller.dateRangeController.text = start == end
          ? AppConstants().dateFormatID.format(start)
          : '${AppConstants().dateFormatID.format(start)} - ${AppConstants().dateFormatID.format(end)}';
    }
  }

  _graphTableTab(BuildContext context, ArrDetailController controller) {
    return Column(
      children: [
        TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('GRAFIK')],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('TABEL')],
              ),
            ),
          ],
        ),
        Obx(
          () => Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                (controller.filterType.value == DataFilterType.hourly)
                    ? _rainFallChartHour(context, controller)
                    : (controller.filterType.value == DataFilterType.daily)
                        ? _rainFallChartDay(context, controller)
                        : (controller.filterType.value ==
                                DataFilterType.fiveMinutely)
                            ? _rainFallChartMinute(context, controller)
                            : const Center(child: Text('Invalid data')),
                (controller.filterType.value == DataFilterType.hourly)
                    ? _tableTabHour(context, controller)
                    : (controller.filterType.value == DataFilterType.daily)
                        ? _tableTabDay(context, controller)
                        : (controller.filterType.value ==
                                DataFilterType.fiveMinutely)
                            ? _tableTabMinute(context, controller)
                            : const Center(child: Text('Invalid data')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _rainFallChartHour(BuildContext context, ArrDetailController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: EdgeInsets.all(10.r),
                height: 300.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: GFColors.WHITE,
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: Center(
                      child: Text('${snapshot.error}'),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            List<ArrDetailHourModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<ArrDetailController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: EdgeInsets.all(10.r),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 300.r,
                        child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              dateFormat: DateFormat.MMMd('id_ID'),
                              autoScrollingDeltaType: DateTimeIntervalType.auto,
                              labelFormat: '{value}',
                              title: const AxisTitle(
                                  text: "Waktu",
                                  alignment: ChartAlignment.center),
                            ),
                            primaryYAxis: const NumericAxis(
                              labelFormat: '{value}',
                              title: AxisTitle(text: 'Curah Hujan (mm)'),
                            ),
                            title: ChartTitle(
                              textStyle: TextStyle(
                                  height: 2.r,
                                  fontSize: 14.r,
                                  fontWeight: FontWeight.bold),
                              alignment: ChartAlignment.center,
                              text: 'Grafik Curah Hujan',
                            ),
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              builder: (dynamic data,
                                  dynamic point,
                                  dynamic series,
                                  int pointIndex,
                                  int seriesIndex) {
                                final cColor = series.color;
                                final DateTime date = point?.x;
                                final String formattedDate = AppConstants()
                                    .dateTimeFormatID
                                    .format(date);
                                return SingleChildScrollView(
                                  child: Container(
                                    width: 180.r,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.r),
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                            color: cColor,
                                          ))),
                                          padding: EdgeInsets.all(8.r),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 10.r,
                                                height: 10.r,
                                                decoration: BoxDecoration(
                                                  color: cColor, // Fill color
                                                  shape: BoxShape
                                                      .circle, // Makes it a circle
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.r,
                                              ),
                                              Text(
                                                '${series.name.toString()} : ${AppConstants().numFormat.format(point?.y)} (mm)',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            trackballBehavior: TrackballBehavior(
                              markerSettings: const TrackballMarkerSettings(
                                markerVisibility: TrackballVisibilityMode
                                    .visible, // Show markers
                                color: Colors
                                    .white, // Color of the trackball marker
                              ),
                              tooltipSettings: const InteractiveTooltip(
                                enable: true,
                                color: Color(
                                    0xFF2CAFFE), // Tooltip background color
                                textStyle: TextStyle(
                                    color: Colors.white), // Tooltip text color
                              ),
                              activationMode: ActivationMode.singleTap,
                              enable: true,
                              builder: (BuildContext context,
                                  TrackballDetails trackballDetails) {
                                final DateTime date = trackballDetails.point?.x;
                                final String formattedDate = AppConstants()
                                    .dateTimeFormatID
                                    .format(date);
                                return SingleChildScrollView(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                            color: Colors.blue,
                                          ))),
                                          padding: EdgeInsets.all(8.r),
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.r),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Curah Hujan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePinching: true, // Enable pinch zoom
                              enablePanning: true, // Enable panning
                              zoomMode: ZoomMode
                                  .x, // Allow zooming only on the x-axis (can be both x, y or both)
                              enableDoubleTapZooming:
                                  true, // Enable double-tap zoom
                            ),
                            series: <CartesianSeries>[
                              ColumnSeries<ArrDetailHourModel, DateTime>(
                                  borderColor: const Color(0xFF2CAFFE),
                                  borderWidth: 2.r,
                                  markerSettings: const MarkerSettings(
                                      color: Colors.white,
                                      // isVisible: true,
                                      // Marker shape is set to diamond
                                      shape: DataMarkerType.circle),
                                  dataSource: listData,
                                  xValueMapper: (ArrDetailHourModel data, _) =>
                                      data.readingHour,
                                  yValueMapper: (ArrDetailHourModel data, _) =>
                                      data.rainfall ?? 0,
                                  name: 'Curah Hujan',
                                  color: const Color.fromRGBO(8, 142, 255, 1)),
                            ]),
                      ),
                    ),
                  );
                });
          } else {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('No data available'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: EdgeInsets.all(10.r),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300.r,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('No data available'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _rainFallChartDay(BuildContext context, ArrDetailController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: EdgeInsets.all(10.r),
                height: 300.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: GFColors.WHITE,
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: Center(
                      child: Text('${snapshot.error}'),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            List<ArrDetailDayModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<ArrDetailController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: EdgeInsets.all(10.r),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 300.r,
                        child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              dateFormat: DateFormat.MMMd('id_ID'),
                              autoScrollingDeltaType: DateTimeIntervalType.auto,
                              labelFormat: '{value}',
                              title: const AxisTitle(
                                  text: "Waktu",
                                  alignment: ChartAlignment.center),
                            ),
                            primaryYAxis: const NumericAxis(
                              labelFormat: '{value}',
                              title: AxisTitle(text: 'Curah Hujan (mm)'),
                            ),
                            title: ChartTitle(
                              textStyle: TextStyle(
                                  height: 2.r,
                                  fontSize: 14.r,
                                  fontWeight: FontWeight.bold),
                              alignment: ChartAlignment.center,
                              text: 'Grafik Curah Hujan',
                            ),
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              builder: (dynamic data,
                                  dynamic point,
                                  dynamic series,
                                  int pointIndex,
                                  int seriesIndex) {
                                final cColor = series.color;
                                final DateTime date = point?.x;
                                final String formattedDate =
                                    AppConstants().dateFormatID.format(date);
                                return SingleChildScrollView(
                                  child: Container(
                                    width: 180.r,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.r),
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                            color: cColor,
                                          ))),
                                          padding: EdgeInsets.all(8.r),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 10.r,
                                                height: 10.r,
                                                decoration: BoxDecoration(
                                                  color: cColor, // Fill color
                                                  shape: BoxShape
                                                      .circle, // Makes it a circle
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.r,
                                              ),
                                              Text(
                                                '${series.name.toString()} : ${AppConstants().numFormat.format(point?.y)} (mm)',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            trackballBehavior: TrackballBehavior(
                              markerSettings: const TrackballMarkerSettings(
                                markerVisibility: TrackballVisibilityMode
                                    .visible, // Show markers
                                color: Colors
                                    .white, // Color of the trackball marker
                              ),
                              tooltipSettings: const InteractiveTooltip(
                                enable: true,
                                color: Color(
                                    0xFF2CAFFE), // Tooltip background color
                                textStyle: TextStyle(
                                    color: Colors.white), // Tooltip text color
                              ),
                              activationMode: ActivationMode.singleTap,
                              enable: true,
                              builder: (BuildContext context,
                                  TrackballDetails trackballDetails) {
                                final DateTime date = trackballDetails.point?.x;
                                final String formattedDate =
                                    AppConstants().dateFormatID.format(date);
                                return SingleChildScrollView(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                            color: Colors.blue,
                                          ))),
                                          padding: EdgeInsets.all(8.r),
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.r),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Curah Hujan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePinching: true, // Enable pinch zoom
                              enablePanning: true, // Enable panning
                              zoomMode: ZoomMode
                                  .x, // Allow zooming only on the x-axis (can be both x, y or both)
                              enableDoubleTapZooming:
                                  true, // Enable double-tap zoom
                            ),
                            series: <CartesianSeries>[
                              ColumnSeries<ArrDetailDayModel, DateTime>(
                                  borderColor: const Color(0xFF2CAFFE),
                                  borderWidth: 2.r,
                                  markerSettings: const MarkerSettings(
                                      color: Colors.white,
                                      // isVisible: true,
                                      // Marker shape is set to diamond
                                      shape: DataMarkerType.circle),
                                  dataSource: listData,
                                  xValueMapper: (ArrDetailDayModel data, _) =>
                                      data.readingDate,
                                  yValueMapper: (ArrDetailDayModel data, _) =>
                                      data.rainfall ?? 0,
                                  name: 'Curah Hujan',
                                  color: const Color.fromRGBO(8, 142, 255, 1)),
                            ]),
                      ),
                    ),
                  );
                });
          } else {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('No data available'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: EdgeInsets.all(10.r),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300.r,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('No data available'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _rainFallChartMinute(BuildContext context, ArrDetailController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: EdgeInsets.all(10.r),
                height: 300.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: GFColors.WHITE,
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: Center(
                      child: Text('${snapshot.error}'),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            List<ArrDetailMinuteModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<ArrDetailController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: EdgeInsets.all(10.r),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 300.r,
                        child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              dateFormat: DateFormat.MMMd('id_ID'),
                              autoScrollingDeltaType: DateTimeIntervalType.auto,
                              labelFormat: '{value}',
                              title: const AxisTitle(
                                  text: "Waktu",
                                  alignment: ChartAlignment.center),
                            ),
                            primaryYAxis: const NumericAxis(
                              labelFormat: '{value}',
                              title: AxisTitle(text: 'Curah Hujan (mm)'),
                            ),
                            title: ChartTitle(
                              textStyle: TextStyle(
                                  height: 2.r,
                                  fontSize: 14.r,
                                  fontWeight: FontWeight.bold),
                              alignment: ChartAlignment.center,
                              text: 'Grafik Curah Hujan',
                            ),
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              builder: (dynamic data,
                                  dynamic point,
                                  dynamic series,
                                  int pointIndex,
                                  int seriesIndex) {
                                final cColor = series.color;
                                final DateTime date = point?.x;
                                final String formattedDate = AppConstants()
                                    .dateTimeFormatID
                                    .format(date);
                                return SingleChildScrollView(
                                  child: Container(
                                    width: 180.r,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.r),
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                            color: cColor,
                                          ))),
                                          padding: EdgeInsets.all(8.r),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 10.r,
                                                height: 10.r,
                                                decoration: BoxDecoration(
                                                  color: cColor, // Fill color
                                                  shape: BoxShape
                                                      .circle, // Makes it a circle
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.r,
                                              ),
                                              Text(
                                                '${series.name.toString()} : ${AppConstants().numFormat.format(point?.y)} (mm)',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            trackballBehavior: TrackballBehavior(
                              markerSettings: const TrackballMarkerSettings(
                                markerVisibility: TrackballVisibilityMode
                                    .visible, // Show markers
                                color: Colors
                                    .white, // Color of the trackball marker
                              ),
                              tooltipSettings: const InteractiveTooltip(
                                enable: true,
                                color: Color(
                                    0xFF2CAFFE), // Tooltip background color
                                textStyle: TextStyle(
                                    color: Colors.white), // Tooltip text color
                              ),
                              activationMode: ActivationMode.singleTap,
                              enable: true,
                              builder: (BuildContext context,
                                  TrackballDetails trackballDetails) {
                                final DateTime date = trackballDetails.point?.x;
                                final String formattedDate = AppConstants()
                                    .dateTimeFormatID
                                    .format(date);
                                return SingleChildScrollView(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                            color: Colors.blue,
                                          ))),
                                          padding: EdgeInsets.all(8.r),
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.r),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Curah Hujan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePinching: true, // Enable pinch zoom
                              enablePanning: true, // Enable panning
                              zoomMode: ZoomMode
                                  .x, // Allow zooming only on the x-axis (can be both x, y or both)
                              enableDoubleTapZooming:
                                  true, // Enable double-tap zoom
                            ),
                            series: <CartesianSeries>[
                              ColumnSeries<ArrDetailMinuteModel, DateTime>(
                                  borderColor: const Color(0xFF2CAFFE),
                                  borderWidth: 2.r,
                                  markerSettings: const MarkerSettings(
                                      color: Colors.white,
                                      // isVisible: true,
                                      // Marker shape is set to diamond
                                      shape: DataMarkerType.circle),
                                  dataSource: listData,
                                  xValueMapper:
                                      (ArrDetailMinuteModel data, _) =>
                                          data.readingAt,
                                  yValueMapper:
                                      (ArrDetailMinuteModel data, _) =>
                                          data.rainfall ?? 0,
                                  name: 'Curah Hujan',
                                  color: const Color.fromRGBO(8, 142, 255, 1)),
                            ]),
                      ),
                    ),
                  );
                });
          } else {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('No data available'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: EdgeInsets.all(10.r),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300.r,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('No data available'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tableTabHour(BuildContext context, ArrDetailController controller) {
    return FutureBuilder(
      future: controller.getTableDataSourceHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFCard(
              margin: EdgeInsets.all(10.r),
              color: GFColors.WHITE,
              padding: EdgeInsets.zero,
              content: GFShimmer(
                mainColor: Colors.grey[300]!,
                secondaryColor: Colors.grey[100]!,
                child: Container(
                  height: 300.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: GFColors.WHITE,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: Center(
                      child: Text('${snapshot.error}'),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            TableDataSourceHour ds = snapshot.data as TableDataSourceHour;
            return GetBuilder<ArrDetailController>(
                id: 'table',
                builder: (controller) {
                  return Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(10.r), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(-2, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: GFColors.LIGHT,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: SfDataGrid(
                                onQueryRowHeight: (details) {
                                  if (details.rowIndex == 0) {
                                    return 50.r;
                                  }
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                source: ds,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 160.r,
                                      columnName: 'readingHour',
                                      label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: const Text('Tanggal',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'hourMinuteFormat',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Jam ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: '(WITA)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                      minimumWidth: 100.r,
                                      columnName: 'rainfall',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        child: RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'CH ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: '(mm)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      )),
                                  GridColumn(
                                    minimumWidth: 150.r,
                                    columnName: 'intensity',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Intensitas ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.r),
                          child: SfDataPager(
                            delegate: ds,
                            pageCount: controller.detailHourModel.isNotEmpty
                                ? (controller.detailHourModel.length /
                                    controller.rowsPerPage)
                                : 1,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('No data available'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: EdgeInsets.all(10.r),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300.r,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('No data available'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tableTabMinute(BuildContext context, ArrDetailController controller) {
    return FutureBuilder(
      future: controller.getTableDataSourceMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFCard(
              margin: EdgeInsets.all(10.r),
              color: GFColors.WHITE,
              padding: EdgeInsets.zero,
              content: GFShimmer(
                mainColor: Colors.grey[300]!,
                secondaryColor: Colors.grey[100]!,
                child: Container(
                  height: 300.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: GFColors.WHITE,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: Center(
                      child: Text('${snapshot.error}'),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            TableDataSourceMinute ds = snapshot.data as TableDataSourceMinute;
            return GetBuilder<ArrDetailController>(
                id: 'table',
                builder: (controller) {
                  return Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(10.r), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(-2, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: GFColors.LIGHT,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: SfDataGrid(
                                onQueryRowHeight: (details) {
                                  if (details.rowIndex == 0) {
                                    return 50.r;
                                  }
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                source: ds,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 160.r,
                                      columnName: 'readingAt',
                                      label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: const Text('Tanggal',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'hourMinuteFormat',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Jam ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: '(WITA)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                      minimumWidth: 80.r,
                                      columnName: 'rainfall',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        child: RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'CH ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: '(mm)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      )),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'batteryCapacity',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Baterai ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: '(%)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.r),
                          child: SfDataPager(
                            delegate: ds,
                            pageCount: controller.detailMinuteModel.isNotEmpty
                                ? (controller.detailMinuteModel.length /
                                    controller.rowsPerPage)
                                : 1,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('No data available'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: EdgeInsets.all(10.r),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300.r,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('No data available'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tableTabDay(BuildContext context, ArrDetailController controller) {
    return FutureBuilder(
      future: controller.getTableDataSourceDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFCard(
              margin: EdgeInsets.all(10.r),
              color: GFColors.WHITE,
              padding: EdgeInsets.zero,
              content: GFShimmer(
                mainColor: Colors.grey[300]!,
                secondaryColor: Colors.grey[100]!,
                child: Container(
                  height: 300.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: GFColors.WHITE,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: Center(
                      child: Text('${snapshot.error}'),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            TableDataSourceDay ds = snapshot.data as TableDataSourceDay;
            return GetBuilder<ArrDetailController>(
                id: 'table',
                builder: (controller) {
                  return Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(10.r), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(-2, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: GFColors.LIGHT,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: SfDataGrid(
                                onQueryRowHeight: (details) {
                                  if (details.rowIndex == 0) {
                                    return 50.r;
                                  }
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                source: ds,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 160.r,
                                      columnName: 'readingDate',
                                      label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: const Text('Tanggal',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'rainfall',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'CH ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: '(mm)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'intensity',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Intensitas ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.r),
                          child: SfDataPager(
                            delegate: ds,
                            pageCount: controller.detailDayModel.isNotEmpty
                                ? (controller.detailDayModel.length /
                                    controller.rowsPerPage)
                                : 1,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10.r),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300.r,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('No data available'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: EdgeInsets.all(10.r),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300.r,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('No data available'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
