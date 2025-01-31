import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_ameroro_app/apps/map/models/map_model.dart';
import 'package:mobile_ameroro_app/apps/map/repository/map_repository.dart';
import 'package:mobile_ameroro_app/apps/map/views/map_view.dart';
import 'package:uuid/uuid.dart';

class MapController extends GetxController with StateMixin<List<MapModel>> {
  final MapRepository repository;
  MapController(this.repository);

  var maps = <MapModel>[].obs;
  var markers = <Marker>{}.obs;
  bool isLoading = false;
  GoogleMapController? _mapController;
  MapType _currentMapType = MapType.satellite;

  MapType get currentMapType => _currentMapType;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading = true;
    update();
    try {
      final data = await repository.fetchData();
      maps.value = data;
      await _createMarkers();
      update();
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> _createMarkers() async {
    markers.clear();
    var uid = const Uuid();
    for (int i = 0; i < maps.length; i++) {
      if (maps[i].latitude != null && maps[i].longitude != null) {
        final marker = await MarkerManager.createMarker(maps[i], uid.v4());
        markers.add(marker);
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    update();
  }

  void toggleMapType() {
    _currentMapType =
        _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    update();
  }
}
