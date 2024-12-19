import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/controllers/open_standpipe_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/models/open_standpipe_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OpenStandpipeView extends StatelessWidget {
  final OpenStandpipeController controller =
      Get.find<OpenStandpipeController>();
  final _formKey = GlobalKey<FormState>();
  final stationKey = GlobalKey<DropdownSearchState>();
  final elevationKey = GlobalKey<DropdownSearchState>();

  OpenStandpipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<OpenStandpipeController>(
                builder: (controller) => Text(
                  'OPEN STANDPIPE',
                  style: TextStyle(
                    fontSize: 20.r,
                  ),
                ),
              ),
              actions: [],
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

  _detail(BuildContext context, OpenStandpipeController controller) {
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
              padding: EdgeInsets.all(
                10.r,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownSearch<Map<String, dynamic>>(
                      key: stationKey,
                      onChanged: (value) async {
                        if (value != null) {
                          controller.selectedStation.value = value;
                          controller.update();
                        }
                      },
                      validator: (value) {
                        if (value!['id'].toString().isEmpty) {
                          return "Required field";
                        }
                        return null;
                      },
                      selectedItem:
                          controller.selectedStation as Map<String, dynamic>,
                      items: (filter, infiniteScrollProps) async {
                        List<Map<String, dynamic>> result =
                            List.empty(growable: true);
                        var reponse = await controller.getStations();
                        if (reponse.isNotEmpty) {
                          result.addAll(reponse);
                        }
                        return result;
                      },
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Jenis Instrument',
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
                    DropdownSearch<Map<String, dynamic>>(
                      key: elevationKey,
                      onChanged: (value) async {
                        if (value != null) {
                          controller.selectedElevation.value = value;
                        }
                      },
                      selectedItem:
                          controller.selectedElevation as Map<String, dynamic>,
                      items: (filter, infiniteScrollProps) async {
                        List<Map<String, dynamic>> result =
                            List.empty(growable: true);
                        var reponse = await controller.getElevations();
                        if (reponse.isNotEmpty) {
                          Map<String, dynamic> all = {
                            'id': '',
                            'text': 'Semua'
                          };
                          result.add(all);
                          result.addAll(reponse);
                        }
                        return result;
                      },
                      // validator: (value) {
                      //   if (value!['id'].toString().isEmpty) {
                      //     return "Required field";
                      //   }
                      //   return null;
                      // },
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Elevation',
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
                          borderSide:
                              BorderSide(color: GFColors.DARK), // Border color
                        ),
                        labelText: 'Periode',
                        suffixIcon: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, // added line
                          mainAxisSize: MainAxisSize.min, // added line
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.calendar_month),
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
              length: 3, // Jumlah tab
              child: Column(
                children: [
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        child: Text(
                          'GAMBAR PONDASI',
                          selectionColor: context.iconColor,
                        ),
                      ),
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
                    height: 680.r,
                    child: TabBarView(
                      children: [
                        _gambarPondasi(context),
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

  _selectDate(BuildContext context, OpenStandpipeController controller) async {
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
    }
  }

  Widget _gambarPondasi(BuildContext context) {
    List<Map<String, String>> listSvg = [
      {'title': 'STA 1+250', 'path': 'assets/images/OSP-11-12.svg'},
      {'title': 'STA 1+275', 'path': 'assets/images/OSP-31-32.svg'},
      {'title': 'STA 1+300', 'path': 'assets/images/OSP-51-52.svg'}
    ];
    // return Center(child: Text('TEST'));
    return SingleChildScrollView(
        child: Column(
      children: listSvg.map((svg) {
        return GFCard(
          margin: EdgeInsets.all(10.r),
          padding: EdgeInsets.all(5.r),
          boxFit: BoxFit.cover,
          color: GFColors.WHITE,
          title: GFListTile(
            title: Text(
              svg['title'] ?? 'No Title',
              style: TextStyle(
                color: GFColors.DARK,
                fontWeight: FontWeight.bold,
                fontSize: 12.r,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          content: SvgPicture.asset(
            svg['path'] ?? '',
            width: double.infinity,
            height: 300.r,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => const CircularProgressIndicator(),
          ),
        );
      }).toList(),
    ));
  }

  bool _isWithinTargetArea(Offset position) {
    // Define the specific target coordinates and dimensions
    const double targetX = 100; // X position of target area
    const double targetY = 100; // Y position of target area
    const double targetWidth = 50; // Width of target area
    const double targetHeight = 50; // Height of target area

    return position.dx >= targetX &&
        position.dx <= targetX + targetWidth &&
        position.dy >= targetY &&
        position.dy <= targetY + targetHeight;
  }

  void _showCoordinateDialog(BuildContext context, Offset position) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Coordinates"),
          content: Text(
              "X: ${position.dx.toStringAsFixed(2)}, Y: ${position.dy.toStringAsFixed(2)}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _chartTab(BuildContext context, OpenStandpipeController controller) {
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
            OpenStandpipeModel model =
                OpenStandpipeModel(listIntake: [], listOpenStandpipe: []);
            if (snapshot.data != null) {
              model = snapshot.data!;
            }
            return GetBuilder<OpenStandpipeController>(
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
                            title: AxisTitle(text: 'Muka Air (m)'),
                          ),
                          axes: [
                            NumericAxis(
                              title: const AxisTitle(text: 'TMA INTAKE (mdpl)'),
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
                            text: 'Grafik Tinggi Muka Air',
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
                                                          ? "TMA EP.1: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                          : (trackballDetails
                                                                      .seriesIndex ==
                                                                  3)
                                                              ? "TMA EP.2: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                              : (trackballDetails
                                                                          .seriesIndex ==
                                                                      4)
                                                                  ? "TMA EP.3: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                  : (trackballDetails
                                                                              .seriesIndex ==
                                                                          5)
                                                                      ? "TMA EP.4: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                      : (trackballDetails.seriesIndex ==
                                                                              6)
                                                                          ? "TMA EP.5: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                          : (trackballDetails.seriesIndex == 7)
                                                                              ? "TMA EP.6: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                              : (trackballDetails.seriesIndex == 8)
                                                                                  ? "TMA EP.7: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                                  : (trackballDetails.seriesIndex == 9)
                                                                                      ? "TMA EP.8: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                                      : (trackballDetails.seriesIndex == 10)
                                                                                          ? "TMA EP.9: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                                          : (trackballDetails.seriesIndex == 11)
                                                                                              ? "TMA EP.10: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                                              : (trackballDetails.seriesIndex == 12)
                                                                                                  ? "TMA EP.11: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
                                                                                                  : (trackballDetails.seriesIndex == 13)
                                                                                                      ? "TMA EP.12: ${AppConstants().numFormat.format(trackballDetails.point?.y)} (mdpl)"
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
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF2CAFFE),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp11WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 1.1',
                              color: const Color(0xFF2CAFFE),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF544FC5),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp12WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 1.2',
                              color: const Color(0xFF544FC5),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF00E272),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.rectangle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp21WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 2.1',
                              color: const Color(0xFF00E272),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFFFE6A35),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.triangle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp22WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 2.2',
                              color: const Color(0xFFFE6A35),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF6B8ABC),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.invertedTriangle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp31WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 3.1',
                              color: const Color(0xFF6B8ABC),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFFDE87FC),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.invertedTriangle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp32WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 3.2',
                              color: const Color(0xFFDE87FC),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF47E4D0),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.diamond),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp41WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 4.1',
                              color: const Color(0xFF47E4D0),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFFFA4B42),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.rectangle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp42WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 4.2',
                              color: const Color(0xFFFA4B42),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFFFEB56A),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.triangle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp51WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 5.1',
                              color: const Color(0xFFFEB56A),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF91E8E1),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.invertedTriangle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp52WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 5.2',
                              color: const Color(0xFF91E8E1),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF2CAFFE),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp61WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 6.1',
                              color: const Color(0xFF2CAFFE),
                            ),
                            LineSeries<OpenStandpipe, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF9996DC),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.rectangle),
                              dataSource: model.listOpenStandpipe,
                              xValueMapper: (OpenStandpipe data, _) =>
                                  data.readingDate,
                              yValueMapper: (OpenStandpipe data, _) =>
                                  data.sensorOsp62WaterLevel ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA OSP. 6.2',
                              color: const Color(0xFF9996DC),
                            ),
                            LineSeries<Intake, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Color(0xFF3281F3),
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.rectangle),
                              dataSource: model.listIntake,
                              xValueMapper: (Intake data, _) =>
                                  data.readingDate,
                              yValueMapper: (Intake data, _) =>
                                  data.waterLevel ?? 0,
                              yAxisName: 'InvertedAxis',
                              name: 'TMA INTAKE',
                              color: const Color(0xFF3281F3),
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

  Widget _tableTab(BuildContext context, OpenStandpipeController controller) {
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
            return GetBuilder<OpenStandpipeController>(
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
                              160.r,
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
                                  //OSP11
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp11WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp11ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp11TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP12
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp12WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp12ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp12TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP21
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp21WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp21ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp21TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP22
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp22WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp22ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp22TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP31
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp31WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp31ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp31TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP32
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp32WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp32ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp32TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP41
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp41WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp41ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp41TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP42
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp42WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp42ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp42TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP51
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp51WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp51ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp51TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP52
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp52WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp52ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp52TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP61
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp61WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp61ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp61TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //OSP62
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp62WaterLevel',
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
                                                text: 'Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (m)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp62ElvWaterLevel',
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
                                                text: 'Elv. Muka Air',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Mdpl)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    minimumWidth: 100.r,
                                    columnName: 'sensorOsp62TekananPori',
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
                                                text: 'Tekanan Pori',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (MH₂O)',
                                                style: TextStyle(
                                                    fontSize: 12.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                stackedHeaderRows: <StackedHeaderRow>[
                                  StackedHeaderRow(cells: [
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp11WaterLevel',
                                          'sensorOsp11ElvWaterLevel',
                                          'sensorOsp11TekananPori',
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
                                              child: Text('OSP 1.1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp12WaterLevel',
                                          'sensorOsp12ElvWaterLevel',
                                          'sensorOsp12TekananPori',
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
                                              child: Text('OSP 1.2',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp21WaterLevel',
                                          'sensorOsp21ElvWaterLevel',
                                          'sensorOsp21TekananPori',
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
                                              child: Text('OSP 2.1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp22WaterLevel',
                                          'sensorOsp22ElvWaterLevel',
                                          'sensorOsp22TekananPori',
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
                                              child: Text('OSP 2.2',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp31WaterLevel',
                                          'sensorOsp31ElvWaterLevel',
                                          'sensorOsp31TekananPori',
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
                                              child: Text('OSP 3.1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp32WaterLevel',
                                          'sensorOsp32ElvWaterLevel',
                                          'sensorOsp32TekananPori',
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
                                              child: Text('OSP 3.2',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp41WaterLevel',
                                          'sensorOsp41ElvWaterLevel',
                                          'sensorOsp41TekananPori',
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
                                              child: Text('OSP 4.1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp42WaterLevel',
                                          'sensorOsp42ElvWaterLevel',
                                          'sensorOsp42TekananPori',
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
                                              child: Text('OSP 4.2',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp51WaterLevel',
                                          'sensorOsp51ElvWaterLevel',
                                          'sensorOsp51TekananPori',
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
                                              child: Text('OSP 5.1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp52WaterLevel',
                                          'sensorOsp52ElvWaterLevel',
                                          'sensorOsp52TekananPori',
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
                                              child: Text('OSP 5.2',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp61WaterLevel',
                                          'sensorOsp61ElvWaterLevel',
                                          'sensorOsp61TekananPori',
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
                                              child: Text('OSP 6.1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorOsp62WaterLevel',
                                          'sensorOsp62ElvWaterLevel',
                                          'sensorOsp62TekananPori',
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
                                              child: Text('OSP 6.2',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                  ]),
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
