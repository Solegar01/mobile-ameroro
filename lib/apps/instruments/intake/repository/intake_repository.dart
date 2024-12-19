import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/models/intake_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/models/station_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class IntakeRepository {
  final ApiService apiService;
  IntakeRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<IntakeModel?> getData(DateTime? startDate, DateTime? endDate) async {
    IntakeModel? result;
    try {
      if (await connectivityService.checkInternetConnection()) {
        var params = "";
        if (startDate != null && endDate != null) {
          String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
          String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);
          params = "?start_date=$formattedStart&end_date=$formattedEnd";
        }
        final response =
            await apiService.get('${AppConstants.intakeUrl}$params');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          result = (IntakeModel.fromJson(jsonResponse['data']));
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      rethrow;
    }
    return result;
  }

  Future<Station?> getStation(String deviceId) async {
    Station? result;
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response =
            await apiService.get('${AppConstants.stationDeviceUrl}/$deviceId');
        final jsonResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          result = (Station.fromJson(jsonResponse['data']));
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
