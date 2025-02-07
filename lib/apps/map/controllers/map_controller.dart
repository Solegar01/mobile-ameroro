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
  var checkedInstrument = <String, bool>{
    'AWLR': true,
    'ARR': true,
    'OW': true,
    'AWS': true,
    'CCTV': true,
    'INTAKE': true,
  }.obs;
  RxBool mapIsLoading = false.obs;
  MapType get currentMapType => _currentMapType;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    try {
      final data = await repository.fetchData();
      maps.value = data;
      await _createMarkers();
      change(null, status: RxStatus.success());
    } catch (e) {
      print('Error fetching data: $e');
      change(null, status: RxStatus.error());
    }
  }

  Future<void> toggleCheckbox(String item, bool val) async {
    checkedInstrument[item] = val;
    await _createMarkers();
  }

  Future<void> _createMarkers() async {
    mapIsLoading.value = true;
    markers.clear();
    var uid = const Uuid();
    for (int i = 0; i < maps.length; i++) {
      if (checkedInstrument[maps[i].instrumentType ?? ''] == true) {
        if (maps[i].latitude != null && maps[i].longitude != null) {
          final marker = await MarkerManager.createMarker(maps[i], uid.v4());
          markers.add(marker);
        }
      }
    }
    mapIsLoading.value = false;
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
