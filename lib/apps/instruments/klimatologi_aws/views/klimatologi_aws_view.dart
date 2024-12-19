import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/controllers/klimatologi_aws_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KlimatologiAwsView extends StatelessWidget {
  final KlimatologiAwsController controller =
      Get.find<KlimatologiAwsController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<KlimatologiAwsController>(
                builder: (controller) => Text(
                  'AWS',
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

  _detail(BuildContext context, KlimatologiAwsController controller) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          _weatherSlider(context, controller),
          Padding(
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
          SizedBox(
            height: 650.r,
            child: _graphTableTab(context, controller),
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context, KlimatologiAwsController controller) async {
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

  _graphTableTab(BuildContext context, KlimatologiAwsController controller) {
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

  _sensorTabs(BuildContext context, KlimatologiAwsController controller) {
    List<String> sensors = [
      'Baterai',
      'Suhu',
      'Kelembaban',
      'Titik Embun',
      'Kecepatan Angin',
      'Radiasi Matahari',
      'Curah Hujan',
      'Tekanan Barometrik'
    ];
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
                    borderRadius: BorderRadius.circular(20.r),
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
              0 => _batteryChart(context, controller),
              1 => _tempChart(context, controller),
              2 => _huChart(context, controller),
              3 => _dewChart(context, controller),
              4 => _wsChart(context, controller),
              5 => _solarChart(context, controller),
              6 => _rainFallChart(context, controller),
              7 => _bpChart(context, controller),
              int() => _batteryChart(context, controller),
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

  _weatherSlider(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getCuacaList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          List<String> loadStr = ['loading...', 'loading...', 'loading...'];
          return GFCarousel(
            items: loadStr.map((load) {
              return GFShimmer(
                mainColor: Colors.grey[100]!,
                secondaryColor: Colors.grey[300]!,
                child: Container(
                  margin: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            autoPlay: false,
            enlargeMainPage: false,
            hasPagination: false,
            passiveIndicator: Colors.grey,
            activeIndicator: Colors.blue,
            autoPlayInterval: const Duration(seconds: 5), // Adjust as needed
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            height: 180.r,
          );
        } else if (snapshot.hasError) {
          return _errorWeather(context);
        } else if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return GFCarousel(
              items: snapshot.data!.map((cuaca) {
                return GFCard(
                  margin: EdgeInsets.all(8.r),
                  padding: EdgeInsets.zero,
                  boxFit: BoxFit.cover,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  elevation: 5.r,
                  content: Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(right: 10.r, left: 10.r),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.r),
                                child: Column(
                                  children: [
                                    _getSvgPic(cuaca.image),
                                    Text(
                                      cuaca.weatherDesc,
                                      style: TextStyle(fontSize: 12.r),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.r),
                                child: Column(
                                  children: [
                                    Text(
                                      AppConstants()
                                          .dateFullDayFormatID
                                          .format(cuaca.localDatetime),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.r),
                                    ),
                                    Text(
                                      '${AppConstants().hourMinuteFormat.format(cuaca.localDatetime)} WIB',
                                      style: TextStyle(fontSize: 12.r),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildWeatherInfoRow(cuaca),
                          Divider(
                            height: 1.r,
                            color: Colors.grey[400],
                          ),
                          _buildAdditionalInfoRow(cuaca),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              autoPlay: true,
              enlargeMainPage: false,
              hasPagination: false,
              passiveIndicator: Colors.grey,
              activeIndicator: Colors.blue,
              autoPlayInterval: const Duration(seconds: 5), // Adjust as needed
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              height: 180.r,
            );
          } else {
            return _errorWeather(context);
          }
        } else {
          return _errorWeather(context);
        }
      },
    );
  }

  _errorWeather(BuildContext context) {
    List<String> errorStr = [
      'Error loading weather data',
      'Error loading weather data',
      'Error loading weather data'
    ];
    return GFCarousel(
      items: errorStr.map((error) {
        return GFCard(
          margin: EdgeInsets.all(8.r),
          padding: EdgeInsets.zero,
          boxFit: BoxFit.cover,
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          elevation: 5.r,
          content: SizedBox(
            height: 150.r,
            width: double.infinity,
            child: Center(
              child: Text(
                error,
              ),
            ),
          ),
        );
      }).toList(),
      autoPlay: false,
      enlargeMainPage: false,
      hasPagination: false,
      passiveIndicator: Colors.grey,
      activeIndicator: Colors.blue,
      autoPlayInterval: const Duration(seconds: 5), // Adjust as needed
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      height: 180.r,
    );
  }

  _buildWeatherInfoRow(cuaca) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherInfoItem(
                Icons.thermostat, '${cuaca.t} \u00B0C', 'Suhu'),
            _buildWeatherInfoItem(
                Icons.water_drop_outlined, '${cuaca.hu} %', 'Kelembaban'),
            _buildWeatherInfoItem(
                FontAwesomeIcons.compass,
                '${cuaca.wdDeg} \u00B0C (${cuaca.wd} → ${cuaca.wdTo})',
                'Arah mata angin'),
          ],
        ),
      ),
    );
  }

  _buildAdditionalInfoRow(cuaca) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherInfoItem(
                FontAwesomeIcons.wind, '${cuaca.ws} m/s', 'Kec. angin'),
            _buildWeatherInfoItem(
                Icons.cloud, '${cuaca.tcc} %', 'Tutupan awan'),
            _buildWeatherInfoItem(
                Icons.remove_red_eye_outlined, cuaca.vsText, 'Jarak pandang'),
          ],
        ),
      ),
    );
  }

  _buildWeatherInfoItem(IconData icon, String data, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20.r),
        SizedBox(width: 5.r),
        Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: data,
                    style: TextStyle(
                        fontSize: 10.r,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10.r),
            ),
          ],
        ),
      ],
    );
  }

  _getSvgPic(String svgUrl) {
    return FutureBuilder<String>(
      future: controller.getSvgPic(svgUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 20.r,
              width: 20.r,
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: 30.r,
            height: 30.r,
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 30.r,
              color: Colors.grey,
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SvgPicture.string(
            snapshot.data!,
            width: 30.r,
            height: 30.r,
            fit: BoxFit.contain,
          );
        } else {
          // Optional fallback if no data is returned but no error
          return SizedBox(
            width: 30.r,
            height: 30.r,
            child: Icon(
              Icons.image,
              size: 30.r,
              color: Colors.grey,
            ),
          );
        }
      },
    );
  }

  _batteryChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                          tooltipBehavior: TooltipBehavior(enable: true),
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
                          series: <CartesianSeries<KlimatologiAwsModel,
                              DateTime>>[
                            FastLineSeries<KlimatologiAwsModel, DateTime>(
                              color: const Color(0xFFFF9800),
                              markerSettings: MarkerSettings(
                                  color: Colors.orange[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiAwsModel data, _) =>
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

  _solarChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                            title: AxisTitle(text: 'Radiasi Matahari (W/m2)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Radiasi Matahari',
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
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
                                  // height: 50.r,
                                  width: 150.r,
                                  padding: EdgeInsets.all(8.r),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(0, 8, 22, 0.75),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Radiasi Matahari : ${NumberFormat('#,##0.00').format(trackballDetails.point?.y)} (W/m2)",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
                          series: <CartesianSeries<KlimatologiAwsModel,
                              DateTime>>[
                            FastLineSeries<KlimatologiAwsModel, DateTime>(
                              color: const Color(0xFFFF9800),
                              markerSettings: MarkerSettings(
                                  color: Colors.orange[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.solar,
                              name: 'Radiasi Matahari',
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

  _tempChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                            isVisible: true,
                            position: LegendPosition.bottom,
                          ),
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
                            title: AxisTitle(text: 'Suhu (\u00B0C)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Suhu',
                          ),
                          tooltipBehavior: TooltipBehavior(enable: false),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              // color: Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color: Colors.black, // Tooltip background color
                              textStyle: TextStyle(
                                  color: Colors.white), // Tooltip text color
                            ),
                            activationMode: ActivationMode.singleTap,
                            enable: true,
                            tooltipDisplayMode:
                                TrackballDisplayMode.groupAllPoints,
                            builder: (BuildContext context,
                                TrackballDetails trackballDetails) {
                              List<CartesianChartPoint> listCharts =
                                  trackballDetails.groupingModeInfo!.points;
                              String dateTime = AppConstants()
                                  .dateTimeFormatID
                                  .format(listCharts.first.x as DateTime);
                              String sMin =
                                  '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} °C';
                              String sMax =
                                  '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} °C';
                              String sAvg = 'N/A';
                              if (listCharts.length > 1) {
                                sAvg =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} °C';
                              }

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
                                          dateTime,
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
                                              'Rentang suhu : $sMin - $sMax',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Rerata suhu : $sAvg',
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
                            RangeAreaSeries<KlimatologiAwsModel, DateTime>(
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              highValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.airtempMax,
                              lowValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.airtempMin,
                              borderColor: const Color(0xFF2CAFFE),
                              borderWidth: 2.r,
                              color: const Color(0xFF2CAFFE),
                              name: 'Rentang Suhu',
                            ),
                            FastLineSeries<KlimatologiAwsModel, DateTime>(
                              color: Colors.blue[900]!,
                              markerSettings: MarkerSettings(
                                  color: Colors.blue[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiAwsModel data, _) {
                                return ((data.airtempMin ?? 0) +
                                        (data.airtempMax ?? 0)) /
                                    2;
                              },
                              name: 'Suhu Rata - Rata',
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

  _huChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                            isVisible: true,
                            position: LegendPosition.bottom,
                          ),
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
                            title: AxisTitle(text: 'Kelembaban (%)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Kelembaban',
                          ),
                          tooltipBehavior: TooltipBehavior(enable: false),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              // color: Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color: Colors.black, // Tooltip background color
                              textStyle: TextStyle(
                                  color: Colors.white), // Tooltip text color
                            ),
                            activationMode: ActivationMode.singleTap,
                            enable: true,
                            tooltipDisplayMode:
                                TrackballDisplayMode.groupAllPoints,
                            builder: (BuildContext context,
                                TrackballDetails trackballDetails) {
                              List<CartesianChartPoint> listCharts =
                                  trackballDetails.groupingModeInfo!.points;
                              String dateTime = AppConstants()
                                  .dateTimeFormatID
                                  .format(listCharts.first.x as DateTime);
                              String sMin =
                                  '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} %';
                              String sMax =
                                  '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} %';
                              String sAvg = 'N/A';
                              if (listCharts.length > 1) {
                                sAvg =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} %';
                              }

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
                                          dateTime,
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
                                              'Rentang kelembaban : $sMin - $sMax',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Rerata kelembaban : $sAvg',
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
                            RangeAreaSeries<KlimatologiAwsModel, DateTime>(
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              highValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.rhMax,
                              lowValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.rhMin,
                              borderColor: const Color(0xFF2CAFFE),
                              borderWidth: 2.r,
                              color: const Color(0xFF2CAFFE),
                              name: 'Rentang Kelembaban',
                            ),
                            FastLineSeries<KlimatologiAwsModel, DateTime>(
                              color: Colors.blue[900]!,
                              markerSettings: MarkerSettings(
                                  color: Colors.blue[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiAwsModel data, _) {
                                return ((data.rhMin ?? 0) + (data.rhMax ?? 0)) /
                                    2;
                              },
                              name: 'Kelembaban Rata - Rata',
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

  _dewChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                            isVisible: true,
                            position: LegendPosition.bottom,
                          ),
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
                            title: AxisTitle(text: 'Titik Embun (°C)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Titik Embun',
                          ),
                          tooltipBehavior: TooltipBehavior(enable: false),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              // color: Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color: Colors.black, // Tooltip background color
                              textStyle: TextStyle(
                                  color: Colors.white), // Tooltip text color
                            ),
                            activationMode: ActivationMode.singleTap,
                            enable: true,
                            tooltipDisplayMode:
                                TrackballDisplayMode.groupAllPoints,
                            builder: (BuildContext context,
                                TrackballDetails trackballDetails) {
                              List<CartesianChartPoint> listCharts =
                                  trackballDetails.groupingModeInfo!.points;
                              String dateTime = AppConstants()
                                  .dateTimeFormatID
                                  .format(listCharts.first.x as DateTime);
                              String sMin =
                                  '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} °C';
                              String sMax =
                                  '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} °C';
                              String sAvg = 'N/A';
                              if (listCharts.length > 1) {
                                sAvg =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} °C';
                              }

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
                                          dateTime,
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
                                              'Rentang titik embun : $sMin - $sMax',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Rerata titik embun : $sAvg',
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
                            RangeAreaSeries<KlimatologiAwsModel, DateTime>(
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              highValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.dewpointMax,
                              lowValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.dewpointMin,
                              borderColor: const Color(0xFF2CAFFE),
                              borderWidth: 2.r,
                              color: const Color(0xFF2CAFFE),
                              name: 'Rentang Titik Embun',
                            ),
                            FastLineSeries<KlimatologiAwsModel, DateTime>(
                              color: Colors.deepPurple[900]!,
                              markerSettings: MarkerSettings(
                                  color: Colors.deepPurple[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiAwsModel data, _) {
                                return ((data.dewpointMin ?? 0) +
                                        (data.dewpointMax ?? 0)) /
                                    2;
                              },
                              name: 'Titik Embun Rata - Rata',
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

  _wsChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                            isVisible: true,
                            position: LegendPosition.bottom,
                          ),
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
                            title: AxisTitle(text: 'Kecepatan Angin (m/s)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Kecepatan Angin',
                          ),
                          tooltipBehavior: TooltipBehavior(enable: false),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              // color: Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color: Colors.black, // Tooltip background color
                              textStyle: TextStyle(
                                  color: Colors.white), // Tooltip text color
                            ),
                            activationMode: ActivationMode.singleTap,
                            enable: true,
                            tooltipDisplayMode:
                                TrackballDisplayMode.groupAllPoints,
                            builder: (BuildContext context,
                                TrackballDetails trackballDetails) {
                              List<CartesianChartPoint> listCharts =
                                  trackballDetails.groupingModeInfo!.points;
                              String dateTime = AppConstants()
                                  .dateTimeFormatID
                                  .format(listCharts.first.x as DateTime);
                              String sMin =
                                  '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} m/s';
                              String sMax =
                                  '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} m/s';
                              String sAvg = 'N/A';
                              if (listCharts.length > 1) {
                                sAvg =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} m/s';
                              }

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
                                          dateTime,
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
                                              'Rentang kec. angin : $sMin - $sMax',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Rerata kec. angin : $sAvg',
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
                            RangeAreaSeries<KlimatologiAwsModel, DateTime>(
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              highValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.wsMax,
                              lowValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.wsMin,
                              borderColor: const Color(0xFF2CAFFE),
                              borderWidth: 2.r,
                              color: const Color(0xFF2CAFFE),
                              name: 'Rentang Kec. Angin',
                            ),
                            FastLineSeries<KlimatologiAwsModel, DateTime>(
                              color: Colors.deepPurple[900]!,
                              markerSettings: MarkerSettings(
                                  color: Colors.deepPurple[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiAwsModel data, _) {
                                return ((data.wsMax ?? 0) + (data.wsMin ?? 0)) /
                                    2;
                              },
                              name: 'Kec. Angin Rata - Rata',
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

  _rainFallChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                          tooltipBehavior: TooltipBehavior(enable: false),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              color:
                                  Colors.white, // Color of the trackball marker
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
                                  // height: 50.r,
                                  width: 150.r,
                                  padding: EdgeInsets.all(8.r),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(0, 8, 22, 0.75),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Curah Hujan : ${NumberFormat('#,##0.00').format(trackballDetails.point?.y)} (mm)",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
                          series: <CartesianSeries<KlimatologiAwsModel,
                              DateTime>>[
                            ColumnSeries<KlimatologiAwsModel, DateTime>(
                              color: Colors.blue[500],
                              markerSettings: MarkerSettings(
                                  color: Colors.blue[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.rainfall,
                              name: 'Curah Hujan',
                              borderRadius: BorderRadius.circular(5),
                              width: 0.9,
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

  _bpChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                            isVisible: true,
                            position: LegendPosition.bottom,
                          ),
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
                            title: AxisTitle(text: 'Tekanan Barometrik (mbar)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2.r,
                                fontSize: 14.r,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Tekanan Barometrik',
                          ),
                          tooltipBehavior: TooltipBehavior(enable: false),
                          trackballBehavior: TrackballBehavior(
                            markerSettings: const TrackballMarkerSettings(
                              markerVisibility: TrackballVisibilityMode
                                  .visible, // Show markers
                              // color: Colors.white, // Color of the trackball marker
                            ),
                            tooltipSettings: const InteractiveTooltip(
                              enable: true,
                              color: Colors.black, // Tooltip background color
                              textStyle: TextStyle(
                                  color: Colors.white), // Tooltip text color
                            ),
                            activationMode: ActivationMode.singleTap,
                            enable: true,
                            tooltipDisplayMode:
                                TrackballDisplayMode.groupAllPoints,
                            builder: (BuildContext context,
                                TrackballDetails trackballDetails) {
                              List<CartesianChartPoint> listCharts =
                                  trackballDetails.groupingModeInfo!.points;
                              String dateTime = AppConstants()
                                  .dateTimeFormatID
                                  .format(listCharts.first.x as DateTime);
                              String sMin =
                                  '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} mbar';
                              String sMax =
                                  '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} mbar';
                              String sAvg = 'N/A';
                              if (listCharts.length > 1) {
                                sAvg =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} mbar';
                              }

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
                                          dateTime,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        width: 250.r,
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
                                            Wrap(
                                              children: [
                                                Text(
                                                  'Rentang tekanan barometrik : $sMin - $sMax',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            Wrap(
                                              children: [
                                                Text(
                                                  'Rerata tekanan barometrik : $sAvg',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
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
                            RangeAreaSeries<KlimatologiAwsModel, DateTime>(
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              highValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.bpMax,
                              lowValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.bpMin,
                              borderColor: const Color(0xFF2CAFFE),
                              borderWidth: 2.r,
                              color: const Color(0xFF2CAFFE),
                              name: 'Rentang Tekanan Barometrik',
                            ),
                            SplineSeries<KlimatologiAwsModel, DateTime>(
                              color: Colors.deepPurple[900]!,
                              markerSettings: MarkerSettings(
                                  color: Colors.deepPurple[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: listData,
                              xValueMapper: (KlimatologiAwsModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiAwsModel data, _) {
                                return ((data.bpMax ?? 0) + (data.bpMin ?? 0)) /
                                    2;
                              },
                              name: 'Tekanan Barometrik Rata - Rata',
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

  Widget _tableTab(BuildContext context, KlimatologiAwsController controller) {
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
            return GetBuilder<KlimatologiAwsController>(
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
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.r),
                                              ),
                                            ),
                                            child: const Text('Waktu',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'record',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Record',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'battery',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Battery',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'airtempMin',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Min',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'airtempMax',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Max',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'rhMin',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Min',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 100.r,
                                        columnName: 'rhMax',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Max',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'dewpointMin',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Min',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'dewpointMax',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Max',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'wsMin',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Min',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80.r,
                                        columnName: 'wsMax',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Max',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 180.r,
                                        columnName: 'solar',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text(
                                                'Radiasi Matahari (W/m²)',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 140.r,
                                        columnName: 'rainfall',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text(
                                                'Curah Hujan (mm)',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 100.r,
                                        columnName: 'bpMin',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Min',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 100.r,
                                        columnName: 'bpMax',
                                        label: Container(
                                            padding: EdgeInsets.all(10.r),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade400, // Border color
                                                width: 1.r, // Border width
                                              ),
                                            ),
                                            child: const Text('Max',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                  ],
                                  stackedHeaderRows: <StackedHeaderRow>[
                                    StackedHeaderRow(cells: [
                                      StackedHeaderCell(
                                          columnNames: [
                                            'airtempMin',
                                            'airtempMax',
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
                                                child: Text('Suhu(°C)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'rhMin',
                                            'rhMax',
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
                                                child: Text('Kelembaban (%)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'dewpointMin',
                                            'dewpointMax',
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
                                                child: Text('Titik Embun(°C)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: [
                                            'wsMin',
                                            'wsMax',
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
                                                child: Text('Kec. Angin (m/s)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))),
                                          )),
                                      StackedHeaderCell(
                                          columnNames: ['bpMin', 'bpMax'],
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
                                                child: Text(
                                                    'Tekanan Barometrik (mbar)',
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
