import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
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
                builder: (controller) => const Text(
                  'V-NOTCH',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              actions: const [],
            ),
            body: controller.obx(
              (state) => _detail(context, controller),
              onLoading: _loader(context, controller),
              onEmpty: const Text('Tidak ada data yang tersedia'),
              onError: (error) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(error ?? 'Terjadi kesalahan saat memuat data')),
              ),
            ),
          ),
        ));
  }

  _detail(BuildContext context, VNotchController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
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
                  borderRadius: BorderRadius.circular(5), // Rounded corners
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
          SizedBox(
            height: 620,
            child: _graphTableTab(context, controller),
          ),
        ],
      ),
    );
  }

  _loader(BuildContext context, VNotchController controller) {
    return SizedBox(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GFShimmer(
                  mainColor: Colors.grey[300]!,
                  secondaryColor: Colors.grey[100]!,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          BorderRadius.circular(8), // Optional rounded corners
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
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
              SizedBox(
                height: 550,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    SingleChildScrollView(
                      child: GFShimmer(
                        mainColor: Colors.grey[300]!,
                        secondaryColor: Colors.grey[100]!,
                        child: Container(
                          height: 355,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: GFColors.WHITE,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: GFShimmer(
                        mainColor: Colors.grey[300]!,
                        secondaryColor: Colors.grey[100]!,
                        child: Container(
                          height: 355,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: GFColors.WHITE,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              _sensorTabs(context, controller),
              _tableTab(context, controller),
            ],
          ),
        ),
      ],
    );
  }

  _sensorTabs(BuildContext context, VNotchController controller) {
    var sensors = controller.sensors;

    return Column(
      children: [
        TabBar(
          tabAlignment: TabAlignment.start,
          padding: const EdgeInsets.only(top: 10),
          indicatorColor: Colors.transparent,
          isScrollable: true,
          controller: controller.sensorTabController,
          dividerHeight: 0,
          onTap: (index) {
            controller.selectedSensorIndex.value = index;
          },
          tabs: [
            for (int i = 0; i < sensors.length; i++)
              Tab(
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.selectedSensorIndex.value == i
                            ? AppConfig.primaryColor
                            : GFColors.LIGHT,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      sensors[i],
                      style: TextStyle(
                        color: controller.selectedSensorIndex.value == i
                            ? AppConfig.primaryColor
                            : GFColors.LIGHT,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: controller.sensorTabController,
            children: [
              for (int i = 0; i < sensors.length; i++)
                _getChartByIndex(i, context, controller),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getChartByIndex(int index, BuildContext context, var controller) {
    switch (index) {
      case 0:
        return _tmaChart(context, controller);
      case 1:
        return _debitChart(context, controller);
      case 2:
        return _batteryChart(context, controller);
      default:
        return _tmaChart(context, controller);
    }
  }

  _batteryChart(BuildContext context, VNotchController controller) {
    return FutureBuilder(
      future: controller.getChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: GFColors.WHITE,
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: const EdgeInsets.all(10),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
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
            List<VNotchModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<VNotchController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: const EdgeInsets.all(10),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 300,
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
                          title: const ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
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
                                        padding: const EdgeInsets.all(8),
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
                                        padding: const EdgeInsets.all(8),
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
                margin: const EdgeInsets.all(10),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('Tidak ada data yang tersedia'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: const EdgeInsets.all(10),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('Tidak ada data yang tersedia'),
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
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: GFColors.WHITE,
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: const EdgeInsets.all(10),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
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
            List<VNotchModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<VNotchController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: const EdgeInsets.all(10),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 300,
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
                            title: const ChartTitle(
                              textStyle: TextStyle(
                                  height: 2,
                                  fontSize: 14,
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
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
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
                                          padding: const EdgeInsets.all(8),
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
                                borderWidth: 2,
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
                margin: const EdgeInsets.all(10),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('Tidak ada data yang tersedia'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: const EdgeInsets.all(10),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('Tidak ada data yang tersedia'),
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
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: GFColors.WHITE,
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: const EdgeInsets.all(10),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
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
            List<VNotchModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<VNotchController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: const EdgeInsets.all(10),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 300,
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
                            title: const ChartTitle(
                              textStyle: TextStyle(
                                  height: 2,
                                  fontSize: 14,
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
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
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
                                          padding: const EdgeInsets.all(8),
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
                                borderWidth: 2,
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
                margin: const EdgeInsets.all(10),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('Tidak ada data yang tersedia'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: const EdgeInsets.all(10),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('Tidak ada data yang tersedia'),
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
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: GFColors.WHITE,
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: GFCard(
                margin: const EdgeInsets.all(10),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
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
            TableDataSource ds = snapshot.data as TableDataSource;
            return GetBuilder<VNotchController>(
              id: 'table',
              builder: (controller) {
                return SingleChildScrollView(
                  child: GFCard(
                    margin: const EdgeInsets.all(10),
                    color: GFColors.WHITE,
                    padding: EdgeInsets.zero,
                    content: Column(
                      children: [
                        SizedBox(
                          height: (AppConstants.dataRowHeight *
                                  controller.rowsPerPage) +
                              50,
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: GFColors.LIGHT,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SfDataGrid(
                                headerRowHeight: 50,
                                rowHeight: AppConstants.dataRowHeight,
                                source: ds,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 140,
                                      columnName: 'readingAt',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: const Text('Waktu',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'hourMinuteFormat',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: const Text('Jam',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                    minimumWidth: 80,
                                    columnName: 'waterLevel',
                                    label: Container(
                                      padding: const EdgeInsets.all(10),
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
                                    minimumWidth: 100,
                                    columnName: 'debit',
                                    label: Container(
                                      padding: const EdgeInsets.all(10),
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
                                      minimumWidth: 140,
                                      columnName: 'changeValue',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: const Text('Perubahan',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'warningStatus',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: const Text('Status',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                    minimumWidth: 80,
                                    columnName: 'battery',
                                    label: Container(
                                      padding: const EdgeInsets.all(10),
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
                        const SizedBox(
                          height: 10,
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
                margin: const EdgeInsets.all(10),
                color: GFColors.WHITE,
                padding: EdgeInsets.zero,
                content: SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GFColors.WHITE,
                    ),
                    child: const Center(
                      child: Text('Tidak ada data yang tersedia'),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return SingleChildScrollView(
          child: GFCard(
            margin: const EdgeInsets.all(10),
            color: GFColors.WHITE,
            padding: EdgeInsets.zero,
            content: SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GFColors.WHITE,
                ),
                child: const Center(
                  child: Text('Tidak ada data yang tersedia'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
