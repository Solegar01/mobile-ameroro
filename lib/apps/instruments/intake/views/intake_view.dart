import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/controllers/intake_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/models/intake_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/models/station_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';
import 'package:mobile_ameroro_app/helpers/date_convertion.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class IntakeView extends StatelessWidget {
  final IntakeController controller = Get.find<IntakeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntakeController>(builder: (controller) {
      return PopScope(
          canPop: true,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: GFColors.WHITE,
                title: Text(
                  'BSH-INTAKE',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Get.dialog(
                            detailPos(context, controller.station.value));
                      },
                      icon: const Icon(
                        Icons.info_outlined,
                      ))
                ],
              ),
              body: controller.obx(
                (state) => _detail(context, controller),
                onLoading: _loader(context, controller),
                onEmpty: const Text('Tidak ada data yang tersedia'),
                onError: (error) => Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                      child:
                          Text(error ?? 'Terjadi kesalahan saat memuat data')),
                ),
              ),
            ),
          ));
    });
  }

  _loader(BuildContext context, IntakeController controller) {
    return ListView(
      children: [
        GFShimmer(
          mainColor: Colors.grey[300]!,
          secondaryColor: Colors.grey[100]!,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: GFColors.WHITE,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppConfig.primaryColor, width: 1),
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
                        Text('', style: TextStyle(fontSize: 12)),
                        Text(
                          '',
                          style: TextStyle(fontSize: AppConfig.fontSize),
                        ),
                        Text(
                          '',
                          style: TextStyle(
                              fontSize: AppConfig.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
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
              SizedBox(height: 15),
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
              SizedBox(height: 15),
              GFShimmer(
                mainColor: Colors.grey[300]!,
                secondaryColor: Colors.grey[100]!,
                child: Container(
                  height: 50,
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
                        margin: EdgeInsets.all(10),
                        height: 300,
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
                        margin: EdgeInsets.all(10),
                        height: 300,
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
    );
  }

  _detail(BuildContext context, IntakeController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          _lastDataCard(context, controller),
          _periodAndDropdowns(context, controller),
          _tabBarView(context, controller),
        ],
      ),
    );
  }

  Widget _lastDataCard(BuildContext context, IntakeController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: GFColors.WHITE,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConfig.primaryColor, width: 1),
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
                  Text('DATA TERAKHIR', style: TextStyle(fontSize: 12)),
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
                padding: EdgeInsets.all(8),
                child: _statusContainer(controller),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusContainer(IntakeController controller) {
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
        borderRadius: BorderRadius.all(Radius.circular(5)),
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

  Widget _periodAndDropdowns(
      BuildContext context, IntakeController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(height: 15),
          _dropdowns(controller),
        ],
      ),
    );
  }

  _selectDate(BuildContext context, IntakeController controller) async {
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
      await controller.getData();
    }
  }

  Widget _dropdowns(IntakeController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownSearch<int>(
          onChanged: (value) async {
            controller.selectedHollow.value = value ?? 600;
            controller.updateDisplayedData();
          },
          selectedItem: controller.selectedHollow.value,
          items: (filter, infiniteScrollProps) => controller.hollowJetFilter,
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Bukaan Hollow Jet',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
            ),
          ),
          popupProps: const PopupProps.menu(
            menuProps: MenuProps(backgroundColor: Colors.white),
            fit: FlexFit.loose,
            constraints: BoxConstraints(),
          ),
        ),
        SizedBox(height: 15),
        DropdownSearch<String>(
          selectedItem: controller.selectedHollowPerc.value,
          items: (filter, infiniteScrollProps) =>
              controller.hollowJetPercentFilter,
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: '% Bukaan Hollow Jet',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
            ),
          ),
          popupProps: const PopupProps.menu(
            menuProps: MenuProps(backgroundColor: Colors.white),
            fit: FlexFit.loose,
            constraints: BoxConstraints(),
          ),
          onChanged: (value) async {
            controller.selectedHollowPerc.value = value ?? "0%";
            controller.updateDisplayedData();
          },
        ),
      ],
    );
  }

  Widget _tabBarView(BuildContext context, IntakeController controller) {
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
        SizedBox(
          height: 550,
          child: TabBarView(
            controller: controller.tabController,
            children: [
              _chartTab(context, controller),
              _tableTab(context, controller),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailPos(BuildContext context, Station station) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)), // Tanpa radius
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: GFColors.WHITE,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.63,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: GFColors.INFO.withOpacity(0.75),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
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
              height: 120,
              child: Padding(
                padding: EdgeInsets.all(10),
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
              height: 20,
            ),
            Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 50,
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
              height: 120,
              child: Padding(
                padding: EdgeInsets.all(10),
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
                              width: 18,
                              height: 18,
                              color: StatusLevel.siaga1.color,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            const Text('AWAS BANJIR'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              color: StatusLevel.siaga2.color,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            const Text('SIAGA BANJIR'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              color: StatusLevel.siaga3.color,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            const Text('WASPADA BANJIR'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              color: StatusLevel.normal.color,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            const Text('NORMAL'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              color: StatusLevel.siagakekeringan.color,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            const Text('SIAGA KEKERINGAN'),
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
                            '${station.siaga2 ?? '-'} ${station.siaga2 == null ? '' : 'mdpl'}'),
                        Text(
                            '${station.siaga3 ?? '-'} ${station.siaga3 == null ? '' : 'mdpl'}'),
                        Text(
                            '${station.normal ?? '-'} ${station.normal == null ? '' : 'mdpl'}'),
                        Text(
                            '${station.siagaKekeringan ?? '-'} ${station.siagaKekeringan == null ? '' : 'mdpl'}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                  color: GFColors.LIGHT, borderRadius: BorderRadius.zero),
              child: Center(
                child: Text(
                  'KALIBRASI',
                  style: TextStyle(
                      color: GFColors.DARK,
                      fontSize: AppConfig.fontSize,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('KOREKSI'),
                    Text('${station.koreksi ?? '-'}'),
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

  Widget _chartTab(BuildContext context, IntakeController controller) {
    return FutureBuilder(
      future: controller.getChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: EdgeInsets.all(10),
                height: 300,
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
            List<WaterIntake> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<IntakeController>(
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
                            title: ChartTitle(
                              textStyle: TextStyle(
                                  height: 2,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              alignment: ChartAlignment.center,
                              text: 'Grafik Tinggi Muka Air BSH-INTAKE',
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
                                                '${series.name.toString()} : ${AppConstants().numFormat.format(point?.y)} (mdpl)',
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
                            series: <CartesianSeries>[
                              AreaSeries<WaterIntake, DateTime>(
                                borderDrawMode: BorderDrawMode.top,
                                markerSettings: const MarkerSettings(
                                    color: Colors.white,
                                    // isVisible: true,
                                    // Marker shape is set to diamond
                                    shape: DataMarkerType.circle),
                                dataSource: listData,
                                xValueMapper: (WaterIntake data, _) =>
                                    data.readingAt,
                                yValueMapper: (WaterIntake data, _) =>
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

  Widget _tableTab(BuildContext context, IntakeController controller) {
    return FutureBuilder(
      future: controller.getTableDataSource(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GFShimmer(
              mainColor: Colors.grey[300]!,
              secondaryColor: Colors.grey[100]!,
              child: Container(
                margin: EdgeInsets.all(10),
                height: 300,
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
            return GetBuilder<IntakeController>(
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
                            height: (controller.rowsPerPage *
                                    AppConstants.dataRowHeight) +
                                60,
                            child: SfDataGridTheme(
                              data: const SfDataGridThemeData(
                                  headerColor: GFColors.LIGHT,
                                  gridLineColor: GFColors.LIGHT),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SfDataGrid(
                                  headerRowHeight: 60,
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
                                            child: const Text('Tanggal',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80,
                                        columnName: 'hourMinuteFormat',
                                        label: Container(
                                            padding: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            child: const Text('Jam',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80,
                                        columnName: 'waterLevel',
                                        label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'TMA ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                TextSpan(
                                                    text: '(mdpl)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey))
                                              ],
                                            ),
                                          ),
                                        )),
                                    GridColumn(
                                        minimumWidth: 140,
                                        columnName: 'storageVolume',
                                        label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'Volume Tampungan ',
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
                                        )),
                                    GridColumn(
                                        minimumWidth: 140,
                                        columnName: 'floodArea',
                                        label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'Luas Genangan ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                TextSpan(
                                                    text: '(Ha)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey))
                                              ],
                                            ),
                                          ),
                                        )),
                                    GridColumn(
                                        minimumWidth: 80,
                                        columnName: 'debit',
                                        label: Container(
                                          padding: EdgeInsets.all(10),
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
                                        )),
                                    GridColumn(
                                        minimumWidth: 140,
                                        columnName: 'hollJetVal',
                                        label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'Bukaan Hollow Jet ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                TextSpan(
                                                    text: '(mm)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          ),
                                        )),
                                    GridColumn(
                                        minimumWidth: 140,
                                        columnName: 'hollJetPercVal',
                                        label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '% Bukaan Hollow Jet ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                TextSpan(
                                                    text: '(mm)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          ),
                                        )),
                                    GridColumn(
                                        minimumWidth: 100,
                                        columnName: 'overflow',
                                        label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'Pelimpah ',
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
                                        )),
                                    GridColumn(
                                        minimumWidth: 150,
                                        columnName: 'totalRunoffPlusHollowJet',
                                        label: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        'Total Limpasan + Hollow Jet ',
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
                                        )),
                                    GridColumn(
                                        minimumWidth: 100,
                                        columnName: 'battery',
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
                            height: 10,
                          ),
                          SfDataPager(
                            delegate: ds,
                            pageCount: controller.listIntake.isNotEmpty
                                ? (controller.listIntake.length /
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
