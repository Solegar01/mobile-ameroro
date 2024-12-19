import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/observation_well/controllers/observation_well_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/observation_well/models/observation_well_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ObservationWellView extends StatelessWidget {
  final ObservationWellController controller =
      Get.find<ObservationWellController>();
  final sensorKey = GlobalKey<DropdownSearchState>();
  final _formKey = GlobalKey<FormState>();

  ObservationWellView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<ObservationWellController>(
                builder: (controller) => Text(
                  'OBSERVATION WELL',
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

  _detail(BuildContext context, ObservationWellController controller) {
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownSearch<Map<String, dynamic>>(
                      key: sensorKey,
                      onChanged: (value) async {
                        if (value != null) {
                          controller.selectedSensor.value = value;
                        }
                      },
                      selectedItem:
                          controller.selectedSensor as Map<String, dynamic>,
                      items: (filter, infiniteScrollProps) =>
                          controller.sensors,
                      validator: (value) {
                        if (value!['id'].toString().isEmpty) {
                          return "Required field";
                        }
                        return null;
                      },
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Sensor',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),
                      itemAsString: (Map<String, dynamic> item) =>
                          item['text'] ?? 'Unknown',
                      compareFn: (Map<String, dynamic>? item,
                          Map<String, dynamic>? selectedItem) {
                        return item?['id'] == selectedItem?['id'];
                      },
                      popupProps: const PopupProps.menu(
                        menuProps: MenuProps(backgroundColor: Colors.white),
                        fit: FlexFit.loose,
                        constraints: BoxConstraints(),
                      ),
                    ),
                    SizedBox(
                      height: 10.r,
                    ),
                    TextFormField(
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
                          borderRadius:
                              BorderRadius.circular(5.r), // Rounded corners
                          borderSide: const BorderSide(
                              color: GFColors.DARK), // Border color
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
                    SizedBox(
                      height: 10.r,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Validate form and show a message if valid
                        if (_formKey.currentState?.validate() ?? false) {
                          await controller.getData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GFColors.WHITE,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue),
                          borderRadius:
                              BorderRadius.circular(30.r), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 10.r),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Tampilkan',
                            style: TextStyle(
                              fontSize: 16.r,
                              color: Colors.blue,
                            ),
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
          Expanded(
            child: DefaultTabController(
              length: 2, // Jumlah tab
              child: Column(
                children: [
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'GRAFIK',
                              selectionColor: context.iconColor,
                            )
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TABEL',
                              selectionColor: context.iconColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 600.r,
                    child: TabBarView(
                      children: [
                        _chartTab(context, controller),
                        _tableTab(context, controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selectDate(
      BuildContext context, ObservationWellController controller) async {
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
    }
  }

  Widget _chartTab(BuildContext context, ObservationWellController controller) {
    return FutureBuilder(
      future: controller.getDataModel(),
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
            ObservationWellModel model = ObservationWellModel(
                listIntake: [], listRainFall: [], listObservationWell: []);
            if (snapshot.data != null) {
              model = snapshot.data!;
            }
            return GetBuilder<ObservationWellController>(
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
                            title: AxisTitle(text: 'TMA (mdpl)'),
                          ),
                          axes: [
                            NumericAxis(
                              title: const AxisTitle(text: 'Curah Hujan (mm)'),
                              labelFormat: '{value}',
                              name: 'InvertedAxis',
                              opposedPosition: true,
                              isInversed: true,
                              majorGridLines: MajorGridLines(width: 0.r),
                            )
                          ],
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Tinggi Muka Air &  Curah Hujan',
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              color:
                                  Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color: Colors.green, // Tooltip background color
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
                                              (trackballDetails.seriesIndex ==
                                                      0)
                                                  ? "TMA : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                  : (trackballDetails
                                                              .seriesIndex ==
                                                          1)
                                                      ? "Curah Hujan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)"
                                                      : (trackballDetails
                                                                  .seriesIndex ==
                                                              2)
                                                          ? "TMA OW.1: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                          : (trackballDetails
                                                                      .seriesIndex ==
                                                                  3)
                                                              ? "TMA OW.2: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                              : (trackballDetails
                                                                          .seriesIndex ==
                                                                      4)
                                                                  ? "TMA OW.3: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                  : (trackballDetails
                                                                              .seriesIndex ==
                                                                          5)
                                                                      ? "TMA OW.4: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                      : (trackballDetails.seriesIndex ==
                                                                              6)
                                                                          ? "TMA OW.5: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                          : (trackballDetails.seriesIndex == 7)
                                                                              ? "TMA OW.6: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                              : (trackballDetails.seriesIndex == 8)
                                                                                  ? "TMA OW.7: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                                  : (trackballDetails.seriesIndex == 9)
                                                                                      ? "TMA OW.8: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                                      : "TMA : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)",
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
                            AreaSeries<Intake, DateTime>(
                              borderColor: Colors.blue[700]!,
                              borderDrawMode: BorderDrawMode.top,
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listIntake,
                              xValueMapper: (Intake data, _) =>
                                  data.readingDate,
                              yValueMapper: (Intake data, _) =>
                                  data.waterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA',
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
                            ColumnSeries<RainFall, DateTime>(
                              color: Colors.green[500],
                              markerSettings: MarkerSettings(
                                  color: Colors.green[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listRainFall,
                              xValueMapper: (RainFall data, _) =>
                                  data.readingDate,
                              yValueMapper: (RainFall data, _) =>
                                  data.curahHujan ?? 0,
                              yAxisName: 'InvertedAxis',
                              name: 'Curah Hujan',
                              borderRadius: BorderRadius.circular(5.r),
                              width: 0.5.r,
                            ),
                            LineSeries<ObservationWell, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listObservationWell ?? [],
                              xValueMapper: (ObservationWell data, _) =>
                                  data.readingDate,
                              yValueMapper: (ObservationWell data, _) =>
                                  data.sensorOw1Elevasi ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OW.1',
                              color: GFColors.DANGER,
                            ),
                            LineSeries<ObservationWell, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listObservationWell ?? [],
                              xValueMapper: (ObservationWell data, _) =>
                                  data.readingDate,
                              yValueMapper: (ObservationWell data, _) =>
                                  data.sensorOw2Elevasi ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OW.2',
                              color: GFColors.WARNING,
                            ),
                            LineSeries<ObservationWell, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listObservationWell ?? [],
                              xValueMapper: (ObservationWell data, _) =>
                                  data.readingDate,
                              yValueMapper: (ObservationWell data, _) =>
                                  data.sensorOw3Elevasi ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OW.3',
                              color: GFColors.SUCCESS,
                            ),
                            LineSeries<ObservationWell, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listObservationWell ?? [],
                              xValueMapper: (ObservationWell data, _) =>
                                  data.readingDate,
                              yValueMapper: (ObservationWell data, _) =>
                                  data.sensorOw4Elevasi ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OW.4',
                              color: GFColors.INFO,
                            ),
                            LineSeries<ObservationWell, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listObservationWell ?? [],
                              xValueMapper: (ObservationWell data, _) =>
                                  data.readingDate,
                              yValueMapper: (ObservationWell data, _) =>
                                  data.sensorOw5Elevasi ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OW.5',
                              color: GFColors.ALT,
                            ),
                            LineSeries<ObservationWell, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listObservationWell ?? [],
                              xValueMapper: (ObservationWell data, _) =>
                                  data.readingDate,
                              yValueMapper: (ObservationWell data, _) =>
                                  data.sensorOw6Elevasi ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OW.6',
                              color: Colors.amber,
                            ),
                            LineSeries<ObservationWell, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listObservationWell ?? [],
                              xValueMapper: (ObservationWell data, _) =>
                                  data.readingDate,
                              yValueMapper: (ObservationWell data, _) =>
                                  data.sensorOw7Elevasi ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OW.7',
                              color: Colors.amberAccent,
                            ),
                            LineSeries<ObservationWell, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listObservationWell ?? [],
                              xValueMapper: (ObservationWell data, _) =>
                                  data.readingDate,
                              yValueMapper: (ObservationWell data, _) =>
                                  data.sensorOw8Elevasi ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OW.8',
                              color: Colors.blue,
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

  Widget _tableTab(BuildContext context, ObservationWellController controller) {
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
            return GetBuilder<ObservationWellController>(
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
                                80.r,
                            child: SfDataGridTheme(
                              data: const SfDataGridThemeData(
                                  headerColor: GFColors.LIGHT,
                                  gridLineColor: GFColors.LIGHT),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: SfDataGrid(
                                  headerRowHeight: 40.r,
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
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.r),
                                          ),
                                        ),
                                        child: const Text(
                                          'Tanggal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    //OW1
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw1Pengukuran',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Pengukuran',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' (M)',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw1Elevasi',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Elevasi',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' MAT',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw1Keterangan',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: const Text(
                                          'Keterangan',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    //OW2
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw2Pengukuran',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Pengukuran',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' (M)',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw2Elevasi',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Elevasi',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' MAT',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw2Keterangan',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: const Text(
                                          'Keterangan',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    //OW3
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw3Pengukuran',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Pengukuran',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' (M)',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw3Elevasi',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Elevasi',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' MAT',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw3Keterangan',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: const Text(
                                          'Keterangan',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    //OW4
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw4Pengukuran',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Pengukuran',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' (M)',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw4Elevasi',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Elevasi',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' MAT',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw4Keterangan',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: const Text(
                                          'Keterangan',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    //OW5
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw5Pengukuran',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Pengukuran',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' (M)',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw5Elevasi',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Elevasi',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' MAT',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw5Keterangan',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: const Text(
                                          'Keterangan',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    //OW6
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw6Pengukuran',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Pengukuran',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' (M)',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw6Elevasi',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Elevasi',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' MAT',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw6Keterangan',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: const Text(
                                          'Keterangan',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    //OW7
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw7Pengukuran',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Pengukuran',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' (M)',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw7Elevasi',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Elevasi',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' MAT',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw7Keterangan',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: const Text(
                                          'Keterangan',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    //OW8
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw8Pengukuran',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Pengukuran',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' (M)',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw8Elevasi',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Elevasi',
                                                  style: TextStyle(
                                                      fontSize: 10.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: ' MAT',
                                                  style: TextStyle(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      minimumWidth: 120.r,
                                      columnName: 'sensorOw8Keterangan',
                                      label: Container(
                                        padding: EdgeInsets.all(10.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey.shade400, // Border color
                                            width: 1.r, // Border width
                                          ),
                                        ),
                                        child: const Text(
                                          'Keterangan',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                  stackedHeaderRows: <StackedHeaderRow>[
                                    StackedHeaderRow(cells: [
                                      StackedHeaderCell(
                                          columnNames: [
                                            'sensorOw1Pengukuran',
                                            'sensorOw1Elevasi',
                                            'sensorOw1Keterangan'
                                          ],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Center(
                                                child: Text('OW1',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'sensorOw2Pengukuran',
                                            'sensorOw2Elevasi',
                                            'sensorOw2Keterangan'
                                          ],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Center(
                                                child: Text('OW2',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'sensorOw3Pengukuran',
                                            'sensorOw3Elevasi',
                                            'sensorOw3Keterangan'
                                          ],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Center(
                                                child: Text('OW3',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'sensorOw4Pengukuran',
                                            'sensorOw4Elevasi',
                                            'sensorOw4Keterangan'
                                          ],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Center(
                                                child: Text('OW4',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'sensorOw5Pengukuran',
                                            'sensorOw5Elevasi',
                                            'sensorOw5Keterangan'
                                          ],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Center(
                                                child: Text('OW5',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'sensorOw6Pengukuran',
                                            'sensorOw6Elevasi',
                                            'sensorOw6Keterangan'
                                          ],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Center(
                                                child: Text('OW6',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'sensorOw7Pengukuran',
                                            'sensorOw7Elevasi',
                                            'sensorOw7Keterangan'
                                          ],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Center(
                                                child: Text('OW7',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'sensorOw8Pengukuran',
                                            'sensorOw8Elevasi',
                                            'sensorOw8Keterangan'
                                          ],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.r),
                                              ),
                                            ),
                                            child: const Center(
                                                child: Text('OW8',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                    ])
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