import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/controllers/klimatologi_aws_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_day_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_hour_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_minute_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/last_reading_model.dart';
import 'package:mobile_ameroro_app/apps/widgets/loader_animation.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class KlimatologiAwsView extends StatelessWidget {
  final KlimatologiAwsController controller =
      Get.find<KlimatologiAwsController>();
  final _formKey = GlobalKey<FormState>();

  KlimatologiAwsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: const Text(
                'Automatic Weather Station (AWS)',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              actions: const [],
            ),
            body: controller.obx(
              (state) => _detail(context, controller),
              onLoading: const LoaderAnimation(),
              onEmpty: const Text('Tidak ada data yang tersedia'),
              onError: (error) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(error ?? "Error while loading data...!")),
              ),
            ),
          ),
        ));
  }

  _detail(BuildContext context, KlimatologiAwsController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.only(top: 10),
            indicatorColor: Colors.transparent,
            isScrollable: true,
            controller: controller.tabController,
            dividerHeight: 0,
            onTap: (index) {
              controller.selectedTabIndex.value = index;
            },
            tabs: [
              Tab(
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.selectedTabIndex.value == 0
                            ? AppConfig.primaryColor
                            : Colors.grey,
                      ),
                      color: controller.selectedTabIndex.value == 0
                          ? AppConfig.primaryColor
                          : const Color(0XFFe9e7fd),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Pemantauan AWS',
                      style: TextStyle(
                        color: controller.selectedTabIndex.value == 0
                            ? GFColors.WHITE
                            : AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.selectedTabIndex.value == 1
                            ? AppConfig.primaryColor
                            : Colors.grey,
                      ),
                      color: controller.selectedTabIndex.value == 1
                          ? AppConfig.primaryColor
                          : const Color(0XFFe9e7fd),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Data Telemetri',
                      style: TextStyle(
                        color: controller.selectedTabIndex.value == 1
                            ? GFColors.WHITE
                            : AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.selectedTabIndex.value == 2
                            ? AppConfig.primaryColor
                            : Colors.grey,
                      ),
                      color: controller.selectedTabIndex.value == 2
                          ? AppConfig.primaryColor
                          : const Color(0XFFe9e7fd),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Informasi Instrument',
                      style: TextStyle(
                        color: controller.selectedTabIndex.value == 2
                            ? GFColors.WHITE
                            : AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              _pemantauanTab(context, controller),
              _dataTelemetriTab(context, controller),
              const Center(
                child: Text('Informasi Instrumen'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pemantauanTab(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getPemantauan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.separated(
            itemCount: 5, // Simulating 5 items loading
            itemBuilder: (context, index) {
              return GFShimmer(
                mainColor: Colors.grey[300]!, // Base color of the shimmer
                secondaryColor:
                    Colors.grey[100]!, // Highlight color for shimmer effect
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0XFFD6F4F8)),
                    child: const Icon(
                      Icons.water_drop_outlined,
                      color: Color(0XFF00BAD1),
                    ),
                  ),
                  title: Container(
                    color: Colors.grey[300],
                    height: 20.0,
                    width: double.infinity,
                  ), // Placeholder for title
                  subtitle: Container(
                    color: Colors.grey[300],
                    height: 10.0,
                    width: double.infinity,
                  ), // Placeholder for subtitle
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 5),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.value != null) {
              var data = snapshot.data?.value;
              return RefreshIndicator(
                backgroundColor: GFColors.LIGHT,
                onRefresh: () => controller.getLastReading(),
                child: GetBuilder<KlimatologiAwsController>(
                    id: 'lastReading',
                    builder: (controller) {
                      return ListView.separated(
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          Widget wStat = Text('$index');
                          switch (index) {
                            case 0:
                              wStat = _statusCard(
                                  Icons.water_drop_outlined,
                                  (data?.humidity ?? 0.00).toString(),
                                  '%',
                                  'Kelembaban : ${data?.humidityStatus ?? '-'}');
                              break;
                            case 1:
                              wStat = _statusCard(
                                  Icons.downloading,
                                  (data?.pressure ?? 0.00).toString(),
                                  'MB',
                                  'Tekanan');
                              break;
                            case 2:
                              wStat = _statusCard(
                                  Icons.thermostat_outlined,
                                  (data!.temperature ?? 0.00).toString(),
                                  '°C',
                                  'Suhu');
                              break;
                            case 3:
                              wStat = _statusCard(
                                  Icons.cloud_outlined,
                                  (data?.evaporation ?? 0.00).toString(),
                                  'mm',
                                  'Penguapan');
                              break;
                            case 4:
                              wStat = _statusCard(
                                  Icons.air_outlined,
                                  (data?.windSpeed ?? 0.00).toString(),
                                  'km/h',
                                  'Kecepatan Angin');
                              break;
                            case 5:
                              wStat = _statusCard(
                                  Icons.battery_0_bar_outlined,
                                  (data?.batteryVoltage ?? 0.00).toString(),
                                  'volt',
                                  'Baterai');
                              break;
                            case 6:
                              wStat = _statusCard(
                                  Icons.sunny,
                                  (data!.solarRadiation ?? 0.00).toString(),
                                  'W/m\u00B2',
                                  'Radiasi Matahari');
                              break;
                            case 7:
                              wStat = _statusCard(
                                  Icons.light_mode_outlined,
                                  (data!.sunshineHour ?? 0.00).toString(),
                                  'Jam',
                                  'Lama Penyinaran');
                              break;
                            case 8:
                              wStat = _windRainFallCard(data!);
                              break;
                            default:
                          }
                          return wStat;
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                      );
                    }),
              );
            } else {
              return const Center(
                child: Text('Tidak ada data yang tersedia'),
              );
            }
          } else {
            return const Center(
              child: Text('Tidak ada data yang tersedia'),
            );
          }
        }
        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
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
                  child: Text('Tidak ada data yang tersedia'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dataTelemetriTab(
      BuildContext context, KlimatologiAwsController controller) {
    var sensors = controller.sensors;
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Column(children: [
            _forms(context, controller),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 10),
              child: TabBar(
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
            ),
          ]),
        ),
        Expanded(
          child: RefreshIndicator(
            backgroundColor: GFColors.LIGHT,
            onRefresh: () => controller.telemetriOnRefresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: _sensorTabs(context, controller),
                  ),
                  Container(
                      height: 300,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
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
                      child: const Center(child: Text('Data Table'))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _forms(BuildContext context, KlimatologiAwsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
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
              items: DataFilterType.values.map((DataFilterType item) {
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              child: const SizedBox(
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

  _getImage(LastReadingModel data) {
    String path = 'assets/images/arr/arr-icon-offline.png';
    String sImg = '';
    String sTime = '';
    if (data.readingAt!.hour >= 6 && data.readingAt!.hour < 12) {
      sTime = 'pagi';
    } else if (data.readingAt!.hour >= 12 && data.readingAt!.hour < 16) {
      sTime = 'siang';
    } else if (data.readingAt!.hour >= 16 && data.readingAt!.hour < 19) {
      sTime = 'sore';
    } else {
      sTime = 'malam';
    }

    if ((data.rainfallHourIntensity ?? '').toLowerCase() == 'tidak ada hujan') {
      sImg = 'berawan';
    } else if ((data.rainfallHourIntensity ?? '').toLowerCase() ==
        'hujan ringan') {
      sImg = 'hujan-ringan';
    } else if ((data.rainfallHourIntensity ?? '').toLowerCase() ==
        'hujan sedang') {
      sImg = 'hujan-sedang';
    } else if ((data.rainfallHourIntensity ?? '').toLowerCase() ==
        'hujan lebat') {
      sImg = 'hujan-lebat';
    } else if ((data.rainfallHourIntensity ?? '').toLowerCase() ==
        'hujan sangat lebat') {
      sImg = 'hujan-sangat-lebat';
    }

    if (sImg.isNotEmpty && sTime.isNotEmpty) {
      if ((data.rainfallHourIntensity ?? '').toLowerCase() ==
          'tidak ada hujan') {
        path = 'assets/images/arr/$sImg-$sTime-outline.png';
      } else {
        path = 'assets/images/arr/$sImg-outline.png';
      }
    }
    return Image.asset(
      path,
      width: 50,
      height: 50,
    );
  }

  _windRainFallCard(LastReadingModel data) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
          color: GFColors.WHITE,
          border: Border.all(color: const Color(0XFFE6E6E8))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '1.5',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppConfig.fontSizeLarge,
                                  color: const Color(0XFF808390),
                                ),
                              ),
                              WidgetSpan(
                                child: Transform.translate(
                                  offset: const Offset(2, -4),
                                  child: const Text(
                                    ' mm',
                                    style: TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0XFF808390),
                                        fontFeatures: [
                                          FontFeature.superscripts()
                                        ]),
                                    textScaleFactor: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Curah Hujan',
                      style: TextStyle(color: Color(0XFF808390)),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ((data.rainfallHourIntensity ?? '').toLowerCase() ==
                            'tidak ada hujan')
                        ? _getImage(data)
                        : FadeTransition(
                            opacity: controller.animation,
                            child: _getImage(data),
                          ),
                    Text(
                      data.rainfallHourIntensity ?? '-',
                      style: const TextStyle(color: Color(0XFF808390)),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 10,
            color: GFColors.LIGHT,
          ),
          _windDirectionGauge(
            data.windDirection ?? 0,
          )
        ],
      ),
    );
  }

  _statusCard(IconData icon, String dataVal, String unit, String warnStatus) {
    try {
      return Container(
        color: GFColors.WHITE,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0XFFD6F4F8)),
            child: Icon(
              icon,
              color: const Color(0XFF00BAD1),
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: dataVal,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppConfig.fontSizeLarge,
                    color: const Color(0XFF808390),
                  ),
                ),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(2, -4),
                    child: Text(
                      ' $unit',
                      style: const TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF808390),
                          fontFeatures: [FontFeature.superscripts()]),
                      textScaleFactor: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text(
            warnStatus,
            style: const TextStyle(color: Color(0XFF808390)),
          ),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  _windDirectionGauge(double angle) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Arah Angin (°)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                radiusFactor: 0.55,
                minimum: 0,
                maximum: 360,
                startAngle: 270, // Mulai dari Utara (atas)
                endAngle: 270,
                interval: 45,
                showLabels: false, // Sembunyikan angka default
                showTicks: true,
                axisLineStyle: const AxisLineStyle(
                  thickness: 8,
                ),
                majorTickStyle: const MajorTickStyle(length: 10),
                annotations: [
                  // Tambahkan label arah mata angin
                  _buildDirectionLabel(270, "Utara"),
                  _buildDirectionLabel(315, "Timur Laut"),
                  _buildDirectionLabel(0, "Timur"),
                  _buildDirectionLabel(45, "Tenggara"),
                  _buildDirectionLabel(90, "Selatan"),
                  _buildDirectionLabel(135, "Barat Daya"),
                  _buildDirectionLabel(180, "Barat"),
                  _buildDirectionLabel(225, "Barat Laut"),
                  _buildAngleWidget(angle),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: angle, // Sudut arah angin
                    needleColor: Colors.red,
                    tailStyle: const TailStyle(
                        width: 5, length: 0.1, color: Colors.red),
                    knobStyle: const KnobStyle(
                        color: Colors.black,
                        sizeUnit: GaugeSizeUnit.factor,
                        knobRadius: 0.08),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  GaugeAnnotation _buildAngleWidget(double angle) {
    return GaugeAnnotation(
      angle: 90.0,
      positionFactor: 0.5, // Di tengah gauge
      widget: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 3),
          ],
        ),
        child: Text(
          '${angle.toInt()}°', // Menampilkan angka derajat
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  GaugeAnnotation _buildDirectionLabel(double degree, String text) {
    return GaugeAnnotation(
      angle: degree,
      positionFactor: 1.4, // Jarak label dari pusat gauge
      widget: Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
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

  // _graphTableTab(BuildContext context, KlimatologiAwsController controller) {
  //   return Column(
  //     children: [
  //       TabBar(
  //         controller: controller.tabController,
  //         tabs: const [
  //           Tab(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [Text('GRAFIK')],
  //             ),
  //           ),
  //           Tab(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [Text('TABEL')],
  //             ),
  //           ),
  //         ],
  //       ),
  //       Expanded(
  //         child: TabBarView(
  //           controller: controller.tabController,
  //           children: [
  //             _sensorTabs(context, controller),
  //             _tableTab(context, controller),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  _sensorTabs(BuildContext context, KlimatologiAwsController controller) {
    var sensors = controller.sensors;

    return TabBarView(
      controller: controller.sensorTabController,
      children: [
        for (int i = 0; i < sensors.length; i++)
          _getChartByIndex(i, context, controller),
      ],
    );
  }

  Widget _getChartByIndex(int index, BuildContext context, var controller) {
    switch (index) {
      case 0:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _huChartMinute(context, controller)
            : controller.filterType.value == DataFilterType.hourly
                ? _huChartHour(context, controller)
                : _huChartDay(context, controller);
      case 1:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _rainFallChartMinute(context, controller)
            : controller.filterType.value == DataFilterType.hourly
                ? _rainFallChartHour(context, controller)
                : _rainFallChartDay(context, controller);
      case 2:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _pressChartMinute(context, controller)
            : controller.filterType.value == DataFilterType.hourly
                ? _pressChartHour(context, controller)
                : _pressChartDay(context, controller);
      case 3:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _tempChartMinute(context, controller)
            : controller.filterType.value == DataFilterType.hourly
                ? _tempChartHour(context, controller)
                : _tempChartDay(context, controller);
      case 4:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _solarChartMinute(context, controller)
            : controller.filterType.value == DataFilterType.hourly
                ? _solarChartHour(context, controller)
                : _solarChartDay(context, controller);
      case 5:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _windDirChartMinute(context, controller)
            : controller.filterType.value == DataFilterType.hourly
                ? _windDirChartHour(context, controller)
                : _windDirChartDay(context, controller);
      case 6:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _windSpeedChartMinute(context, controller)
            : controller.filterType.value == DataFilterType.hourly
                ? _windSpeedChartHour(context, controller)
                : _windSpeedChartDay(context, controller);
      case 7:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _evaporationChartMinute(context, controller)
            : controller.filterType.value == DataFilterType.hourly
                ? _evaporationChartHour(context, controller)
                : _evaporationChartDay(context, controller);
      case 8:
        return controller.filterType.value == DataFilterType.fiveMinutely
            ? _batteryChartMinute(context, controller)
            : Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
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
                child: const Center(
                  child: Text('Tidak ada grafik baterai jam & hari'),
                ),
              );
      default:
        return const Center(child: Text('Grafik Baterai'));
    }
  }

  _huChartMinute(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listDataMinute =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataMinute = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Kelembaban (%)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Kelembaban',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                          int? index = trackballDetails.pointIndex;
                          if (index != null) {
                            final data = controller.listMinuteModel[index];
                            final DateTime date = trackballDetails.point?.x;
                            final String formattedDate =
                                '${AppConstants().dateTimeFormatID.format(date)} WITA';

                            return SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(0, 8, 22, 0.75),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Kelembaban : ${AppConstants().numFormat.format(trackballDetails.point?.y)} %",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Status : ${data.humadityStatus ?? '-'}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true, // Enable pinch zoom
                        enablePanning: true, // Enable panning
                        zoomMode: ZoomMode
                            .x, // Allow zooming only on the x-axis (can be both x, y or both)
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: const Color(0xFFFF9800),
                          markerSettings: MarkerSettings(
                              color: Colors.orange[900]!,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataMinute,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.humadity ?? 0,
                          name: 'Kelemaban',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _huChartHour(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsHourModel> listDataHour =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataHour = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Kelembaban (%)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Kelembaban',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                          int? index = trackballDetails.pointIndex;
                          if (index != null) {
                            final data = controller.listHourModel[index];
                            final DateTime date = trackballDetails.point?.x;
                            final String formattedDate =
                                '${AppConstants().dateTimeFormatID.format(date)} WITA';

                            return SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(0, 8, 22, 0.75),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Kelembaban : ${AppConstants().numFormat.format(trackballDetails.point?.y)} %",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Status : ${data.humidityStatus ?? '-'}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true, // Enable pinch zoom
                        enablePanning: true, // Enable panning
                        zoomMode: ZoomMode
                            .x, // Allow zooming only on the x-axis (can be both x, y or both)
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsHourModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsHourModel, DateTime>(
                          color: AppConfig.primaryColor,
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataHour,
                          xValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.readingHour,
                          yValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.humidity ?? 0,
                          name: 'Kelemaban',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _huChartDay(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsDayModel> listDataDay =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataDay = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Kelembaban (%)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Kelembaban',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
                        ),
                        // tooltipSettings: const InteractiveTooltip(
                        //   enable: true,
                        //   color: Colors.green, // Tooltip background color
                        //   textStyle: TextStyle(color: Colors.white), // Tooltip text color
                        // ),
                        activationMode: ActivationMode.singleTap,
                        enable: true,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        builder: (BuildContext context,
                            TrackballDetails trackballDetails) {
                          List<CartesianChartPoint> listCharts =
                              trackballDetails.groupingModeInfo!.points;
                          String dateTime =
                              '${AppConstants().dateTimeFormatID.format(listCharts.first.x as DateTime)} WITA';
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
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries>[
                        RangeAreaSeries<KlimatologiAwsDayModel, DateTime>(
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          highValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.humidityMax ?? 0,
                          lowValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.humidityMin ?? 0,
                          borderColor: const Color(0xFF2CAFFE),
                          borderWidth: 2,
                          color: const Color(0xFF2CAFFE),
                          name: 'Rentang Kelembaban',
                        ),
                        FastLineSeries<KlimatologiAwsDayModel, DateTime>(
                          color: Colors.deepPurple[900]!,
                          markerSettings: MarkerSettings(
                              color: Colors.deepPurple[900]!,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.diamond),
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          yValueMapper: (KlimatologiAwsDayModel data, _) {
                            return ((data.humidityMin ?? 0) +
                                    (data.humidityMax ?? 0)) /
                                2;
                          },
                          name: 'Kelembaban Rata - Rata',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _pressChartMinute(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listDataMinute =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataMinute = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Tekanan (MB))'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Tekanan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Tekanan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (MB)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: const Color(0xFFA4907C),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataMinute,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.pressure ?? 0,
                          name: 'Tekanan',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _pressChartHour(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsHourModel> listDataHour =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataHour = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Tekanan (MB)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Tekanan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Tekanan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (MB)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsHourModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsHourModel, DateTime>(
                          color: const Color(0XFFa4907c),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataHour,
                          xValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.readingHour,
                          yValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.pressure ?? 0,
                          name: 'Tekanan',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _pressChartDay(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsDayModel> listDataDay =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataDay = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Tekanan (MB)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Tekanan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
                        ),
                        // tooltipSettings: const InteractiveTooltip(
                        //   enable: true,
                        //   color: Colors.green, // Tooltip background color
                        //   textStyle: TextStyle(color: Colors.white), // Tooltip text color
                        // ),
                        activationMode: ActivationMode.singleTap,
                        enable: true,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        builder: (BuildContext context,
                            TrackballDetails trackballDetails) {
                          List<CartesianChartPoint> listCharts =
                              trackballDetails.groupingModeInfo!.points;
                          String dateTime =
                              '${AppConstants().dateTimeFormatID.format(listCharts.first.x as DateTime)} WITA';
                          String sMin =
                              '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} (MB)';
                          String sMax =
                              '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} (MB)';
                          String sAvg = 'N/A';
                          if (listCharts.length > 1) {
                            sAvg =
                                '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} (MB)';
                          }

                          return SingleChildScrollView(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 250,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rentang Tekanan : $sMin - $sMax',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Rerata Tekanan : $sAvg',
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries>[
                        RangeAreaSeries<KlimatologiAwsDayModel, DateTime>(
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          highValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.pressureMax ?? 0,
                          lowValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.pressureMin ?? 0,
                          borderColor: const Color(0XFF803D3B).withOpacity(0.5),
                          borderWidth: 2,
                          color: const Color(0XFF803D3B).withOpacity(0.4),
                          name: 'Rentang Tekanan',
                        ),
                        FastLineSeries<KlimatologiAwsDayModel, DateTime>(
                          color: const Color(0XFF803D3B),
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          yValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.pressureAvg ?? 0,
                          name: 'Tekanan Rata - Rata',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _rainFallChartMinute(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listData =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Curah Hujan (mm)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Curah Hujan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              // height: 50,
                              // width: 150,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$formattedDate WITA',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Curah Hujan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        ColumnSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: Colors.blue[500],
                          markerSettings: MarkerSettings(
                              color: Colors.blue[900]!,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listData,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.rainFall ?? 0,
                          name: 'Curah Hujan',
                          borderRadius: BorderRadius.circular(5),
                          width: 0.9,
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _rainFallChartHour(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsHourModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Curah Hujan (mm)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Curah Hujan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              // height: 50,
                              // width: 150,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$formattedDate WITA',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Curah Hujan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsHourModel,
                          DateTime>>[
                        ColumnSeries<KlimatologiAwsHourModel, DateTime>(
                          color: Colors.blue[500],
                          markerSettings: MarkerSettings(
                              color: Colors.blue[900]!,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listData,
                          xValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.readingHour,
                          yValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.rainfall ?? 0,
                          name: 'Curah Hujan',
                          borderRadius: BorderRadius.circular(5),
                          width: 0.9,
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _rainFallChartDay(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsDayModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Curah Hujan (mm)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Curah Hujan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              // height: 50,
                              // width: 150,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$formattedDate WITA',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Curah Hujan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsDayModel,
                          DateTime>>[
                        ColumnSeries<KlimatologiAwsDayModel, DateTime>(
                          color: Colors.blue[500],
                          markerSettings: MarkerSettings(
                              color: Colors.blue[900]!,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listData,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          yValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.rainfall ?? 0,
                          name: 'Curah Hujan',
                          borderRadius: BorderRadius.circular(5),
                          width: 0.9,
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _tempChartMinute(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listDataMinute =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataMinute = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Suhu (\u00B0C))'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Suhu',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Suhu : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (\u00B0C)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: const Color(0xFFA4907C),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataMinute,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.temperature ?? 0,
                          name: 'Suhu',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _tempChartHour(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsHourModel> listDataHour =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataHour = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Suhu (\u00B0C)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Suhu',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Suhu : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (\u00B0C)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsHourModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsHourModel, DateTime>(
                          color: const Color(0XFFa4907c),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataHour,
                          xValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.readingHour,
                          yValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.temperature ?? 0,
                          name: 'Suhu',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _tempChartDay(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsDayModel> listDataDay =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataDay = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Suhu (\u00B0C)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Suhu',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
                        ),
                        // tooltipSettings: const InteractiveTooltip(
                        //   enable: true,
                        //   color: Colors.green, // Tooltip background color
                        //   textStyle: TextStyle(color: Colors.white), // Tooltip text color
                        // ),
                        activationMode: ActivationMode.singleTap,
                        enable: true,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        builder: (BuildContext context,
                            TrackballDetails trackballDetails) {
                          List<CartesianChartPoint> listCharts =
                              trackballDetails.groupingModeInfo!.points;
                          String dateTime =
                              '${AppConstants().dateTimeFormatID.format(listCharts.first.x as DateTime)} WITA';
                          String sMin =
                              '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} (\u00B0C)';
                          String sMax =
                              '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} (\u00B0C)';
                          String sAvg = 'N/A';
                          if (listCharts.length > 1) {
                            sAvg =
                                '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} (\u00B0C)';
                          }

                          return SingleChildScrollView(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 280,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rentang Suhu : $sMin - $sMax',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Rerata Suhu : $sAvg',
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries>[
                        RangeAreaSeries<KlimatologiAwsDayModel, DateTime>(
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          highValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.temperatureMax ?? 0,
                          lowValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.temperatureMin ?? 0,
                          // borderColor: const Color(0xFF1a0189).withOpacity(0.5),
                          borderWidth: 2,
                          // color: const Color(0xFF1a0189).withOpacity(0.4),
                          name: 'Rentang Suhu',
                        ),
                        FastLineSeries<KlimatologiAwsDayModel, DateTime>(
                          // color: const Color(0xFF1a0189),
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          yValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.temperatureAvg ?? 0,
                          name: 'Suhu Rata - Rata',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _solarChartMinute(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listDataMinute =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataMinute = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Radiasi Matahari (W/s2)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Radiasi Matahari',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Radiasi Mathari : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (W/s2)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: const Color(0xFFFF8303),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataMinute,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.solarRadiation ?? 0,
                          name: 'Radiasi Matahari',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _solarChartHour(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsHourModel> listDataHour =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataHour = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Radiasi Matahari (W/s2)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Radiasi Matahari',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Radiasi Matahari : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (W/s2)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsHourModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsHourModel, DateTime>(
                          color: const Color(0xFFFF8303),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataHour,
                          xValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.readingHour,
                          yValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.solarRadiation ?? 0,
                          name: 'Radiasi Matahari',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _solarChartDay(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsDayModel> listDataDay =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataDay = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Radiasi Matahari (W/s2)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Radiasi Matahari',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
                        ),
                        // tooltipSettings: const InteractiveTooltip(
                        //   enable: true,
                        //   color: Colors.green, // Tooltip background color
                        //   textStyle: TextStyle(color: Colors.white), // Tooltip text color
                        // ),
                        activationMode: ActivationMode.singleTap,
                        enable: true,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        builder: (BuildContext context,
                            TrackballDetails trackballDetails) {
                          List<CartesianChartPoint> listCharts =
                              trackballDetails.groupingModeInfo!.points;
                          String dateTime =
                              '${AppConstants().dateTimeFormatID.format(listCharts.first.x as DateTime)} WITA';
                          String sMin =
                              '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} (W/s2)';
                          String sMax =
                              '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} (W/s2)';
                          String sAvg = 'N/A';
                          if (listCharts.length > 1) {
                            sAvg =
                                '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} (W/s2)';
                          }

                          return SingleChildScrollView(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 280,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rentang Radiasi Matahari : $sMin - $sMax',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Rerata Radiasi Matahari : $sAvg',
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries>[
                        RangeAreaSeries<KlimatologiAwsDayModel, DateTime>(
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          highValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.solarRadiationMax ?? 0,
                          lowValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.solarRadiationMin ?? 0,
                          borderColor: const Color(0xFFFF8303).withOpacity(0.5),
                          borderWidth: 2,
                          color: const Color(0xFFFF8303).withOpacity(0.4),
                          name: 'Rentang Radiasi Matahari',
                        ),
                        FastLineSeries<KlimatologiAwsDayModel, DateTime>(
                          color: const Color(0xFFFF8303),
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          yValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.solarRadiationAvg ?? 0,
                          name: 'Radiasi Matahari Rata - Rata',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _windDirChartMinute(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listDataMinute =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataMinute = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Arah Angin (°)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Arah Angin',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Arah Angin : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (°)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: const Color(0xFF51C2D5),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataMinute,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.windDirection ?? 0,
                          name: 'Arah Angin',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _windDirChartHour(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsHourModel> listDataHour =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataHour = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Arah Angin (°)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Arah Angin',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Arah Angin : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (°)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsHourModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsHourModel, DateTime>(
                          color: const Color(0XFF51C2D5),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataHour,
                          xValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.readingHour,
                          yValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.windDirection ?? 0,
                          name: 'Arah Angin',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _windDirChartDay(BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsDayModel> listDataDay =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataDay = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Arah Angin (°)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Arah Angin',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
                        ),
                        // tooltipSettings: const InteractiveTooltip(
                        //   enable: true,
                        //   color: Colors.green, // Tooltip background color
                        //   textStyle: TextStyle(color: Colors.white), // Tooltip text color
                        // ),
                        activationMode: ActivationMode.singleTap,
                        enable: true,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        builder: (BuildContext context,
                            TrackballDetails trackballDetails) {
                          List<CartesianChartPoint> listCharts =
                              trackballDetails.groupingModeInfo!.points;
                          String dateTime =
                              '${AppConstants().dateTimeFormatID.format(listCharts.first.x as DateTime)} WITA';
                          String sMin =
                              '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} (°)';
                          String sMax =
                              '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} (°)';
                          String sAvg = 'N/A';
                          if (listCharts.length > 1) {
                            sAvg =
                                '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} (°)';
                          }

                          return SingleChildScrollView(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 280,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rentang Arah Angin : $sMin - $sMax',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Rerata Arah Angin : $sAvg',
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries>[
                        RangeAreaSeries<KlimatologiAwsDayModel, DateTime>(
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          highValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.windDirectionMax ?? 0,
                          lowValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.windDirectionMin ?? 0,
                          borderColor: const Color(0xFF51c2d5).withOpacity(0.5),
                          borderWidth: 2,
                          color: const Color(0xFF51c2d5).withOpacity(0.4),
                          name: 'Rentang Arah Angin',
                        ),
                        FastLineSeries<KlimatologiAwsDayModel, DateTime>(
                          color: const Color(0xFF51c2d5),
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          yValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.windDirectionAvg ?? 0,
                          name: 'Arah Angin Rata - Rata',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _windSpeedChartMinute(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listDataMinute =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataMinute = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Kecepatan Angin (km/h)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Kecepatan Angin',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Kecepatan Angin : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (km/h)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: const Color(0xFFB7B7B7),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataMinute,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.windSpeed ?? 0,
                          name: 'Kecepatan Angin',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _windSpeedChartHour(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsHourModel> listDataHour =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataHour = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Kecepatan Angin (km/h)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Kecepatan Angin',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Kecepatan Angin : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (km/h)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsHourModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsHourModel, DateTime>(
                          color: const Color(0XFFB7B7B7),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataHour,
                          xValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.readingHour,
                          yValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.windSpeed ?? 0,
                          name: 'Kecepatan Angin',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _windSpeedChartDay(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsDayModel> listDataDay =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataDay = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Kecepatan Angin (km/h)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Kecepatan Angin',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
                        ),
                        // tooltipSettings: const InteractiveTooltip(
                        //   enable: true,
                        //   color: Colors.green, // Tooltip background color
                        //   textStyle: TextStyle(color: Colors.white), // Tooltip text color
                        // ),
                        activationMode: ActivationMode.singleTap,
                        enable: true,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        builder: (BuildContext context,
                            TrackballDetails trackballDetails) {
                          List<CartesianChartPoint> listCharts =
                              trackballDetails.groupingModeInfo!.points;
                          String dateTime =
                              '${AppConstants().dateTimeFormatID.format(listCharts.first.x as DateTime)} WITA';
                          String sMin =
                              '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} (km/h)';
                          String sMax =
                              '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} (km/h)';
                          String sAvg = 'N/A';
                          if (listCharts.length > 1) {
                            sAvg =
                                '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} (km/h)';
                          }

                          return SingleChildScrollView(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 280,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rentang Kecepatan Angin : $sMin - $sMax',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Rerata Kecepatan Angin : $sAvg',
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries>[
                        RangeAreaSeries<KlimatologiAwsDayModel, DateTime>(
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          highValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.windSpeedMax ?? 0,
                          lowValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.windSpeedMin ?? 0,
                          borderColor: const Color(0xFFB7B7B7).withOpacity(0.5),
                          borderWidth: 2,
                          color: const Color(0xFFB7B7B7).withOpacity(0.4),
                          name: 'Rentang Kecepatan Angin',
                        ),
                        FastLineSeries<KlimatologiAwsDayModel, DateTime>(
                          color: const Color(0xFFB7B7B7),
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          yValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.windSpeedAvg ?? 0,
                          name: 'Kecepatan Angin Rata - Rata',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _evaporationChartMinute(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listDataMinute =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataMinute = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Penguapan (mm)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Penguapan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Penguapan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: const Color(0xFF8EB486),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataMinute,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.evaporation ?? 0,
                          name: 'Penguapan',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _evaporationChartHour(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataHour(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsHourModel> listDataHour =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataHour = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Penguapan (mm)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Penguapan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Penguapan : ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mm)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsHourModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsHourModel, DateTime>(
                          color: const Color(0xFF8EB486),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataHour,
                          xValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.readingHour,
                          yValueMapper: (KlimatologiAwsHourModel data, _) =>
                              data.evaporation ?? 0,
                          name: 'Penguapan',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _evaporationChartDay(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsDayModel> listDataDay =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataDay = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Penguapan (km/h)'),
                      ),
                      title: const ChartTitle(
                        textStyle: TextStyle(
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.center,
                        text: 'Grafik Penguapan',
                      ),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      trackballBehavior: TrackballBehavior(
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
                        ),
                        // tooltipSettings: const InteractiveTooltip(
                        //   enable: true,
                        //   color: Colors.green, // Tooltip background color
                        //   textStyle: TextStyle(color: Colors.white), // Tooltip text color
                        // ),
                        activationMode: ActivationMode.singleTap,
                        enable: true,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        builder: (BuildContext context,
                            TrackballDetails trackballDetails) {
                          List<CartesianChartPoint> listCharts =
                              trackballDetails.groupingModeInfo!.points;
                          String dateTime =
                              '${AppConstants().dateTimeFormatID.format(listCharts.first.x as DateTime)} WITA';
                          String sMin =
                              '${listCharts[0].low == null ? 'N/A' : listCharts[0].low!.toStringAsFixed(2)} (mm)';
                          String sMax =
                              '${listCharts[0].high == null ? 'N/A' : listCharts[0].high!.toStringAsFixed(2)} (mm)';
                          String sAvg = 'N/A';
                          if (listCharts.length > 1) {
                            sAvg =
                                '${listCharts[1].y == null ? 'N/A' : listCharts[1].y!.toStringAsFixed(2)} (mm)';
                          }

                          return SingleChildScrollView(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 280,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rentang Penguapan : $sMin - $sMax',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Rerata Penguapan : $sAvg',
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries>[
                        RangeAreaSeries<KlimatologiAwsDayModel, DateTime>(
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          highValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.evaporationMax ?? 0,
                          lowValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.evaporationMin ?? 0,
                          borderColor: const Color(0xFF8EB486).withOpacity(0.5),
                          borderWidth: 2,
                          color: const Color(0xFF8EB486).withOpacity(0.4),
                          name: 'Rentang Penguapan',
                        ),
                        FastLineSeries<KlimatologiAwsDayModel, DateTime>(
                          color: const Color(0xFF8EB486),
                          dataSource: listDataDay,
                          xValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.readingDate,
                          yValueMapper: (KlimatologiAwsDayModel data, _) =>
                              data.evaporationAvg ?? 0,
                          name: 'Penguapan Rata - Rata',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
          ),
        );
      },
    );
  }

  _batteryChartMinute(
      BuildContext context, KlimatologiAwsController controller) {
    return FutureBuilder(
      future: controller.getChartDataMinute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GFShimmer(
            mainColor: Colors.grey[300]!,
            secondaryColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            List<KlimatologiAwsMinuteModel> listDataMinute =
                List.empty(growable: true);
            if (snapshot.data != null) {
              listDataMinute = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
                id: 'grafik',
                builder: (controller) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
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
                            text: "Waktu", alignment: ChartAlignment.center),
                      ),
                      primaryYAxis: const NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Baterai (%)'),
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
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility:
                              TrackballVisibilityMode.visible, // Show markers
                          color: Colors.white, // Color of the trackball marker
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
                              '${AppConstants().dateTimeFormatID.format(date)} WITA';

                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 8, 22, 0.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Baterai : ${trackballDetails.point?.y} (%)",
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
                        enableDoubleTapZooming: true, // Enable double-tap zoom
                      ),
                      series: <CartesianSeries<KlimatologiAwsMinuteModel,
                          DateTime>>[
                        FastLineSeries<KlimatologiAwsMinuteModel, DateTime>(
                          color: const Color(0xFFFF8400),
                          markerSettings: const MarkerSettings(
                              color: Colors.white,
                              // isVisible: true,
                              // Marker shape is set to diamond
                              shape: DataMarkerType.circle),
                          dataSource: listDataMinute,
                          xValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.readingAt,
                          yValueMapper: (KlimatologiAwsMinuteModel data, _) =>
                              data.batteryCapacity ?? 0,
                          name: 'Baterai',
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
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
              child: const Center(
                child: Text('Tidak ada data yang tersedia'),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
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
          child: const Center(
            child: Text('Tidak ada data yang tersedia'),
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                          title: const ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
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
                                        padding: const EdgeInsets.all(8),
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
                                        padding: const EdgeInsets.all(8),
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
                              borderWidth: 2,
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

  _wsChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                          title: const ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
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
                                        padding: const EdgeInsets.all(8),
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
                                        padding: const EdgeInsets.all(8),
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
                              borderWidth: 2,
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

  _rainFallChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                            title: AxisTitle(text: 'Curah Hujan (mm)'),
                          ),
                          title: const ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
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
                                  // height: 50,
                                  width: 150,
                                  padding: const EdgeInsets.all(8),
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

  _batteryChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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

  _solarChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                            title: AxisTitle(text: 'Radiasi Matahari (W/m2)'),
                          ),
                          title: const ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
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
                                  // height: 50,
                                  width: 150,
                                  padding: const EdgeInsets.all(8),
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

  _tempChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                          title: const ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
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
                                        padding: const EdgeInsets.all(8),
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
                                        padding: const EdgeInsets.all(8),
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
                              borderWidth: 2,
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

  _bpChart(BuildContext context, KlimatologiAwsController controller) {
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
            List<KlimatologiAwsModel> listData = List.empty(growable: true);
            if (snapshot.data != null) {
              listData = snapshot.data!;
            }
            return GetBuilder<KlimatologiAwsController>(
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
                          title: const ChartTitle(
                            textStyle: TextStyle(
                                height: 2,
                                fontSize: 14,
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
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          dateTime,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        width: 250,
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
                              borderWidth: 2,
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

  Widget _tableTab(BuildContext context, KlimatologiAwsController controller) {
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
            TableDataSource ds = snapshot.data as TableDataSource;
            return GetBuilder<KlimatologiAwsController>(
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
                                  source: ds,
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
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: const Text('Waktu',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80,
                                        columnName: 'record',
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
                                            child: const Text('Record',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80,
                                        columnName: 'battery',
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
                                            child: const Text('Battery',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 80,
                                        columnName: 'airtempMin',
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
                                        columnName: 'airtempMax',
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
                                        columnName: 'rhMin',
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
                                        minimumWidth: 100,
                                        columnName: 'rhMax',
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
                                        columnName: 'dewpointMin',
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
                                        columnName: 'dewpointMax',
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
                                        columnName: 'wsMin',
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
                                        columnName: 'wsMax',
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
                                        minimumWidth: 180,
                                        columnName: 'solar',
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
                                            child: const Text(
                                                'Radiasi Matahari (W/m²)',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 140,
                                        columnName: 'rainfall',
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
                                            child: const Text(
                                                'Curah Hujan (mm)',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    GridColumn(
                                        minimumWidth: 100,
                                        columnName: 'bpMin',
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
                                        minimumWidth: 100,
                                        columnName: 'bpMax',
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
                                                width: 1, // Border width
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
                                                width: 1, // Border width
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
                                                width: 1, // Border width
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
                                                width: 1, // Border width
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
                                                width: 1, // Border width
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(10),
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
}
