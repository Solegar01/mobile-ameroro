import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/robotic_total_station/controllers/robotic_total_station_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/robotic_total_station/models/robotic_total_station_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RoboticTotalStationView extends StatelessWidget {
  final RoboticTotalStationController controller =
      Get.find<RoboticTotalStationController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<RoboticTotalStationController>(
                builder: (controller) => const Text(
                  'ROBOTIC TOTAL STATION (RTS)',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              actions: [],
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

  _detail(BuildContext context, RoboticTotalStationController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            height: 650,
            child: _graphTableTab(context, controller),
          ),
        ],
      ),
    );
  }

  _loader(BuildContext context, RoboticTotalStationController controller) {
    return SizedBox(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                height: 650,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    SingleChildScrollView(
                      child: GFShimmer(
                        mainColor: Colors.grey[300]!,
                        secondaryColor: Colors.grey[100]!,
                        child: Container(
                          height: 405,
                          margin: EdgeInsets.all(10),
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
                          height: 405,
                          margin: EdgeInsets.all(10),
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

  _selectDate(
      BuildContext context, RoboticTotalStationController controller) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
      initialDateRange: controller.selectedDateRange.value,
    );
    if (picked != null) {
      controller.selectedDateRange.value = picked;
      controller.dateRangeController.text =
          '${AppConstants().dateFormatID.format(picked.start)} - ${AppConstants().dateFormatID.format(picked.end)}';
      await controller.getData();
    }
  }

  _graphTableTab(
      BuildContext context, RoboticTotalStationController controller) {
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

  _sensorTabs(BuildContext context, RoboticTotalStationController controller) {
    var sensors = controller.sensors;

    return Column(
      children: [
        TabBar(
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.only(top: 10),
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
                    padding: EdgeInsets.all(8),
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
        return _sumbuZChart(context, controller);
      case 1:
        return _directionChart(context, controller);
      default:
        return _sumbuZChart(context, controller);
    }
  }

  _directionChart(
      BuildContext context, RoboticTotalStationController controller) {
    return FutureBuilder(
      future: controller.getChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                height: 350,
                margin: EdgeInsets.all(10),
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
                margin: EdgeInsets.all(10),
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
            List<RoboticTotalStationModel> listData =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<RoboticTotalStationController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: EdgeInsets.all(10),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          legend: const Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text:
                                'Grafik Robotic Total Station - Pergeseran Arah',
                          ),
                          plotAreaBorderWidth: 1,
                          // Primary X-Axis
                          primaryXAxis: const NumericAxis(
                            minimum: -6,
                            maximum: 6,
                            interval: 2,
                            plotBands: <PlotBand>[
                              PlotBand(
                                start: 0,
                                end: 0,
                                borderWidth: 2,
                                borderColor:
                                    Colors.red, // Vertical line for X-axis
                              ),
                            ],
                          ),
                          // Primary Y-Axis
                          primaryYAxis: const NumericAxis(
                            minimum: -6,
                            maximum: 6,
                            interval: 2,
                            plotBands: <PlotBand>[
                              PlotBand(
                                start: 0,
                                end: 0,
                                borderWidth: 2,
                                borderColor:
                                    Colors.blue, // Horizontal line for Y-axis
                              ),
                            ],
                          ),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            builder: (dynamic data,
                                dynamic point,
                                dynamic series,
                                int pointIndex,
                                int seriesIndex) {
                              final cColor = series.color;
                              final DateTime date = data?.readingAt;
                              final String formattedDate =
                                  AppConstants().dateTimeFormatID.format(date);
                              return SingleChildScrollView(
                                child: Container(
                                  width: 150,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: GFColors.DARK),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            series.name.toString(),
                                            style: const TextStyle(
                                                color: GFColors.WHITE),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: 1,
                                        color: GFColors.WHITE,
                                      ),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                            color: GFColors.WHITE),
                                      ),
                                      Divider(
                                        height: 1,
                                        color: GFColors.WHITE,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'dx : ${AppConstants().numFormat.format(point?.x ?? 0)}',
                                              style: const TextStyle(
                                                  color: GFColors.WHITE),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'dy : ${AppConstants().numFormat.format(point?.y ?? 0)}',
                                              style: const TextStyle(
                                                  color: GFColors.WHITE),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              color: GFColors.WHITE,
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              textStyle: TextStyle(
                                  color: Colors.white), // Tooltip text color
                            ),
                            activationMode: ActivationMode.singleTap,
                            enable: true,
                            builder: (BuildContext context,
                                TrackballDetails trackballDetails) {
                              final cColor = trackballDetails.series.color;
                              final name =
                                  trackballDetails.series.name.toString();
                              int index = trackballDetails.pointIndex ?? 0;
                              final data =
                                  trackballDetails.series.dataSource[index]
                                      as RoboticTotalStationModel;
                              final String formattedDate = AppConstants()
                                  .dateTimeFormatID
                                  .format(data.readingAt!);
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: cColor,
                                        ))),
                                        child: Column(
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              formattedDate,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "dx : ${AppConstants().numFormat.format(trackballDetails.point?.x ?? 0)}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "dy : ${AppConstants().numFormat.format(trackballDetails.point?.y ?? 0)}",
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
                          // Data Series
                          series: _chartSeries(listData, 'scatter'),
                          // Annotations for Compass Directions
                          annotations: <CartesianChartAnnotation>[
                            CartesianChartAnnotation(
                              widget: Text(
                                'UTARA',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              coordinateUnit: CoordinateUnit
                                  .point, // Use 'point' for data coordinates
                              region: AnnotationRegion.chart,
                              x: 0,
                              y: 5, // Adjusted within axis range
                              horizontalAlignment: ChartAlignment.center,
                            ),
                            CartesianChartAnnotation(
                              widget: Text(
                                'SELATAN',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              coordinateUnit: CoordinateUnit.point,
                              region: AnnotationRegion.chart,
                              x: 0,
                              y: -5, // Adjusted within axis range
                            ),
                            CartesianChartAnnotation(
                              widget: Text(
                                'TIMUR',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              coordinateUnit: CoordinateUnit.point,
                              region: AnnotationRegion.chart,
                              x: 5, // Adjusted within axis range
                              y: 0,
                            ),
                            CartesianChartAnnotation(
                              widget: Text(
                                'BARAT',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              coordinateUnit: CoordinateUnit.point,
                              region: AnnotationRegion.chart,
                              x: -5, // Adjusted within axis range
                              y: 0,
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
                margin: EdgeInsets.all(10),
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
            margin: EdgeInsets.all(10),
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

  Widget _sumbuZChart(
      BuildContext context, RoboticTotalStationController controller) {
    return FutureBuilder(
      future: controller.getChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                height: 350,
                margin: EdgeInsets.all(10),
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
                margin: EdgeInsets.all(10),
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
            List<RoboticTotalStationModel> listData =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<RoboticTotalStationController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: EdgeInsets.all(10),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          legend: const Legend(
                              isVisible: true, position: LegendPosition.bottom),
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
                            title: AxisTitle(text: 'Perubahan Sumbu Z'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text:
                                'Grafik Robotic Total Station - Perubahan Sumbu Z',
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
                                return Container(
                                    height: 60,
                                    width: 150,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: GFColors.DARK),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: GFColors.WHITE),
                                        ),
                                        Divider(
                                          height: 1,
                                          color: GFColors.WHITE,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              '${series.name.toString()} : ${AppConstants().numFormat.format(point?.y)}',
                                              style: const TextStyle(
                                                  color: GFColors.WHITE),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ));
                              }),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              color:
                                  Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true, // Tooltip background color
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
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                          color: Colors.blue,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "TMA : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)",
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
                          series: _chartSeries(listData, 'line'),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return SingleChildScrollView(
              child: GFCard(
                margin: EdgeInsets.all(10),
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
            margin: EdgeInsets.all(10),
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

  _chartSeries(List<RoboticTotalStationModel> listData, String type) {
    List<CartesianSeries> charts = List.empty(growable: true);
    var listStn1 =
        listData.where((x) => x.point!.toLowerCase() == 'stn1').toList();
    var listRef1 =
        listData.where((x) => x.point!.toLowerCase() == 'ref1').toList();
    var listRef2 =
        listData.where((x) => x.point!.toLowerCase() == 'ref2').toList();
    var listRef3 =
        listData.where((x) => x.point!.toLowerCase() == 'ref3').toList();
    var listPm1 =
        listData.where((x) => x.point!.toLowerCase() == 'pm1').toList();
    var listPm2 =
        listData.where((x) => x.point!.toLowerCase() == 'pm2').toList();
    var listPm3 =
        listData.where((x) => x.point!.toLowerCase() == 'pm3').toList();
    var listPm4 =
        listData.where((x) => x.point!.toLowerCase() == 'pm4').toList();
    var listPm5 =
        listData.where((x) => x.point!.toLowerCase() == 'pm5').toList();
    var listPm6 =
        listData.where((x) => x.point!.toLowerCase() == 'pm6').toList();
    var listPm7 =
        listData.where((x) => x.point!.toLowerCase() == 'pm7').toList();
    var listPm8 =
        listData.where((x) => x.point!.toLowerCase() == 'pm8').toList();
    var listPm9 =
        listData.where((x) => x.point!.toLowerCase() == 'pm9').toList();
    var listPm10 =
        listData.where((x) => x.point!.toLowerCase() == 'pm10').toList();
    var listPm11 =
        listData.where((x) => x.point!.toLowerCase() == 'pm11').toList();
    var listPm12 =
        listData.where((x) => x.point!.toLowerCase() == 'pm12').toList();
    var listPm13 =
        listData.where((x) => x.point!.toLowerCase() == 'pm13').toList();
    var listPm14 =
        listData.where((x) => x.point!.toLowerCase() == 'pm14').toList();
    var listPm15 =
        listData.where((x) => x.point!.toLowerCase() == 'pm15').toList();
    var listPm16 =
        listData.where((x) => x.point!.toLowerCase() == 'pm16').toList();
    var listPm17 =
        listData.where((x) => x.point!.toLowerCase() == 'pm17').toList();
    var listPm18 =
        listData.where((x) => x.point!.toLowerCase() == 'pm18').toList();
    var listPm19 =
        listData.where((x) => x.point!.toLowerCase() == 'pm19').toList();
    var listPm20 =
        listData.where((x) => x.point!.toLowerCase() == 'pm20').toList();
    if (listStn1.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listStn1);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listStn1);
        charts.add(chart);
      }
    }
    if (listRef1.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listRef1);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listRef1);
        charts.add(chart);
      }
    }
    if (listRef2.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listRef2);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listRef2);
        charts.add(chart);
      }
    }
    if (listRef3.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listRef3);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listRef3);
        charts.add(chart);
      }
    }
    if (listPm1.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm1);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm1);
        charts.add(chart);
      }
    }
    if (listPm2.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm2);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm2);
        charts.add(chart);
      }
    }
    if (listPm3.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm3);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm3);
        charts.add(chart);
      }
    }
    if (listPm4.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm4);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm4);
        charts.add(chart);
      }
    }
    if (listPm5.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm5);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm5);
        charts.add(chart);
      }
    }
    if (listPm6.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm6);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm6);
        charts.add(chart);
      }
    }
    if (listPm7.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm7);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm7);
        charts.add(chart);
      }
    }
    if (listPm8.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm8);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm8);
        charts.add(chart);
      }
    }
    if (listPm9.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm9);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm9);
        charts.add(chart);
      }
    }
    if (listPm10.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm10);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm10);
        charts.add(chart);
      }
    }
    if (listPm11.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm11);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm11);
        charts.add(chart);
      }
    }
    if (listPm12.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm12);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm12);
        charts.add(chart);
      }
    }
    if (listPm13.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm13);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm13);
        charts.add(chart);
      }
    }
    if (listPm14.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm14);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm14);
        charts.add(chart);
      }
    }
    if (listPm15.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm15);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm15);
        charts.add(chart);
      }
    }
    if (listPm16.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm16);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm16);
        charts.add(chart);
      }
    }
    if (listPm17.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm17);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm17);
        charts.add(chart);
      }
    }
    if (listPm18.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm18);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm18);
        charts.add(chart);
      }
    }
    if (listPm19.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm19);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm19);
        charts.add(chart);
      }
    }
    if (listPm20.isNotEmpty) {
      if (type == 'line') {
        var chart = getLineSeries(listPm20);
        charts.add(chart);
      }
      if (type == 'scatter') {
        var chart = getScatterSeries(listPm20);
        charts.add(chart);
      }
    }
    return charts;
  }

  getLineSeries(List<RoboticTotalStationModel> listModel) {
    Color chartColor = Color.fromARGB(
      255, // Full opacity
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
    );
    return LineSeries<RoboticTotalStationModel, DateTime>(
      markerSettings: MarkerSettings(
          color: chartColor,
          isVisible: true,
          shape: switch (listModel.first.point!.toLowerCase()) {
            'stn1' => DataMarkerType.circle,
            'ref1' => DataMarkerType.diamond,
            'ref2' => DataMarkerType.invertedTriangle,
            'ref3' => DataMarkerType.pentagon,
            'pm1' => DataMarkerType.rectangle,
            'pm2' => DataMarkerType.triangle,
            'pm3' => DataMarkerType.circle,
            'pm4' => DataMarkerType.diamond,
            'pm5' => DataMarkerType.invertedTriangle,
            'pm6' => DataMarkerType.pentagon,
            'pm7' => DataMarkerType.rectangle,
            'pm8' => DataMarkerType.triangle,
            'pm9' => DataMarkerType.circle,
            'pm10' => DataMarkerType.diamond,
            'pm11' => DataMarkerType.invertedTriangle,
            'pm12' => DataMarkerType.pentagon,
            'pm13' => DataMarkerType.rectangle,
            'pm14' => DataMarkerType.triangle,
            'pm15' => DataMarkerType.circle,
            'pm16' => DataMarkerType.diamond,
            'pm17' => DataMarkerType.invertedTriangle,
            'pm18' => DataMarkerType.pentagon,
            'pm19' => DataMarkerType.rectangle,
            'pm20' => DataMarkerType.triangle,
            String() => DataMarkerType.circle,
          }),
      dataSource: listModel,
      xValueMapper: (RoboticTotalStationModel data, _) => data.readingAt,
      yValueMapper: (RoboticTotalStationModel data, _) => data.dz ?? 0,
      yAxisName: 'primaryYAxis',
      name: listModel.first.point ?? ' - ',
      color: chartColor,
    );
  }

  getScatterSeries(List<RoboticTotalStationModel> listModel) {
    Color chartColor = Color.fromARGB(
      255, // Full opacity
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
    );
    return ScatterSeries<RoboticTotalStationModel, double>(
      markerSettings: MarkerSettings(
          color: chartColor,
          isVisible: true,
          shape: switch (listModel.first.point!.toLowerCase()) {
            'stn1' => DataMarkerType.circle,
            'ref1' => DataMarkerType.diamond,
            'ref2' => DataMarkerType.invertedTriangle,
            'ref3' => DataMarkerType.pentagon,
            'pm1' => DataMarkerType.rectangle,
            'pm2' => DataMarkerType.triangle,
            'pm3' => DataMarkerType.circle,
            'pm4' => DataMarkerType.diamond,
            'pm5' => DataMarkerType.invertedTriangle,
            'pm6' => DataMarkerType.pentagon,
            'pm7' => DataMarkerType.rectangle,
            'pm8' => DataMarkerType.triangle,
            'pm9' => DataMarkerType.circle,
            'pm10' => DataMarkerType.diamond,
            'pm11' => DataMarkerType.invertedTriangle,
            'pm12' => DataMarkerType.pentagon,
            'pm13' => DataMarkerType.rectangle,
            'pm14' => DataMarkerType.triangle,
            'pm15' => DataMarkerType.circle,
            'pm16' => DataMarkerType.diamond,
            'pm17' => DataMarkerType.invertedTriangle,
            'pm18' => DataMarkerType.pentagon,
            'pm19' => DataMarkerType.rectangle,
            'pm20' => DataMarkerType.triangle,
            String() => DataMarkerType.circle,
          }),
      dataSource: listModel,
      xValueMapper: (RoboticTotalStationModel data, _) => data.dx ?? 0,
      yValueMapper: (RoboticTotalStationModel data, _) => data.dy ?? 0,
      yAxisName: 'primaryYAxis',
      name: listModel.first.point ?? ' - ',
      color: chartColor,
    );
  }

  Widget _tableTab(
      BuildContext context, RoboticTotalStationController controller) {
    return FutureBuilder(
      future: controller.getTableDataSource(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFCard(
              margin: EdgeInsets.all(10),
              color: GFColors.WHITE,
              padding: EdgeInsets.zero,
              content: GFShimmer(
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
              child: GFCard(
                margin: EdgeInsets.all(10),
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
            return GetBuilder<RoboticTotalStationController>(
              id: 'table',
              builder: (controller) {
                return SingleChildScrollView(
                  child: GFCard(
                    margin: EdgeInsets.all(10),
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
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Waktu',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'point',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Point',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'baseE',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Base E',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'baseN',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Base N',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'baseRl',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Base RL',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'easting',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Easting',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'northing',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Northing',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100,
                                    columnName: 'reduceLevel',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Reduce Level',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 80,
                                    columnName: 'de',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'dE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 80,
                                    columnName: 'dn',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'dN',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 80,
                                    columnName: 'drl',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'dRL',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 80,
                                    columnName: 'dx',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'dX',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 80,
                                    columnName: 'dy',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'dY',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 80,
                                    columnName: 'dz',
                                    label: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'dZ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
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
                margin: EdgeInsets.all(10),
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
            margin: EdgeInsets.all(10),
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
