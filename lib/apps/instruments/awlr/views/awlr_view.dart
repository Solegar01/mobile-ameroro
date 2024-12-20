import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/controllers/awlr_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlrlist_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/station_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';
import 'package:mobile_ameroro_app/helpers/date_convertion.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AwlrView extends StatelessWidget {
  final AwlrController controller = Get.find<AwlrController>();
  final sensorKey = GlobalKey<DropdownSearchState>();

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
                  child: DropdownSearch<AwlrListModel>(
                    key: sensorKey,
                    onChanged: (value) async {
                      if (value != null &&
                          controller.selectedSensor.value != value) {
                        controller.selectedSensor.value = value;
                        await controller.getData();
                        await controller.getDataStation();
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Required field";
                      }
                      return null;
                    },
                    selectedItem: controller.selectedSensor.value,
                    items: (filter, infiniteScrollProps) =>
                        controller.sensorList,
                    decoratorProps: DropDownDecoratorProps(
                      baseStyle: const TextStyle(
                        color: GFColors.DARK,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: GFColors.DARK),
                        ),
                        hintText: "Select an option",
                        hintStyle: const TextStyle(
                            color: Colors.black), // Hint text color
                        labelStyle:
                            const TextStyle(color: Colors.black), // Label color
                        filled: true,
                        fillColor: GFColors.WHITE,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                      ),
                    ),
                    itemAsString: (AwlrListModel item) => item.name ?? '',
                    compareFn:
                        (AwlrListModel? item, AwlrListModel? selectedItem) {
                      return item?.deviceId == selectedItem?.deviceId;
                    },
                    popupProps: const PopupProps.menu(
                      menuProps: MenuProps(backgroundColor: Colors.white),
                      fit: FlexFit.loose,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.dialog(detailPos(context, controller.station.value));
                    },
                    icon: const Icon(
                      Icons.info_outlined,
                    ),
                  ),
                ],
              ),
              body: controller.obx(
                (state) => _detail(context, controller),
                onLoading: const Center(child: CircularProgressIndicator()),
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
      color: GFColors.WHITE,
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          _lastDataCard(context, controller),
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
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: const BorderSide(color: GFColors.DARK),
                ),
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
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child: Text(
                        'GRAFIK',
                        style: TextStyle(color: context.iconColor),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'TABEL',
                        style: TextStyle(color: context.iconColor),
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
        ],
      ),
    );
  }

  Widget _lastDataCard(BuildContext context, AwlrController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: GFColors.WHITE,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppConfig.primaryColor, width: 1.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('DATA TERAKHIR', style: TextStyle(fontSize: 12.r)),
                  Text(
                    '${controller.station.value.lastReading == null ? '-' : DateFormatter.formatFullDateTimeToLocal(controller.station.value.lastReading!)} WIB',
                    style: TextStyle(fontSize: AppConfig.fontSize),
                  ),
                  Text(
                    'TMA Intake: ${controller.station.value.lastData} ${controller.unit}',
                    style: TextStyle(
                        fontSize: AppConfig.fontSize,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.r),
                child: _statusContainer(controller),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusContainer(AwlrController controller) {
    StatusLevel? statusLevel;
    switch (controller.station.value.warningStatus?.toLowerCase()) {
      case 'normal':
        statusLevel = StatusLevel.normal;
        break;
      case 'siaga1':
        statusLevel = StatusLevel.siaga1;
        break;
      case 'siaga2':
        statusLevel = StatusLevel.siaga2;
        break;
      case 'siaga3':
        statusLevel = StatusLevel.siaga3;
        break;
      default:
    }
    return Container(
      decoration: BoxDecoration(
        color: statusLevel != null
            ? statusLevel.color.withOpacity(0.65)
            : AppConfig.bgLogin.withOpacity(0.65),
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            statusLevel != null ? statusLevel.name : '-',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: AppConfig.fontSize,
                fontWeight: FontWeight.bold,
                color: GFColors.WHITE),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context, AwlrController controller) async {
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

  Widget detailPos(BuildContext context, Station station) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)), // Tanpa radius
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          color: GFColors.WHITE,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.51,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 50.r,
              decoration: BoxDecoration(
                color: GFColors.INFO.withOpacity(0.75),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: Center(
                child: Text(
                  'INFORMASI INSTRUMENT',
                  style: TextStyle(
                    color: GFColors.DARK,
                    fontSize: AppConfig.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 120.r,
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('ID Logger'),
                        Text('Tgl. Pemasangan'),
                        Text('Latitude'),
                        Text('Longitude'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('${station.deviceId}'),
                        Text('${station.installedDate ?? '-'}'),
                        Text('${station.latitude}'),
                        Text('${station.longitude}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.r,
            ),
            Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 50.r,
              decoration: const BoxDecoration(
                  color: GFColors.LIGHT, borderRadius: BorderRadius.zero),
              child: Center(
                child: Text(
                  'STATUS LEVEL',
                  style: TextStyle(
                      color: GFColors.DARK,
                      fontSize: AppConfig.fontSize,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 120.r,
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 18.r,
                              height: 18.r,
                              color: StatusLevel.siaga1.color,
                            ),
                            SizedBox(
                              width: 5.r,
                            ),
                            const Text('Siaga 1'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 18.r,
                              height: 18.r,
                              color: StatusLevel.siaga2.color,
                            ),
                            SizedBox(
                              width: 5.r,
                            ),
                            const Text('Siaga 2'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 18.r,
                              height: 18.r,
                              color: StatusLevel.siaga3.color,
                            ),
                            SizedBox(
                              width: 5.r,
                            ),
                            const Text('Siaga 3'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 18.r,
                              height: 18.r,
                              color: StatusLevel.normal.color,
                            ),
                            SizedBox(
                              width: 5.r,
                            ),
                            const Text('Normal'),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            '${station.siaga1 ?? '-'} ${station.siaga1 == null ? '' : 'mdpl'}'),
                        Text(
                            '${station.siaga2 ?? '-'} ${station.siaga1 == null ? '' : 'mdpl'}'),
                        Text(
                            '${station.siaga3 ?? '-'} ${station.siaga1 == null ? '' : 'mdpl'}'),
                        const Text(''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => {Get.back()},
                child: const Text(
                  'Kembali',
                  style: TextStyle(color: GFColors.DANGER),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _chartTab(BuildContext context, AwlrController controller) {
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
            List<AwlrModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<AwlrController>(
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
                            title: AxisTitle(text: 'TMA (m)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text:
                                'Grafik Tinggi Muka Air ${controller.selectedSensor.value.name}',
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
                                  width: 150.r,
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
                                              '${series.name.toString()} : ${AppConstants().numFormat.format(point?.y)} (m)',
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
                                              "TMA : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (m)",
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
                          series: <CartesianSeries<AwlrModel, DateTime>>[
                            AreaSeries<AwlrModel, DateTime>(
                              borderDrawMode: BorderDrawMode.top,
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (AwlrModel data, _) =>
                                  data.readingAt,
                              yValueMapper: (AwlrModel data, _) =>
                                  data.waterLevel ?? 0,
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

  Widget _tableTab(BuildContext context, AwlrController controller) {
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
            return GetBuilder<AwlrController>(
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
                                            child: const Text('Tanggal',
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
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'TMA ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                TextSpan(
                                                    text: '(m)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey))
                                              ],
                                            ),
                                          ),
                                        )),
                                    GridColumn(
                                      minimumWidth: 80.r,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: '(m',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey)),
                                              TextSpan(
                                                  text: '3',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontFeatures: [
                                                        FontFeature
                                                            .superscripts()
                                                      ])),
                                              TextSpan(
                                                  text: ')',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                        minimumWidth: 100.r,
                                        columnName: 'changeValue',
                                        label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'Perubahan ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                              ],
                                            ),
                                          ),
                                        )),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'warningStatus',
                                        label: Container(
                                          padding: EdgeInsets.all(10.r),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'Status ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                              ],
                                            ),
                                          ),
                                        )),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                TextSpan(
                                                    text: '(volt)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromRGBO(
                                                            158, 158, 158, 1))),
                                              ],
                                            ),
                                          ),
                                        )),
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
                            pageCount: controller.listAwlr.isNotEmpty
                                ? (controller.listAwlr.length /
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
