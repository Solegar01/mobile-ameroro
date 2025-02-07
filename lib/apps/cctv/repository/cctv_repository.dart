import 'dart:convert';

import 'package:mobile_ameroro_app/apps/cctv/models/cctv_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';

class CctvRepository {
  final ApiService apiService;
  CctvRepository(this.apiService);

  Future<List<CctvModel>> getAllCctvs() async {
    final response = await apiService.get(AppConstants.cctvUrl);
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      // Pastikan data yang diterima berupa List, lalu map ke dalam model
      return (jsonResponse['data'] as List)
          .map((data) => CctvModel.fromJson(data))
          .toList();
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  Future<CctvModel> update(String id, CctvModel update) async {
    try {
      final body = update.toJson();
      final response = await apiService.put('cctv/$id', body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Coba beberapa kemungkinan struktur response
        Map<String, dynamic> cctvData;

        if (jsonResponse['data'] != null) {
          cctvData = jsonResponse['data'];
        } else if (jsonResponse['success'] == true &&
            jsonResponse['message'] != null) {
          cctvData = body;
        } else if (jsonResponse is Map<String, dynamic>) {
          cctvData = jsonResponse;
        } else {
          cctvData = body;
        }

        return CctvModel(
          id: id,
          name: cctvData['name'] ?? update.name,
          url: cctvData['url'] ?? update.url,
          latitude: cctvData['latitude']?.toDouble() ?? update.latitude,
          longitude: cctvData['longitude']?.toDouble() ?? update.longitude,
          note: cctvData['note'] ?? update.note,
          createdAt: cctvData['created_at'],
          updatedAt: cctvData['updated_at'],
        );
      } else {
        throw Exception('Failed to update CCTV');
      }
    } catch (e) {
      print('Error updating CCTV: $e');
      rethrow;
    }
  }
}
