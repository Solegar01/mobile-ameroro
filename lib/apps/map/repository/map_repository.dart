import 'dart:convert';

import 'package:mobile_ameroro_app/apps/map/models/map_model.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class MapRepository {
  final ApiService apiService;
  MapRepository(this.apiService);

  Future<List<MapModel>> fetchData() async {
    final response = await apiService.get('map');
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      // Pastikan data yang diterima berupa List, lalu map ke dalam model
      return (jsonResponse['data'] as List)
          .map((data) => MapModel.fromJson(data))
          .toList();
    } else {
      throw Exception(jsonResponse['message']);
    }
  }
}
