import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/vibrating_wire/controllers/vibrating_wire_controller.dart';
import 'package:mobile_ameroro_app/apps/instruments/vibrating_wire/models/vibrating_wire_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VibratingWireView extends StatelessWidget {
  final VibratingWireController controller =
      Get.find<VibratingWireController>();
  final _formKey = GlobalKey<FormState>();
  final instrumentKey = GlobalKey<DropdownSearchState>();
  final elevationKey = GlobalKey<DropdownSearchState>();

  VibratingWireView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: GFColors.WHITE,
              title: GetBuilder<VibratingWireController>(
                builder: (controller) => Text(
                  'VIBRATING WIRE',
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

  _detail(BuildContext context, VibratingWireController controller) {
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
                    DropdownSearch<Map<String, String>>(
                      key: instrumentKey,
                      onChanged: (value) async {
                        if (value != null) {
                          controller.selectedInstrument.value = value;
                          controller.selectedElevation.value = <String, String>{
                            'id': '',
                            'text': 'Semua'
                          };
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
                          controller.selectedInstrument as Map<String, String>,
                      items: (filter, infiniteScrollProps) =>
                          controller.instrumentTypes,
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Jenis Instrument',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),
                      itemAsString: (Map<String, String> item) =>
                          item['text'] ?? 'Unknown',
                      compareFn: (Map<String, String>? item,
                          Map<String, String>? selectedItem) {
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

  _selectDate(BuildContext context, VibratingWireController controller) async {
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
    return SingleChildScrollView(
      child: GFCard(
        margin: EdgeInsets.all(10.r),
        padding: EdgeInsets.all(5.r),
        boxFit: BoxFit.cover,
        color: GFColors.WHITE,
        content: SvgPicture.asset(
          'assets/images/gambar-pondasi.svg',
          width: double.infinity,
          height: 300.r,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
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

  Widget _chartTab(BuildContext context, VibratingWireController controller) {
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
            VibratingWireModel? model;
            if (snapshot.data != null) {
              model = snapshot.data!;
            }
            return GetBuilder<VibratingWireController>(
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
                              title: AxisTitle(text: 'Curah Hujan (mm)'),
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
                            AreaSeries<Intake, DateTime>(
                              borderColor: Colors.blue[700]!,
                              borderDrawMode: BorderDrawMode.top,
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listIntake,
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
                              dataSource: model?.listRainFall,
                              xValueMapper: (RainFall data, _) =>
                                  data.readingDate,
                              yValueMapper: (RainFall data, _) =>
                                  data.curahHujan ?? 0,
                              yAxisName: 'InvertedAxis',
                              name: 'Curah Hujan',
                              borderRadius: BorderRadius.circular(5),
                              width: 0.5.r,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp1R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.1',
                              color: GFColors.DANGER,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp2R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.2',
                              color: GFColors.WARNING,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp3R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.3',
                              color: GFColors.SUCCESS,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp4R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.4',
                              color: GFColors.INFO,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp5R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.5',
                              color: GFColors.ALT,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp6R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.6',
                              color: Colors.amber,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp7R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.7',
                              color: Colors.amberAccent,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp8R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.8',
                              color: Colors.blue,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp9R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.9',
                              color: Colors.cyan,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp10R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.10',
                              color: Colors.deepOrange,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp11R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.11',
                              color: Colors.deepPurple,
                            ),
                            LineSeries<VibratingWire, DateTime>(
                              markerSettings: const MarkerSettings(
                                  color: Colors.white,
                                  // isVisible: true,
                                  // Marker shape is set to diamond
                                  shape: DataMarkerType.circle),
                              dataSource: model?.listVibratingWire ?? [],
                              xValueMapper: (VibratingWire data, _) =>
                                  data.readingDate,
                              yValueMapper: (VibratingWire data, _) =>
                                  data.sensorEp12R1 ?? 0,
                              yAxisName: 'primaryYAxis',
                              name: 'TMA EP.12',
                              color: Colors.pinkAccent,
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

  Widget _tableTab(BuildContext context, VibratingWireController controller) {
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
            return GetBuilder<VibratingWireController>(
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
                                  //EP1
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp1R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp1WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp1WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp1Elevation',
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
                                  //EP2
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp2R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp2WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp2WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp2Elevation',
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
                                  //EP3
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp3R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp3WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp3WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp3Elevation',
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
                                  //EP4
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp4R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp4WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp4WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp4Elevation',
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
                                  //EP5
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp5R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp5WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp5WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp5Elevation',
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
                                  //EP6
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp6R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp6WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp6WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp6Elevation',
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
                                  //EP7
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp7R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp7WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp7WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp7Elevation',
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
                                  //EP8
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp8R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp8WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp8WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp8Elevation',
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
                                  //EP9
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp9R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp9WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp9WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp9Elevation',
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
                                  //EP10
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp10R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp10WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp10WaterPressureM',
                                    label: Container(
                                      padding: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp10Elevation',
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
                                  //EP11
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp11R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp11WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp11WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp11Elevation',
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
                                  //EP12
                                  GridColumn(
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp12R1',
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
                                                text: 'R₁',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (Hz²/1000)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp12WaterPressureE',
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
                                                text: 'E',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (kPa)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp12WaterPressureM',
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
                                                text: 'm',
                                                style: TextStyle(
                                                    fontSize: 10.r,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: ' (H₂O)',
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
                                    minimumWidth: 80.r,
                                    columnName: 'sensorEp12Elevation',
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
                                    minimumWidth: 180.r,
                                    columnName: 'pileElevation',
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
                                          topRight: Radius.circular(10.r),
                                        ),
                                      ),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Elevasi Timbanan ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: '(mdpl)',
                                                style: TextStyle(
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
                                          'sensorEp1R1',
                                          'sensorEp1WaterPressureE',
                                          'sensorEp1WaterPressureM',
                                          'sensorEp1Elevation',
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
                                              child: Text('EP.1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp2R1',
                                          'sensorEp2WaterPressureE',
                                          'sensorEp2WaterPressureM',
                                          'sensorEp2Elevation',
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
                                              child: Text('EP.2',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp3R1',
                                          'sensorEp3WaterPressureE',
                                          'sensorEp3WaterPressureM',
                                          'sensorEp3Elevation',
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
                                              child: Text('EP.3',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp4R1',
                                          'sensorEp4WaterPressureE',
                                          'sensorEp4WaterPressureM',
                                          'sensorEp4Elevation',
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
                                              child: Text('EP.4',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp5R1',
                                          'sensorEp5WaterPressureE',
                                          'sensorEp5WaterPressureM',
                                          'sensorEp5Elevation',
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
                                              child: Text('EP.5',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp6R1',
                                          'sensorEp6WaterPressureE',
                                          'sensorEp6WaterPressureM',
                                          'sensorEp6Elevation',
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
                                              child: Text('EP.6',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp7R1',
                                          'sensorEp7WaterPressureE',
                                          'sensorEp7WaterPressureM',
                                          'sensorEp7Elevation',
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
                                              child: Text('EP.7',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp8R1',
                                          'sensorEp8WaterPressureE',
                                          'sensorEp8WaterPressureM',
                                          'sensorEp8Elevation',
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
                                              child: Text('EP.8',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp9R1',
                                          'sensorEp9WaterPressureE',
                                          'sensorEp9WaterPressureM',
                                          'sensorEp9Elevation',
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
                                              child: Text('EP.9',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp10R1',
                                          'sensorEp10WaterPressureE',
                                          'sensorEp10WaterPressureM',
                                          'sensorEp10Elevation',
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
                                              child: Text('EP.10',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp11R1',
                                          'sensorEp11WaterPressureE',
                                          'sensorEp11WaterPressureM',
                                          'sensorEp11Elevation',
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
                                              child: Text('EP.11',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp12R1',
                                          'sensorEp12WaterPressureE',
                                          'sensorEp12WaterPressureM',
                                          'sensorEp12Elevation',
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
                                              child: Text('EP.12',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                  ]),
                                  StackedHeaderRow(cells: [
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp1WaterPressureE',
                                          'sensorEp1WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp2WaterPressureE',
                                          'sensorEp2WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp3WaterPressureE',
                                          'sensorEp3WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp4WaterPressureE',
                                          'sensorEp4WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp5WaterPressureE',
                                          'sensorEp5WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp6WaterPressureE',
                                          'sensorEp6WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp7WaterPressureE',
                                          'sensorEp7WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp8WaterPressureE',
                                          'sensorEp8WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp9WaterPressureE',
                                          'sensorEp9WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp10WaterPressureE',
                                          'sensorEp10WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp11WaterPressureE',
                                          'sensorEp11WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                    StackedHeaderCell(
                                        columnNames: [
                                          'sensorEp12WaterPressureE',
                                          'sensorEp12WaterPressureM',
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
                                              child: Text('Data Tekanan Air',
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
