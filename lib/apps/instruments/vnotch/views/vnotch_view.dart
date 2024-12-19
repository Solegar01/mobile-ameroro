import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/vnotch/controllers/vnotch_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/vnotch/models/vnotch_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VNotchView extends StatelessWidget {
  final VNotchController controller = Get.find<VNotchController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<VNotchController>(
                builder: (controller) => Text(
                  'V-NOTCH',
                  style: TextStyle(
                    fontSize: 20.r,
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

  _detail(BuildContext context, VNotchController controller) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          GFCard(
            margin: EdgeInsets.symmetric(horizontal: 10.r),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            elevation: 2.r,
            content: Padding(
              padding: EdgeInsets.all(10.r),
              child: TextFormField(
                onTap: () async {
                  await _selectDate(context, controller);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih periode';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r), // Rounded corners
                    borderSide:
                        const BorderSide(color: GFColors.DARK), // Border color
                  ),
                  labelText: 'Periode',
                  suffixIcon: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // added line
                    mainAxisSize: MainAxisSize.min, // added line
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          await _selectDate(context, controller);
                        },
                      ),
                    ],
                  ),
                ),
                controller: controller.dateRangeController,
                readOnly: true,
              ),
            ),
          ),
          SizedBox(
            height: 620.r,
            child: _graphTableTab(context, controller),
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context, VNotchController controller) async {
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
      if (start.year == end.year &&
          start.month == end.month &&
          start.day == end.day) {
        controller.dateRangeController.text =
            AppConstants().dateFormatID.format(picked.start);
      } else {
        controller.dateRangeController.text =
            '${AppConstants().dateFormatID.format(picked.start)} - ${AppConstants().dateFormatID.format(picked.end)}';
      }

      await controller.getData();
    }
  }

  _graphTableTab(BuildContext context, VNotchController controller) {
    return DynamicTabBarWidget(
      // padding: EdgeInsets.all(8.r),
      indicatorSize: TabBarIndicatorSize.tab,
      onTap: (index) {
        controller.changeGrapTabIndex(index);
      },
      dynamicTabs: [
        TabData(
          index: 0,
          title: const Tab(child: Center(child: Text('GRAFIK'))),
          content: _sensorTabs(context, controller),
        ),
        TabData(
          index: 1,
          title: const Tab(child: Text('TABLE')),
          content: _tableTab(context, controller),
        ),
      ],
      // optional properties :-----------------------------
      isScrollable: false,
      onTabControllerUpdated: (controller) {
        debugPrint("onTabControllerUpdated");
      },
      onTabChanged: (index) {
        debugPrint("Tab changed: $index");
      },
      onAddTabMoveTo: MoveToTab.last,
      // onAddTabMoveToIndex: tabs.length - 1, // Random().nextInt(tabs.length);
      // backIcon: Icon(Icons.keyboard_double_arrow_left),
      // nextIcon: Icon(Icons.keyboard_double_arrow_right),
      showBackIcon: false,
      showNextIcon: false,
      // indicator: const BoxDecoration(),
      // leading: Tooltip(
      //   message: 'Add your desired Leading widget here',
      //   child: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.more_horiz_rounded),
      //   ),
      // ),
      // trailing: Tooltip(
      //   message: 'Add your desired Trailing widget here',
      //   child: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.more_horiz_rounded),
      //   ),
      // ),
    );
  }

  _sensorTabs(BuildContext context, VNotchController controller) {
    List<String> sensors = ['TMA', 'Debit', 'Baterai'];
    return DynamicTabBarWidget(
      padding: EdgeInsets.all(8.r),
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.start,
      onTap: (index) {
        controller.changeSensorTabIndex(index);
      },
      dynamicTabs: [
        for (int i = 0; i < sensors.length; i++)
          TabData(
            index: i,
            title: Tab(
              child: Obx(
                () => Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: controller.selectedSensorIndex.value == i
                            ? Colors.blue
                            : Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    sensors[i],
                    style: TextStyle(
                      color: controller.selectedSensorIndex.value == i
                          ? Colors.blue
                          : GFColors.DARK,
                    ),
                  ),
                ),
              ),
            ),
            content: switch (i) {
              0 => _tmaChart(context, controller),
              1 => _debitChart(context, controller),
              2 => _batteryChart(context, controller),
              int() => _tmaChart(context, controller),
            },
          ),
      ],
      // optional properties :-----------------------------
      isScrollable: true,
      onTabControllerUpdated: (controller) {
        debugPrint("onTabControllerUpdated");
      },
      onTabChanged: (index) {
        debugPrint("Tab changed: $index");
      },
      onAddTabMoveTo: MoveToTab.last,
      // onAddTabMoveToIndex: tabs.length - 1, // Random().nextInt(tabs.length);
      // backIcon: Icon(Icons.keyboard_double_arrow_left),
      // nextIcon: Icon(Icons.keyboard_double_arrow_right),
      showBackIcon: false,
      showNextIcon: false,
      indicator: const BoxDecoration(),
      // leading: Tooltip(
      //   message: 'Add your desired Leading widget here',
      //   child: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.more_horiz_rounded),
      //   ),
      // ),
      // trailing: Tooltip(
      //   message: 'Add your desired Trailing widget here',
      //   child: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.more_horiz_rounded),
      //   ),
      // ),
    );
  }

  _batteryChart(BuildContext context, VNotchController controller) {
    return FutureBuilder(
      future: controller.getChartData(),
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
            List<VNotchModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<VNotchController>(
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
                            title: AxisTitle(text: 'Baterai (Volt)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Baterai',
                          ),
                          tooltipBehavior: TooltipBehavior(enable: false),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              color:
                                  Colors.white, // Color of the trackball marker
                            ),
                            // tooltipSettings: const InteractiveTooltip(
                            //   enable: true,
                            //   color: Colors.green, // Tooltip background color
                            //   textStyle: TextStyle(color: Colors.white), // Tooltip text color
                            // ),
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
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                          color: Colors.blue,
                                        ))),
                                        padding: EdgeInsets.all(8.r),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Baterai : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)",
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
                          series: <CartesianSeries<VNotchModel, DateTime>>[
                            FastLineSeries<VNotchModel, DateTime>(
                              color: const Color(0xFFFF9800),
                              markerSettings: MarkerSettings(
                                  color: Colors.orange[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (VNotchModel data, _) =>
                                  data.readingAt,
                              yValueMapper: (VNotchModel data, _) =>
                                  data.battery ?? 0,
                              name: 'Baterai',
                            ),
                          ],
                        ),
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

  Widget _tmaChart(BuildContext context, VNotchController controller) {
    return FutureBuilder(
      future: controller.getChartData(),
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
            List<VNotchModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<VNotchController>(
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
                              title: AxisTitle(text: 'TMA (cm)'),
                            ),
                            title: ChartTitle(
                              textStyle: TextStyle(
                                  height: 2.r,
                                  fontSize: 14.r,
                                  fontWeight: FontWeight.bold),
                              alignment: ChartAlignment.center,
                              text: 'Grafik Tinggi Muka Air BSH-V-NOTCH',
                            ),
                            tooltipBehavior: TooltipBehavior(enable: false),
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
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                            color: Colors.blue,
                                          ))),
                                          padding: EdgeInsets.all(8.r),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "TMA : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (cm)",
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
                              AreaSeries<VNotchModel, DateTime>(
                                borderDrawMode: BorderDrawMode.top,
                                markerSettings: const MarkerSettings(
                                    color: Colors.white,
                                    // isVisible: true,
                                    // Marker shape is set to diamond
                                    shape: DataMarkerType.circle),
                                dataSource: listData,
                                xValueMapper: (VNotchModel data, _) =>
                                    data.readingAt,
                                yValueMapper: (VNotchModel data, _) =>
                                    data.waterLevel,
                                name: 'TMA',
                                borderColor: const Color(0xFF2CAFFE),
                                borderWidth: 2.r,
                                color: const Color(0xFF2CAFFE),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF2CAFFE).withOpacity(0.5),
                                    Colors.white,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
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

  Widget _debitChart(BuildContext context, VNotchController controller) {
    return FutureBuilder(
      future: controller.getChartData(),
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
            List<VNotchModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<VNotchController>(
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
                              title: AxisTitle(text: 'TMA (lt/d)'),
                            ),
                            title: ChartTitle(
                              textStyle: TextStyle(
                                  height: 2.r,
                                  fontSize: 14.r,
                                  fontWeight: FontWeight.bold),
                              alignment: ChartAlignment.center,
                              text: 'Grafik Debit',
                            ),
                            tooltipBehavior: TooltipBehavior(enable: false),
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
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                            color: Colors.blue,
                                          ))),
                                          padding: EdgeInsets.all(8.r),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "TMA : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (lt/d)",
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
                              AreaSeries<VNotchModel, DateTime>(
                                borderDrawMode: BorderDrawMode.top,
                                markerSettings: const MarkerSettings(
                                    color: Colors.white,
                                    // isVisible: true,
                                    // Marker shape is set to diamond
                                    shape: DataMarkerType.circle),
                                dataSource: listData,
                                xValueMapper: (VNotchModel data, _) =>
                                    data.readingAt,
                                yValueMapper: (VNotchModel data, _) =>
                                    data.debit,
                                name: 'TMA',
                                borderColor: const Color(0xFF2CAFFE),
                                borderWidth: 2.r,
                                color: const Color(0xFF2CAFFE),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF2CAFFE).withOpacity(0.5),
                                    Colors.white,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
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

  Widget _tableTab(BuildContext context, VNotchController controller) {
    return FutureBuilder(
      future: controller.getTableDataSource(),
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
            TableDataSource ds = snapshot.data as TableDataSource;
            return GetBuilder<VNotchController>(
              id: 'table',
              builder: (controller) {
                return SingleChildScrollView(
                  child: GFCard(
                    margin: EdgeInsets.all(10.r),
                    color: GFColors.WHITE,
                    padding: EdgeInsets.zero,
                    content: Column(
                      children: [
                        SizedBox(
                          height: (AppConstants.dataRowHeight *
                                  controller.rowsPerPage) +
                              50.r,
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: GFColors.LIGHT,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: SfDataGrid(
                                headerRowHeight: 50.r,
                                rowHeight: AppConstants.dataRowHeight,
                                source: ds,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 140.r,
                                      columnName: 'readingAt',
                                      label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: const Text('Waktu',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80.r,
                                      columnName: 'hourMinuteFormat',
                                      label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: const Text('Jam',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'waterLevel',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'TMA ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: '(cm)',
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
                                    columnName: 'debit',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Debit ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: '(lt/d)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                      minimumWidth: 140.r,
                                      columnName: 'changeValue',
                                      label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: const Text('Perubahan',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80.r,
                                      columnName: 'warningStatus',
                                      label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: const Text('Status',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'battery',
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
                                                text: '(volt)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
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
                        SizedBox(
                          height: 10.r,
                        ),
                        SfDataPager(
                          delegate: ds,
                          pageCount: controller.listModel.isNotEmpty
                              ? (controller.listModel.length /
                                  controller.rowsPerPage)
                              : 1,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
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
