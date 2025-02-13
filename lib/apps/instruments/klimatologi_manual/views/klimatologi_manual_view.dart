import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/controllers/klimatologi_manual_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/models/klimatologi_manual_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KlimatologiManualView extends StatelessWidget {
  final KlimatologiManualController controller =
      Get.find<KlimatologiManualController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KlimatologiManualController>(builder: (controller) {
      return PopScope(
          canPop: true,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: GFColors.WHITE,
                title: Text(
                  'KLIMATOLOGI MANUAL',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                actions: const [],
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

  _detail(BuildContext context, KlimatologiManualController controller) {
    return RefreshIndicator(
      backgroundColor: GFColors.LIGHT,
      onRefresh: () async {
        await controller.formInit();
      },
      child: ListView(
        children: [
          _weatherSlider(context, controller),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          SizedBox(
            height: 650,
            child: _graphTableTab(context, controller),
          ),
        ],
      ),
    );
  }

  _loader(BuildContext context, KlimatologiManualController controller) {
    List<String> loadStr = ['loading...', 'loading...', 'loading...'];
    return SizedBox(
      child: ListView(
        children: [
          GFCarousel(
            items: loadStr.map((load) {
              return GFShimmer(
                mainColor: Colors.grey[100]!,
                secondaryColor: Colors.grey[300]!,
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
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
            height: 180,
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
                          margin: const EdgeInsets.all(10),
                          height: 355,
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
                          margin: const EdgeInsets.all(10),
                          height: 355,
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

  _selectDate(
      BuildContext context, KlimatologiManualController controller) async {
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

  _graphTableTab(BuildContext context, KlimatologiManualController controller) {
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

  _sensorTabs(BuildContext context, KlimatologiManualController controller) {
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
        return _thermoChart(context, controller);
      case 1:
        return _psychroChart(context, controller);
      case 2:
        return _thermoApungChart(context, controller);
      case 3:
        return _evapoChart(context, controller);
      case 4:
        return _anemoChart(context, controller);
      case 5:
        return _rainFallChart(context, controller);
      default:
        return _thermoChart(context, controller);
    }
  }

  _weatherSlider(BuildContext context, KlimatologiManualController controller) {
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
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
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
            height: 180,
          );
        } else if (snapshot.hasError) {
          return _errorWeather(context);
        } else if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return GFCarousel(
              items: snapshot.data!.map((cuaca) {
                return GFCard(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.zero,
                  boxFit: BoxFit.cover,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  elevation: 5,
                  content: Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    _getSvgPic(cuaca.image),
                                    Text(
                                      cuaca.weatherDesc,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      AppConstants()
                                          .dateFullDayFormatID
                                          .format(cuaca.localDatetime),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      '${AppConstants().hourMinuteFormat.format(cuaca.localDatetime)} WIB',
                                      style: TextStyle(fontSize: 12),
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
                            height: 1,
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
              height: 180,
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
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.zero,
          boxFit: BoxFit.cover,
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 5,
          content: SizedBox(
            height: 150,
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
      height: 180,
    );
  }

  _buildWeatherInfoRow(cuaca) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherInfoItem(
                Icons.thermostat, '${cuaca.t} \u00B0C', 'Suhu'),
            _buildWeatherInfoItem(
                Icons.water_drop_outlined, '${cuaca.hu} %', 'Kelembaban'),
            _buildWeatherInfoItem(
                FluentIcons.compass_northwest_28_regular,
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
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherInfoItem(FluentIcons.weather_squalls_48_regular,
                '${cuaca.ws} m/s', 'Kec. angin'),
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
        Icon(icon, size: 20),
        SizedBox(width: 5),
        Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: data,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10),
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
              height: 20,
              width: 20,
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: 30,
            height: 30,
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 30,
              color: Colors.grey,
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SvgPicture.string(
            snapshot.data!,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          );
        } else {
          // Optional fallback if no data is returned but no error
          return SizedBox(
            width: 30,
            height: 30,
            child: Icon(
              Icons.image,
              size: 30,
              color: Colors.grey,
            ),
          );
        }
      },
    );
  }

  _thermoChart(BuildContext context, KlimatologiManualController controller) {
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
            List<KlimatologiManualModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiManualController>(
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
                            title: AxisTitle(text: 'Thermometer (\u00B0C)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Thermometer',
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
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                          color: cColor,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rentang thermometer : ${data?.thermometerMin} - ${data?.thermometerMin} °C',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Rerata thermometer : ${data?.thermometerMin} °C',
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
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rentang thermometer : $sMin - $sMax',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Rerata thermometer : $sAvg',
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
                            RangeAreaSeries<KlimatologiManualModel, DateTime>(
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              highValueMapper:
                                  (KlimatologiManualModel data, _) =>
                                      data.thermometerMax ?? 0,
                              lowValueMapper:
                                  (KlimatologiManualModel data, _) =>
                                      data.thermometerMin ?? 0,
                              borderColor: const Color(0xFF2CAFFE),
                              borderWidth: 2,
                              color: const Color(0xFF2CAFFE),
                              name: 'Rentang Thermometer',
                            ),
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.blue[900]!,
                              markerSettings: MarkerSettings(
                                  color: Colors.blue[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.thermometerAvg ?? 0,
                              name: 'Thermometer Rata - Rata',
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

  _psychroChart(BuildContext context, KlimatologiManualController controller) {
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
            List<KlimatologiManualModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiManualController>(
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
                            title: AxisTitle(text: 'Psychrometer Standar ()'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Psychrometer Standar',
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
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                          color: cColor,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bola kering : ${data?.psychrometerDryBall ?? 0}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Bola basah : ${data?.psychrometerWetBall ?? 0}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Depresi : ${data?.psycrometerDepresi ?? 0}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'RH : ${data?.pychrometerRh ?? 0}',
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
                              String sKering =
                                  '${listCharts[0].y == null ? 'N/A' : listCharts[0].y!.toStringAsFixed(2)} ';
                              String sBasah = 'N/A';
                              if (listCharts.length > 1) {
                                sBasah =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} ';
                              }
                              String sDepresi = 'N/A';
                              if (listCharts.length > 2) {
                                sDepresi =
                                    '${listCharts[2].y == null ? 'N/A' : listCharts[2].y!.toStringAsFixed(2)} ';
                              }
                              String sRh = 'N/A';
                              if (listCharts.length > 3) {
                                sRh =
                                    '${listCharts[3].y == null ? 'N/A' : listCharts[3].y!.toStringAsFixed(2)} ';
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
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bola kering : $sKering',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Bola basah : $sBasah',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Depresi : $sDepresi',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'RH : $sRh',
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
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.brown,
                              markerSettings: const MarkerSettings(
                                  color: Colors.brown,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.psychrometerDryBall ?? 0,
                              name: 'Bola Kering',
                            ),
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.blue,
                              markerSettings: const MarkerSettings(
                                  color: Colors.blue,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.psychrometerWetBall ?? 0,
                              name: 'Bola Basah',
                            ),
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.orange,
                              markerSettings: const MarkerSettings(
                                  color: Colors.orange,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.psycrometerDepresi ?? 0,
                              name: 'Depresi',
                            ),
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.yellow,
                              markerSettings: const MarkerSettings(
                                  color: Colors.yellow,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.pychrometerRh ?? 0,
                              name: 'RH',
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

  _thermoApungChart(
      BuildContext context, KlimatologiManualController controller) {
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
            List<KlimatologiManualModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiManualController>(
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
                            title: AxisTitle(text: 'Thermometer Apung (°C)'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Thermometer Apung',
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
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                          color: cColor,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rentang thermometer apung : ${data?.thermometerApungMin ?? 0} - ${data?.thermometerApungMax ?? 0} °C',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Rerata thermometer apung : ${data?.thermometerApungAvg ?? 0}',
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
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rentang thermometer : $sMin - $sMax',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Rerata thermometer : $sAvg',
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
                            RangeAreaSeries<KlimatologiManualModel, DateTime>(
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              highValueMapper:
                                  (KlimatologiManualModel data, _) =>
                                      data.thermometerApungMax ?? 0,
                              lowValueMapper:
                                  (KlimatologiManualModel data, _) =>
                                      data.thermometerApungMin ?? 0,
                              borderColor: const Color(0xFF2CAFFE),
                              borderWidth: 2,
                              color: const Color(0xFF2CAFFE),
                              name: 'Rentang Thermometer Apung',
                            ),
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.blue[900]!,
                              markerSettings: MarkerSettings(
                                  color: Colors.blue[900]!,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.thermometerApungAvg ?? 0,
                              name: 'Thermometer Apung Rata - Rata',
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

  _evapoChart(BuildContext context, KlimatologiManualController controller) {
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
            List<KlimatologiManualModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiManualController>(
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
                            title: AxisTitle(text: 'Penguapan ()'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Penguapan',
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
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                          color: cColor,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Air ditambah : ${data?.evaporationWaterAdded ?? 0}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Air dibuang : ${data?.evaporationWaterRemoved ?? 0}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Jumlah : ${data?.evaporationWaterSum ?? 0}',
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
                              String airTambah =
                                  '${listCharts[0].y == null ? 'N/A' : listCharts[0].y!.toStringAsFixed(2)} ';
                              String airBuang = 'N/A';
                              if (listCharts.length > 1) {
                                airBuang =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} ';
                              }
                              String jumlah = 'N/A';
                              if (listCharts.length > 2) {
                                jumlah =
                                    '${listCharts[2].y == null ? 'N/A' : listCharts[2].y!.toStringAsFixed(2)} ';
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
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Air Ditambah : $airTambah',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Air Dibuang : $airBuang',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Jumlah : $jumlah',
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
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.blue,
                              markerSettings: const MarkerSettings(
                                  color: Colors.blue,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: controller.listModel,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.evaporationWaterAdded ?? 0,
                              name: 'Air Ditambah',
                            ),
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.deepOrange,
                              markerSettings: const MarkerSettings(
                                  color: Colors.deepOrange,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.evaporationWaterRemoved ?? 0,
                              name: 'Air Dibuang',
                            ),
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.orange,
                              markerSettings: const MarkerSettings(
                                  color: Colors.orange,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.evaporationWaterSum ?? 0,
                              name: 'Jumlah',
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

  _anemoChart(BuildContext context, KlimatologiManualController controller) {
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
            List<KlimatologiManualModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiManualController>(
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
                            title: AxisTitle(text: 'Anemometer ()'),
                          ),
                          title: ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            alignment: ChartAlignment.center,
                            text: 'Grafik Anemometer',
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
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                          color: cColor,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Angin : ${data?.anemometerWind ?? 0}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Km/jam : ${data?.anemometerSpeed ?? 0}',
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
                              String angin =
                                  '${listCharts[0].y == null ? 'N/A' : listCharts[0].y!.toStringAsFixed(2)} ';
                              String kecepatan = 'N/A';
                              if (listCharts.length > 1) {
                                kecepatan =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} ';
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
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Angin : $angin',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Km/jam : $kecepatan',
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
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.blue,
                              markerSettings: const MarkerSettings(
                                  color: Colors.blue,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.anemometerWind ?? 0,
                              name: 'Angin',
                            ),
                            FastLineSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.deepOrange,
                              markerSettings: const MarkerSettings(
                                  color: Colors.deepOrange,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.anemometerSpeed ?? 0,
                              name: 'Km/jam',
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

  _rainFallChart(BuildContext context, KlimatologiManualController controller) {
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
            List<KlimatologiManualModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiManualController>(
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
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                          color: cColor,
                                        ))),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Manual : ${data?.rainfallManual ?? 0}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Otomatis : ${data?.rainfalAutomatic ?? 0}',
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
                              String manual =
                                  '${listCharts[0].y == null ? 'N/A' : listCharts[0].y!.toStringAsFixed(2)} ';
                              String otomatis = 'N/A';
                              if (listCharts.length > 1) {
                                otomatis =
                                    '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} ';
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
                                        padding: EdgeInsets.all(8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Manual : $manual',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Otomatis : $otomatis',
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
                            ColumnSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.blue,
                              markerSettings: const MarkerSettings(
                                  color: Colors.blue,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.rainfallManual ?? 0,
                              name: 'Manual',
                            ),
                            ColumnSeries<KlimatologiManualModel, DateTime>(
                              color: Colors.deepOrange,
                              markerSettings: const MarkerSettings(
                                  color: Colors.deepOrange,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: listData,
                              xValueMapper: (KlimatologiManualModel data, _) =>
                                  data.readingDate,
                              yValueMapper: (KlimatologiManualModel data, _) =>
                                  data.rainfalAutomatic ?? 0,
                              name: 'Otomatis',
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

  Widget _tableTab(
      BuildContext context, KlimatologiManualController controller) {
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
            // TableDataSource ds = snapshot.data as TableDataSource;
            return GetBuilder<KlimatologiManualController>(
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
                              80,
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: GFColors.LIGHT,
                                gridLineColor: GFColors.LIGHT),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SfDataGrid(
                                headerRowHeight: 40,
                                rowHeight: AppConstants.dataRowHeight,
                                source: controller.tableDataSource,
                                columnWidthMode: ColumnWidthMode.fill,
                                columns: <GridColumn>[
                                  GridColumn(
                                      minimumWidth: 140,
                                      columnName: 'readingDate',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: const Text('Tanggal',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'thermometerMin',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Min',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'thermometerMax',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Max',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'thermometerAvg',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Avg',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 100,
                                      columnName: 'psychrometerDryBall',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Bola Kering',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 100,
                                      columnName: 'psychrometerWetBall',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Bola Basah',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'psycrometerDepresi',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Depresi',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'pychrometerRh',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('RH',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'thermometerApungMin',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Min',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'thermometerApungMax',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Max',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'thermometerApungAvg',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Avg',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 100,
                                      columnName: 'evaporationWaterAdded',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Air Ditambah',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 100,
                                      columnName: 'evaporationWaterRemoved',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Air Dibuang',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 100,
                                      columnName: 'evaporationWaterSum',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Jumlah',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'anemometerWind',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Angin',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'anemometerSpeed',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Km/Jam',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'rainfallManual',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Manual',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 80,
                                      columnName: 'rainfalAutomatic',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Text('Otomatis',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  GridColumn(
                                      minimumWidth: 120,
                                      columnName: 'note',
                                      label: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: const Text('Keterangan',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                ],
                                stackedHeaderRows: <StackedHeaderRow>[
                                  StackedHeaderRow(cells: [
                                    StackedHeaderCell(
                                        columnNames: [
                                          'thermometerMin',
                                          'thermometerMax',
                                          'thermometerAvg'
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Center(
                                              child: Text('Thermometer',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'psychrometerDryBall',
                                          'psychrometerWetBall',
                                          'psycrometerDepresi',
                                          'pychrometerRh'
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Center(
                                              child: Text(
                                                  'Psychrometer Standar',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'thermometerApungMin',
                                          'thermometerApungMax',
                                          'thermometerApungAvg',
                                          'pychrometerRh'
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Center(
                                              child: Text('Thermometer Apung',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'evaporationWaterAdded',
                                          'evaporationWaterRemoved',
                                          'evaporationWaterSum'
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Center(
                                              child: Text('Penguapan',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'anemometerWind',
                                          'anemometerSpeed'
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Center(
                                              child: Text('Anemometer',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'rainfallManual',
                                          'rainfalAutomatic'
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey
                                                  .shade400, // Border color
                                              width: 1, // Border width
                                            ),
                                          ),
                                          child: const Center(
                                              child: Text('Hujan',
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
                          height: 10,
                        ),
                        SfDataPager(
                          delegate: controller.tableDataSource,
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
