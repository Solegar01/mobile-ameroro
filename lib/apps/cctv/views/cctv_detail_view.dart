import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:mobile_ameroro_app/apps/cctv/controllers/cctv_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_ameroro_app/apps/cctv/models/cctv_model.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:photo_view/photo_view.dart';

class CctvDetailView extends StatelessWidget {
  final CctvController controller = Get.find<CctvController>();
  final CctvModel model = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: GFColors.WHITE,
          title: Text(
            model.name,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0), // Tinggi TabBar
            child: Container(
              color: Colors.blueGrey[50],
              child: const TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4.0,
                    color: AppConfig.primaryColor,
                  ),
                ),
                tabs: [
                  Tab(text: "CCTV"),
                  Tab(text: "LOKASI"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            PhotoViewScreen(imageUrl: model.url),
            GoogleMapView(data: model),
          ],
        ),
      ),
    );
  }
}

// Widget Google Maps
class GoogleMapView extends StatelessWidget {
  final CctvModel data;
  final controller = Get.find<CctvController>();

  GoogleMapView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CctvController>(builder: (controller) {
      return Stack(
        children: [
          GoogleMap(
            indoorViewEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: false,
            mapType: controller.currentMapType,
            initialCameraPosition: CameraPosition(
              target: LatLng((data.latitude ?? -3.908082826074294),
                  (data.longitude ?? (122.01056599652172 - 0.0))),
              zoom: 12,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("1"),
                position: LatLng((data.latitude ?? -3.908082826074294),
                    (data.longitude ?? (122.01056599652172 - 0.0))),
                infoWindow: InfoWindow(title: data.name),
              ),
            },
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
}

// Widget Foto yang Bisa Diperbesar
class PhotoViewScreen extends StatelessWidget {
  final String imageUrl;

  const PhotoViewScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      child: Center(
        child: imageUrl.isEmpty
            ? const Text('Tidak ada gambar yang ditampilkan')
            : PhotoView(
                basePosition: Alignment.topCenter,
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: BoxDecoration(color: Colors.blueGrey[50]),
                loadingBuilder: (context, event) {
                  if (event == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final double progress = event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ?? 1);
                  return Center(
                    child: CircularProgressIndicator(value: progress),
                  );
                },
              ),
      ),
    );
  }
}
