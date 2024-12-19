import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_ameroro_app/apps/map/controllers/map_controller.dart';
import 'package:mobile_ameroro_app/apps/map/models/map_model.dart';

class PetaView extends StatelessWidget {
  final MapController controller = Get.find<MapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MapController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              GoogleMap(
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: false,
                mapType: controller.currentMapType,
                initialCameraPosition: CameraPosition(
                  target: controller.maps.isNotEmpty
                      ? LatLng(controller.maps[0].latitude ?? -6.1799714,
                          (controller.maps[0].longitude ?? 106.1119974) - 0.0)
                      : LatLng(-6.1799714, 106.1119974 - 0.0),
                  zoom: 17,
                ),
                markers: controller.markers,
                onMapCreated: controller.onMapCreated,
              ),
              Positioned(
                top: 480,
                right: 8,
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: controller.toggleMapType,
                      mini: true,
                      child: Icon(Icons.layers),
                      tooltip: 'Toggle Map Type',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MarkerManager {
  static Future<Marker> createMarker(MapModel map) async {
    BitmapDescriptor markerIcon;

    // Function to create custom icon with specific size
    Future<BitmapDescriptor> createCustomIcon(
        String imagePath, int width, int height) async {
      final Uint8List markerIconBytes =
          await getBytesFromAsset(imagePath, width, height);
      return BitmapDescriptor.fromBytes(markerIconBytes);
    }

    // Choose marker icon based on device type
    if (map.type?.toLowerCase() == 'awlr') {
      markerIcon = await createCustomIcon('assets/images/duga.png', 80, 110);
    } else if (map.type?.toLowerCase() == 'ews') {
      markerIcon = await createCustomIcon('assets/images/ews.png', 80, 110);
    } else if (map.type?.toLowerCase() == 'v-notch') {
      markerIcon = await createCustomIcon('assets/images/v-notch.png', 75, 105);
    } else if (map.type?.toLowerCase() == 'intake') {
      markerIcon = await createCustomIcon('assets/images/duga.png', 80, 110);
    } else {
      markerIcon = BitmapDescriptor.defaultMarker;
    }

    return Marker(
      markerId: MarkerId(map.id ?? '-'),
      position: LatLng(map.latitude ?? 0, map.longitude ?? 0),
      icon: markerIcon,
      onTap: () {
        _showMarkerInfo(
          title: map.name ?? '-',
          status: map.deviceStatus ?? '-',
          logger: '${map.name} (${map.deviceId})',
          coordinates: '${map.latitude}, ${map.longitude}',
          time: map.last_reading != null
              ? _formatDateInIndonesia(map.last_reading!)
              : '-',
          lastdata: _getLastDataLabel(map.type, map.lastData),
          type: map.type ?? '-',
        );
      },
    );
  }

  static String _getLastDataLabel(String? type, double? lastReadingData) {
    if (lastReadingData == null) return '-';

    if (type == 'AWLR') {
      return '$lastReadingData mdpl'; // Height of Water
    } else if (type == 'V-Notch') {
      return '$lastReadingData m'; // Rainfall
    } else {
      return lastReadingData.toString();
    }
  }

  static String _formatDateInIndonesia(DateTime date) {
    final List<String> indonesiaMonths = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    String day = date.day.toString();
    String month = indonesiaMonths[date.month - 1];
    String year = date.year.toString();
    String time = DateFormat('HH:mm').format(date);

    return '$day $month $year, $time WIB';
  }

  static void _showMarkerInfo({
    required String title,
    required String status,
    required String logger,
    required String coordinates,
    required String lastdata,
    required String time,
    required String type,
  }) {
    Get.bottomSheet(
      Stack(
        children: [
          Container(
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.location_on, color: Colors.grey[700]),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: status.toLowerCase() == 'offline'
                          ? Colors.red
                          : status.toLowerCase() == 'online'
                              ? Colors.green
                              : Colors.grey,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      status,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                Divider(),
                _buildInfoRow('Logger      ', logger),
                Divider(),
                _buildInfoRow('Koordinat ', coordinates),
                Divider(),
                _buildInfoRow('Waktu       ', time),
                Divider(),
                _buildInfoRow(
                  'Tinggi Muka Air ',
                  lastdata,
                ),
                Divider(),
                SizedBox(height: 16.0),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.close, color: Colors.grey),
            ),
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8.0),
          Text(value),
        ],
      ),
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
