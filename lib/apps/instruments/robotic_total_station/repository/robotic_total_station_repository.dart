import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/models/open_standpipe_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/robotic_total_station/models/robotic_total_station_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class RoboticTotalStationRepository {
  final ApiService apiService;
  RoboticTotalStationRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<List<RoboticTotalStationModel>> getData(
      DateTime startDate, DateTime endDate) async {
    List<RoboticTotalStationModel> result = List.empty(growable: true);

    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);
        var params =
            '${AppConstants.rtsUrl}?start_date=$formattedStart&end_date=$formattedEnd';
        final response = await apiService.get(params);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          List<dynamic>? rtsList = jsonResponse['data'];
          if (rtsList != null) {
            if (rtsList.isNotEmpty) {
              for (var item in rtsList) {
                result.add(RoboticTotalStationModel.fromJson(item));
              }
            }
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }

    return result;
  }
}
