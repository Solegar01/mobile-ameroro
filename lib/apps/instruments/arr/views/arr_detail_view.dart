import 'package:flutter/material.dart';
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
                  padding: EdgeInsets.all(10),
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
                  padding: EdgeInsets.all(8),
                  child: Center(child: Text(error!)),
                ),
              ),
            ),
          ));
    });
  }

  _detail(BuildContext context, ArrDetailController controller) {
    return Column(
      children: [
        RefreshIndicator(
          backgroundColor: GFColors.LIGHT,
          onRefresh: () async {
            await controller.formInit();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _forms(context, controller),
              ],
            ),
          ),
        ),
        Expanded(
          child: _graphTableTab(context, controller),
        ),
      ],
    );
  }

  _forms(BuildContext context, ArrDetailController controller) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: GFColors.WHITE,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade600,
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(-1, 1),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<DataFilterType>(
              dropdownColor: GFColors.WHITE,
              decoration: InputDecoration(
                labelText: "Interval",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
            SizedBox(height: 10),
            TextFormField(
              onTap: () async {
                await _selectDate(context, controller);
              },
              validator: (value) =>
                  value == null || value.isEmpty ? 'Pilih periode' : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
            SizedBox(height: 10),
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
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Tampilkan',
                    style: TextStyle(
                      fontSize: 16,
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
                margin: EdgeInsets.all(5),
                height: 300,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: GFColors.WHITE,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade600,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(-1, 1),
                          ),
                        ],
                      ),
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
                                height: 2,
                                fontSize: 14,
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
                                  AppConstants().dateTimeFormatID.format(date);
                              return SingleChildScrollView(
                                child: Container(
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: cColor, // Fill color
                                                shape: BoxShape
                                                    .circle, // Makes it a circle
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
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
                              color:
                                  Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color:
                                  Color(0xFF2CAFFE), // Tooltip background color
                              textStyle: TextStyle(
                                  color: Colors.white), // Tooltip text color
                            ),
                            activationMode: ActivationMode.singleTap,
                            enable: true,
                            builder: (BuildContext context,
                                TrackballDetails trackballDetails) {
                              final DateTime date = trackballDetails.point?.x;
                              final String formattedDate =
                                  AppConstants().dateTimeFormatID.format(date);
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.blue,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
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
                                borderWidth: 2,
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
                  );
                });
          } else {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(-1, 1),
                ),
              ],
            ),
            child: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                margin: EdgeInsets.all(5),
                height: 300,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: GFColors.WHITE,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade600,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(-1, 1),
                          ),
                        ],
                      ),
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
                                height: 2,
                                fontSize: 14,
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
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: cColor, // Fill color
                                                shape: BoxShape
                                                    .circle, // Makes it a circle
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
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
                              color:
                                  Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color:
                                  Color(0xFF2CAFFE), // Tooltip background color
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
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.blue,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
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
                                borderWidth: 2,
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
                  );
                });
          } else {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(-1, 1),
                ),
              ],
            ),
            child: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                margin: EdgeInsets.all(5),
                height: 300,
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: GFColors.WHITE,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade600,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(-1, 1),
                          ),
                        ],
                      ),
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
                                height: 2,
                                fontSize: 14,
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
                                  AppConstants().dateTimeFormatID.format(date);
                              return SingleChildScrollView(
                                child: Container(
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: cColor, // Fill color
                                                shape: BoxShape
                                                    .circle, // Makes it a circle
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
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
                              color:
                                  Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color:
                                  Color(0xFF2CAFFE), // Tooltip background color
                              textStyle: TextStyle(
                                  color: Colors.white), // Tooltip text color
                            ),
                            activationMode: ActivationMode.singleTap,
                            enable: true,
                            builder: (BuildContext context,
                                TrackballDetails trackballDetails) {
                              final DateTime date = trackballDetails.point?.x;
                              final String formattedDate =
                                  AppConstants().dateTimeFormatID.format(date);
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.blue,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
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
                                borderWidth: 2,
                                markerSettings: const MarkerSettings(
                                    color: Colors.white,
                                    // isVisible: true,
                                    // Marker shape is set to diamond
                                    shape: DataMarkerType.circle),
                                dataSource: listData,
                                xValueMapper: (ArrDetailMinuteModel data, _) =>
                                    data.readingAt,
                                yValueMapper: (ArrDetailMinuteModel data, _) =>
                                    data.rainfall ?? 0,
                                name: 'Curah Hujan',
                                color: const Color.fromRGBO(8, 142, 255, 1)),
                          ]),
                    ),
                  );
                });
          } else {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(-1, 1),
                ),
              ],
            ),
            child: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: GFColors.WHITE,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade600,
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: const Offset(-1, 1),
                  ),
                ],
              ),
              child: GFShimmer(
                mainColor: Colors.grey[300]!,
                secondaryColor: Colors.grey[100]!,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: GFColors.WHITE,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: GFColors.WHITE,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: const Offset(-1, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: Colors.grey,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SfDataGrid(
                                onQueryRowHeight: (details) {
                                  if (details.rowIndex == 0) {
                                    return 50;
                                  }
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                source: ds,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 160,
                                      columnName: 'readingHour',
                                      label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: const Text('Tanggal',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: GFColors.WHITE)))),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'hourMinuteFormat',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Jam ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: GFColors.WHITE)),
                                            TextSpan(
                                                text: '(WITA)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white70))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                      minimumWidth: 100,
                                      columnName: 'rainfall',
                                      label: Container(
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'CH ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: GFColors.WHITE)),
                                              TextSpan(
                                                  text: '(mm)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white70))
                                            ],
                                          ),
                                        ),
                                      )),
                                  GridColumn(
                                    minimumWidth: 150,
                                    columnName: 'intensity',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Intensitas ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: GFColors.WHITE)),
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
                          padding: EdgeInsets.all(10),
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
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(-1, 1),
                ),
              ],
            ),
            child: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: GFColors.WHITE,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade600,
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: const Offset(-1, 1),
                  ),
                ],
              ),
              child: GFShimmer(
                mainColor: Colors.grey[300]!,
                secondaryColor: Colors.grey[100]!,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: GFColors.WHITE,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: GFColors.WHITE,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: const Offset(-1, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: Colors.grey,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SfDataGrid(
                                onQueryRowHeight: (details) {
                                  if (details.rowIndex == 0) {
                                    return 50;
                                  }
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                source: ds,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 160,
                                      columnName: 'readingAt',
                                      label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: const Text('Tanggal',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: GFColors.WHITE)))),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'hourMinuteFormat',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Jam ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: GFColors.WHITE)),
                                            TextSpan(
                                                text: '(WITA)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white70))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'rainfall',
                                      label: Container(
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'CH ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: GFColors.WHITE)),
                                              TextSpan(
                                                  text: '(mm)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white70))
                                            ],
                                          ),
                                        ),
                                      )),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'batteryCapacity',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Baterai ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: GFColors.WHITE)),
                                            TextSpan(
                                                text: '(%)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white70)),
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
                          padding: EdgeInsets.all(10),
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
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(-1, 1),
                ),
              ],
            ),
            child: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: GFColors.WHITE,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade600,
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: const Offset(-1, 1),
                  ),
                ],
              ),
              child: GFShimmer(
                mainColor: Colors.grey[300]!,
                secondaryColor: Colors.grey[100]!,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: GFColors.WHITE,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: GFColors.WHITE,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: const Offset(-1, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: Colors.grey,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SfDataGrid(
                                onQueryRowHeight: (details) {
                                  if (details.rowIndex == 0) {
                                    return 50;
                                  }
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                source: ds,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 160,
                                      columnName: 'readingDate',
                                      label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: const Text('Tanggal',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: GFColors.WHITE)))),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'rainfall',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'CH ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: GFColors.WHITE)),
                                            TextSpan(
                                                text: '(mm)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white70))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'intensity',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Intensitas ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: GFColors.WHITE)),
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
                          padding: EdgeInsets.all(10),
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
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(-1, 1),
                ),
              ],
            ),
            child: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
