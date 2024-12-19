import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/vnotch/models/vnotch_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class VNotchRepository {
  final ApiService apiService;
  VNotchRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<List<VNotchModel>> getData(
      DateTime? startDate, DateTime? endDate) async {
    List<VNotchModel> result = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        var params = "";
        if (startDate != null && endDate != null) {
          String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
          String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);
          params = "?start_date=$formattedStart&end_date=$formattedEnd";
          // params = "?start_date=2024-05-01&end_date=2024-05-03";
        }
        final response =
            await apiService.get('${AppConstants.vnotchUrl}$params');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          var dataList = jsonResponse['data'] as List;
          if (dataList.isNotEmpty) {
            for (var item in dataList) {
              result.add(VNotchModel.fromJson(item));
            }
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      rethrow;
    }
    return result;
  }
}
