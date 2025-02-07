import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/apps/map/controllers/map_controller.dart';
import 'package:mobile_ameroro_app/apps/map/models/map_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';

class PetaView extends StatelessWidget {
  final MapController controller = Get.find<MapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: GFColors.WHITE,
        title: const Text(
          'Peta Lokasi Instrumen',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await controller.getData();
              },
              icon: const Icon(
                Icons.refresh_outlined,
              ))
        ],
      ),
      body: controller.obx(
        (state) => _detail(context, controller),
        onLoading: const GFLoader(
          type: GFLoaderType.circle,
        ),
        onEmpty: const Text('Empty Data'),
        onError: (error) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(error ?? 'An error occured while loading data...!')),
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, MapController controller) {
    return GetBuilder<MapController>(builder: (controller) {
      return Stack(
        children: [
          Obx(
            () => controller.mapIsLoading.isTrue
                ? const Center(
                    child: GFLoader(type: GFLoaderType.circle),
                  )
                : GoogleMap(
                    indoorViewEnabled: true,
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    mapType: controller.currentMapType,
                    initialCameraPosition: const CameraPosition(
                      target:
                          LatLng(-3.908082826074294, 122.01056599652172 - 0.0),
                      zoom: 17,
                    ),
                    markers: controller.markers,
                    onMapCreated: controller.onMapCreated,
                  ),
          ),
          Positioned(
            top: 0, // Right below the AppBar
            left: 0,
            right: 0,
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: GFColors.WHITE,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-1, 1),
                    ),
                  ],
                ),
                child: ExpansionTile(
                    collapsedIconColor: GFColors.DARK,
                    iconColor: GFColors.DARK,
                    shape: const Border(),
                    childrenPadding: const EdgeInsets.only(bottom: 10),
                    title: const Text(
                      'Filter Instrument',
                      style: TextStyle(
                          color: GFColors.DARK, fontWeight: FontWeight.w400),
                    ),
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            controller.checkedInstrument.entries.map((entry) {
                          return IntrinsicWidth(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                checkboxTheme: CheckboxThemeData(
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(50)),
                                  checkColor: WidgetStateProperty.all(Colors
                                      .blueGrey[50]), // Change checkmark color
                                  fillColor: WidgetStateProperty.all(entry.value
                                      ? GFColors.SUCCESS
                                      : GFColors
                                          .LIGHT), // Change background color
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20)),
                                child: CheckboxMenuButton(
                                  trailingIcon: Text(
                                    entry.key,
                                    style: TextStyle(
                                        color: GFColors.DARK,
                                        fontSize: AppConfig.fontSizeSmall),
                                  ),
                                  value: entry.value,
                                  onChanged: (bool? value) async {
                                    await controller.toggleCheckbox(
                                        entry.key, value ?? false);
                                  },
                                  child: ClipRect(
                                    child: Image.asset(
                                      _cbImgPath(entry.key),
                                      width: 30,
                                      height: 30,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Icon(Icons
                                              .error), // Handle missing images
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
            top: 480,
            right: 8,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: controller.toggleMapType,
                  mini: true,
                  tooltip: 'Toggle Map Type',
                  child: const Icon(Icons.layers),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  _cbImgPath(String name) {
    String pathImg = '';
    // Choose marker icon based on device type
    switch (name.toLowerCase()) {
      case 'awlr':
        pathImg = 'assets/images/markers/awlr-marker-circle.png';
        break;
      case 'arr':
        pathImg = 'assets/images/markers/arr-marker-circle.png';
        break;
      case 'ow':
        pathImg = 'assets/images/markers/vw-marker-circle.png';
        break;
      case 'aws':
        pathImg = 'assets/images/markers/klimat-aws-marker-circle.png';
        break;
      case 'cctv':
        pathImg = 'assets/images/markers/cctv-marker-circle.png';
        break;
      case 'intake':
        pathImg = 'assets/images/markers/intake-marker-circle.png';
        break;
      default:
    }
    return pathImg;
  }
}

class MarkerManager {
  static Future<Marker> createMarker(MapModel map, String id) async {
    BitmapDescriptor markerIcon;

    // Function to create custom icon with specific size
    Future<BitmapDescriptor> createCustomIcon(
        String imagePath, int width, int height) async {
      final Uint8List markerIconBytes =
          await getBytesFromAsset(imagePath, width, height);
      return BitmapDescriptor.fromBytes(markerIconBytes);
    }

    // Choose marker icon based on device type
    if (map.instrumentType?.toLowerCase() == 'awlr') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/awlr-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'ews') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/ews-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'v-notch') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/vnotch-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'intake') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/intake-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'klimatologi') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/klimat-manual-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'aws') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/klimat-aws-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'rts') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/rts-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'vibrating-wire' ||
        map.instrumentType?.toLowerCase() == 'ow') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/vw-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'arr') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/arr-marker.png', 80, 203);
    } else if (map.instrumentType?.toLowerCase() == 'cctv') {
      markerIcon = await createCustomIcon(
          'assets/images/markers/cctv-marker.png', 80, 203);
    } else {
      markerIcon = BitmapDescriptor.defaultMarker;
    }

    return Marker(
      markerId: MarkerId(id),
      position: LatLng(map.latitude ?? 0, map.longitude ?? 0),
      icon: markerIcon,
      onTap: () {
        _showMarkerInfo(data: map);
      },
    );
  }

  static Future _showMarkerInfo({required MapModel data}) {
    DeviceStatus deviceStatus = DeviceStatus.offline;
    if ((data.deviceStatus ?? "").toLowerCase() == 'online') {
      deviceStatus = DeviceStatus.online;
    }
    return Get.bottomSheet(
        Wrap(
          children: [
            Container(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: GFColors.WHITE,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text(
                    data.name ?? "-",
                    style: const TextStyle(
                      color: AppConfig.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (data.instrumentType!.toLowerCase() == 'cctv')
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: deviceStatus.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                deviceStatus.name,
                                style: TextStyle(
                                    color: deviceStatus.color,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: deviceStatus.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                deviceStatus.name,
                                style: TextStyle(
                                    color: deviceStatus.color,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: GFColors.DARK.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                data.deviceId ?? "-",
                                style: const TextStyle(
                                    color: GFColors.DARK,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  _bottomContent(data),
                ],
              ),
            ),
          ],
        ),
        isScrollControlled: true);
  }

  static Widget _bottomContent(MapModel data) {
    if (data.instrumentType!.toLowerCase() == 'aws') {
      List<String> content =
          data.lastData == null ? [] : data.lastData?.split('|') ?? [];
      String huStat =
          data.warningStatus == null ? '-' : data.warningStatus!.split('|')[0];
      String rnStat =
          data.warningStatus == null ? '-' : data.warningStatus!.split('|')[1];
      String wnStat =
          data.warningStatus == null ? '-' : data.warningStatus!.split('|')[2];

      return SingleChildScrollView(
        child: Table(
          border: const TableBorder(
            right: BorderSide.none,
            left: BorderSide.none,
            top: BorderSide(color: GFColors.LIGHT, width: 1),
            bottom: BorderSide(color: GFColors.LIGHT, width: 1),
            horizontalInside: BorderSide(color: GFColors.LIGHT, width: 1),
          ), // Adds border to the table
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            // Static Rows
            TableRow(children: [
              tableCell('Update'),
              tableCell(
                  ': ${data.lastReading == null ? '-' : AppConstants().dateTimeFullFormatID.format(data.lastReading!)} WITA'),
            ]),
            TableRow(children: [
              tableCell('Kelembapan'),
              Row(
                children: [
                  tableCell(
                      ': ${content.isEmpty ? '-' : AppConstants().numFormat.format(double.parse(content[0]))} ',
                      unit: '%'),
                  Text(' - $huStat'),
                ],
              ),
            ]),
            TableRow(children: [
              tableCell('Curah Hujan'),
              Row(
                children: [
                  tableCell(
                      ': ${content.isEmpty ? '-' : AppConstants().numFormat.format(double.parse(content[1]))} ',
                      unit: 'mm'),
                  Text(' - $rnStat'),
                ],
              ),
            ]),
            TableRow(children: [
              tableCell('Tekanan'),
              tableCell(
                  ': ${content.isEmpty ? '-' : AppConstants().numFormat.format(double.parse(content[2]))} ',
                  unit: 'MB'),
            ]),
            TableRow(children: [
              tableCell('Radiasi'),
              tableCell(
                  ': ${content.isEmpty ? '-' : AppConstants().numFormat.format(double.parse(content[3]))} ',
                  unit: 'W/m\u00B2'),
            ]),
            TableRow(
              children: [
                tableCell('Lama Penyinaran'),
                tableCell(
                    ': ${content.isEmpty ? '-' : AppConstants().numFormat.format(double.parse(content[4]))} ',
                    unit: 'Jam'),
              ],
            ),
            TableRow(children: [
              tableCell('Suhu'),
              tableCell(
                  ': ${content.isEmpty ? '-' : AppConstants().numFormat.format(double.parse(content[5]))} ',
                  unit: '°C'),
            ]),
            TableRow(children: [
              tableCell('Arah Angin'),
              Row(
                children: [
                  tableCell(
                      ': ${content.isEmpty ? '-' : AppConstants().numFormat.format(double.parse(content[6]))} ',
                      unit: 'km/h'),
                  Text(' - $wnStat'),
                ],
              ),
            ]),
            TableRow(children: [
              tableCell('Penguapan'),
              tableCell(
                  ': ${content.isEmpty ? '-' : AppConstants().numFormat.format(double.parse(content[7]))} ',
                  unit: 'mm'),
            ]),
          ],
        ),
      );
    } else if (data.instrumentType!.toLowerCase() == 'awlr') {
      String tma = data.lastData == null
          ? '-'
          : (data.lastData ?? '').contains('|')
              ? (data.lastData ?? '').split('|')[0]
              : (data.lastData ?? '-');
      String debit = data.lastData == null
          ? '-'
          : (data.lastData ?? '').contains('|')
              ? (data.lastData ?? '').split('|')[1]
              : '-';

      return SingleChildScrollView(
        child: Table(
          border: const TableBorder(
            right: BorderSide.none,
            left: BorderSide.none,
            top: BorderSide(color: GFColors.LIGHT, width: 1),
            bottom: BorderSide(color: GFColors.LIGHT, width: 1),
            horizontalInside: BorderSide(color: GFColors.LIGHT, width: 1),
          ), // Adds border to the table
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            // Static Rows
            TableRow(children: [
              tableCell('Koordinat'),
              tableCell(': ${data.latitude ?? 0.0}, ${data.longitude ?? 0.0}'),
            ]),
            TableRow(children: [
              tableCell('Update'),
              tableCell(
                  ': ${data.lastReading == null ? '-' : AppConstants().dateTimeFullDayFormatID.format(data.lastReading!)} '),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: tma,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, -4),
                                child: const Text(
                                  ' mdpl',
                                  style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
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
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      'TMA',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: debit,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, -4),
                                child: const Text(
                                  ' liter/detik',
                                  style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
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
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      'Debit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
            ]),
          ],
        ),
      );
    } else if (data.instrumentType!.toLowerCase() == 'intake') {
      String tma = (data.lastData ?? '') == ''
          ? '-'
          : (data.lastData ?? '').contains('|')
              ? (data.lastData ?? '').split('|')[0]
              : (data.lastData ?? '-');
      String debit = (data.lastData ?? '') == ''
          ? '-'
          : (data.lastData ?? '').contains('|')
              ? (data.lastData ?? '').split('|')[1]
              : '-';

      return SingleChildScrollView(
        child: Table(
          border: const TableBorder(
            right: BorderSide.none,
            left: BorderSide.none,
            top: BorderSide(color: GFColors.LIGHT, width: 1),
            bottom: BorderSide(color: GFColors.LIGHT, width: 1),
            horizontalInside: BorderSide(color: GFColors.LIGHT, width: 1),
          ), // Adds border to the table
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            // Static Rows
            TableRow(children: [
              tableCell('Koordinat'),
              tableCell(': ${data.latitude ?? 0.0}, ${data.longitude ?? 0.0}'),
            ]),
            TableRow(children: [
              tableCell('Update'),
              tableCell(
                  ': ${data.lastReading == null ? '-' : AppConstants().dateTimeFullDayFormatID.format(data.lastReading!)} '),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: tma,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, -4),
                                child: const Text(
                                  ' mdpl',
                                  style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
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
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      'TMA',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: debit,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, -4),
                                child: const Text(
                                  ' liter/detik',
                                  style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
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
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      'Debit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
            ]),
          ],
        ),
      );
    } else if (data.instrumentType!.toLowerCase() == 'cctv') {
      if (data.url != null) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Image.network(
            data.url!,
            fit: BoxFit.cover, // Ensures the image fits the box
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 50);
            },
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : GFShimmer(
                        child: Container(
                          height: 210,
                          width: double.infinity,
                          color: GFColors.LIGHT,
                        ),
                      ),
          ),
        );
      } else {
        return Container(
            height: 200,
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: const Text('No Image Available')
            // const Icon(Icons.broken_image, size: 50)
            );
      }
    } else if (data.instrumentType!.toLowerCase() == 'arr') {
      String debit = (data.lastData ?? '-');

      return SingleChildScrollView(
        child: Table(
          border: const TableBorder(
            right: BorderSide.none,
            left: BorderSide.none,
            top: BorderSide(color: GFColors.LIGHT, width: 1),
            bottom: BorderSide(color: GFColors.LIGHT, width: 1),
            horizontalInside: BorderSide(color: GFColors.LIGHT, width: 1),
          ), // Adds border to the table
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            // Static Rows
            TableRow(children: [
              tableCell('Update'),
              tableCell(
                  ': ${data.lastReading == null ? '-' : AppConstants().dateTimeFullDayFormatID.format(data.lastReading!)} '),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: debit,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
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
                                        color: Colors.grey,
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
                    const Center(
                        child: Text(
                      'Debit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _getImage(data),
                        Text(
                          data.warningStatus ?? "-",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                  ],
                ),
              ),
            ]),
          ],
        ),
      );
    }
    return Container();
  }

  static Widget tableCell(String text, {String unit = ''}) {
    TextStyle style = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.black87,
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text,
                style: style,
              ),
              WidgetSpan(
                child: Transform.translate(
                  offset: const Offset(2, -4),
                  child: Text(
                    unit,
                    style: const TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontFeatures: [FontFeature.superscripts()]),
                    textScaleFactor: 0.7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static _getImage(MapModel data) {
    String path = 'assets/images/arr/arr-icon-offline.png';
    String sImg = '';
    String sTime = '';
    if (data.lastReading!.hour >= 6 && data.lastReading!.hour < 12) {
      sTime = 'pagi';
    } else if (data.lastReading!.hour >= 12 && data.lastReading!.hour < 16) {
      sTime = 'siang';
    } else if (data.lastReading!.hour >= 16 && data.lastReading!.hour < 19) {
      sTime = 'sore';
    } else {
      sTime = 'malam';
    }

    if ((data.warningStatus ?? '').toLowerCase() == 'tidak ada hujan') {
      sImg = 'berawan';
    } else if ((data.warningStatus ?? '').toLowerCase() == 'hujan ringan') {
      sImg = 'hujan-ringan';
    } else if ((data.warningStatus ?? '').toLowerCase() == 'hujan sedang') {
      sImg = 'hujan-sedang';
    } else if ((data.warningStatus ?? '').toLowerCase() == 'hujan lebat') {
      sImg = 'hujan-lebat';
    } else if ((data.warningStatus ?? '').toLowerCase() ==
        'hujan sangat lebat') {
      sImg = 'hujan-sangat-lebat';
    }

    if (sImg.isNotEmpty && sTime.isNotEmpty) {
      if ((data.warningStatus ?? '').toLowerCase() == 'tidak ada hujan') {
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

  // Function to convert image asset to bytes with specific size
  static Future<Uint8List> getBytesFromAsset(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
