import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/inklinometer/controllers/inklinometer_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/inklinometer/models/inklinometer_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InklinometerView extends StatelessWidget {
  final InklinometerController controller = Get.find<InklinometerController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<InklinometerController>(
                builder: (controller) => Text(
                  'INKLINOMETER',
                  style: TextStyle(
                    fontSize: 20.r,
                  ),
                ),
              ),
              actions: const [],
            ),
            body: controller.obx(
              (state) => _detail(context, controller),
              onLoading: _loader(context, controller),
              onEmpty: const Text('Empty Data'),
              onError: (error) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(error!)),
              ),
            ),
          ),
        ));
  }

  _detail(BuildContext context, InklinometerController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
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
          SizedBox(
            height: 600.r,
            child: _graphTableTab(context, controller),
          ),
        ],
      ),
    );
  }

  _loader(BuildContext context, InklinometerController controller) {
    return SizedBox(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
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
                height: 600.r,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    SingleChildScrollView(
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
                    ),
                    SingleChildScrollView(
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

  _selectDate(BuildContext context, InklinometerController controller) async {
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

  _graphTableTab(BuildContext context, InklinometerController controller) {
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
              SingleChildScrollView(
                child: Column(
                  children: [
                    _faceAChart(context, controller),
                    _faceAChart(context, controller),
                  ],
                ),
              ),
              _tableTab(context, controller),
            ],
          ),
        ),
      ],
    );
  }

  _faceAChart(BuildContext context, InklinometerController controller) {
    return FutureBuilder(
      future: controller.getGroupedData(),
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
            return GetBuilder<InklinometerController>(
                id: 'grafik',
                builder: (controller) {
                  return SingleChildScrollView(
                    child: GFCard(
                      margin: EdgeInsets.all(10.r),
                      color: GFColors.WHITE,
                      padding: EdgeInsets.zero,
                      content: GetBuilder<InklinometerController>(
                        builder: (controller) {
                          return SizedBox(
                            height: 300.r,
                            child: SfCartesianChart(
                                legend: const Legend(
                                    isVisible: true,
                                    position: LegendPosition.bottom),
                                primaryXAxis: const NumericAxis(
                                  minimum: -75, // Minimum value of the X-axis
                                  maximum: 100, // Maximum value of the X-axis
                                  labelFormat: '{value}',
                                  title: AxisTitle(
                                      text: "Displacement (mm)",
                                      alignment: ChartAlignment.center),
                                ),
                                primaryYAxis: const NumericAxis(
                                  labelFormat: '{value}',
                                  title: AxisTitle(text: 'Depth (m)'),
                                ),
                                title: ChartTitle(
                                  textStyle: TextStyle(
                                      height: 2.r,
                                      fontSize: 14.r,
                                      fontWeight: FontWeight.bold),
                                  alignment: ChartAlignment.center,
                                  text: 'Monitoring Inklinometer',
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
                                        color:
                                            Colors.white), // Tooltip text color
                                  ),
                                  activationMode: ActivationMode.singleTap,
                                  enable: true,
                                  builder: (BuildContext context,
                                      TrackballDetails trackballDetails) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.75),
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        child: Container(
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
                                                "Depth : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (m)",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "Displacement : ${AppConstants().numFormat.format(trackballDetails.point?.x)} (mm)",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
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
                                series: _chartSeries(
                                    context, controller, snapshot.data!)),
                          );
                        },
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

  _chartSeries(BuildContext context, InklinometerController controller,
      RxMap<int, Map<int, Map<int, List<InklinometerModel>>>> listGrpData) {
    List<CartesianSeries> charts = List.empty(growable: true);
    listGrpData.forEach((year, months) {
      months.forEach((month, days) {
        days.forEach((day, dates) {
          var chart = LineSeries<InklinometerModel, double>(
            markerSettings: MarkerSettings(
                color: Color.fromARGB(
                  255, // Full opacity
                  Random().nextInt(256),
                  Random().nextInt(256),
                  Random().nextInt(256),
                ),
                isVisible: true,
                shape: DataMarkerType.circle),
            dataSource: dates,
            xValueMapper: (InklinometerModel data, _) => data.faceAPlus ?? 0,
            yValueMapper: (InklinometerModel data, _) => data.depth ?? 0,
            yAxisName: 'primaryYAxis',
            name: AppConstants().dateFormatID.format(dates.first.readingDate!),
            color: Color.fromARGB(
              255, // Full opacity
              Random().nextInt(256),
              Random().nextInt(256),
              Random().nextInt(256),
            ),
          );
          charts.add(chart);
        });
      });
    });
    return charts;
  }

  Widget _tableTab(BuildContext context, InklinometerController controller) {
    return FutureBuilder(
      future: controller.getTableDataSource(),
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
            TableDataSource ds = snapshot.data as TableDataSource;
            return GetBuilder<InklinometerController>(
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
                                      columnName: 'readingDate',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Tanggal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 80.r,
                                      columnName: 'depth',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Depth',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 80.r,
                                      columnName: 'faceAPlus',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Face A+',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 80.r,
                                      columnName: 'faceAMinus',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Face A-',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 80.r,
                                      columnName: 'faceBPlus',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Face B+',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 80.r,
                                      columnName: 'faceBMinus',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Face B-',
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
