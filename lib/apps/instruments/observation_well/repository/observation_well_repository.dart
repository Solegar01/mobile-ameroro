import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/observation_well/models/observation_well_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class ObservationWellRepository {
  final ApiService apiService;
  ObservationWellRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<List<Map<String, dynamic>>> getSensorList() async {
    List<Map<String, dynamic>> datas = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get(AppConstants.owsSensorUrl);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var data in jsonResponse['data'] as List) {
            datas.add(data);
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      rethrow;
    }
    return datas;
  }

  Future<ObservationWellModel?> getData(
      String? sensor, DateTime startDate, DateTime endDate) async {
    // Initialize the result
    ObservationWellModel result = ObservationWellModel(
      listObservationWell: [],
      listIntake: [],
      listRainFall: [],
    );

    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);

        // Set params based on whether `sensor` is null or not
        var params = sensor == null
            ? '${AppConstants.owsUrl}?start_date=$formattedStart&end_date=$formattedEnd'
            : '${AppConstants.owsUrl}?sensor=$sensor&start_date=$formattedStart&end_date=$formattedEnd';

        params =
            '${AppConstants.owsUrl}?start_date=2018-03-01&end_date=2018-03-30';
        final response = await apiService.get(params);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          List<dynamic>? vList = jsonResponse['data']['observationWell'];
          List<dynamic>? iList = jsonResponse['data']['intake'];
          List<dynamic>? rList = jsonResponse['data']['rainfall'];

          if (vList != null) {
            for (var item in vList) {
              result.listObservationWell?.add(ObservationWell.fromJson(item));
            }
          }
          if (iList != null) {
            for (var item in iList) {
              var tempList = item as List;
              if (tempList.isNotEmpty) {
                if (tempList[0] != null && tempList[1] != null) {
                  result.listIntake?.add(Intake(
                      readingDate:
                          DateTime.fromMillisecondsSinceEpoch(tempList[0]),
                      waterLevel: tempList[1].toDouble()));
                }
              }
            }
          }
          if (rList != null) {
            for (var item in rList) {
              var tempList = item as List;
              if (tempList.isNotEmpty) {
                if (tempList[0] != null && tempList[1] != null) {
                  result.listRainFall?.add(RainFall(
                      readingDate:
                          DateTime.fromMillisecondsSinceEpoch(tempList[0]),
                      curahHujan: tempList[1].toDouble()));
                }
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
