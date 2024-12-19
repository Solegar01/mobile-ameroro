import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/models/open_standpipe_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class OpenStandpipeRepository {
  final ApiService apiService;
  OpenStandpipeRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<List<Map<String, dynamic>>> getListStation() async {
    List<Map<String, dynamic>> result = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get(AppConstants.ospStationUrl);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          var dataList = jsonResponse['data'] as List;
          if (dataList.isNotEmpty) {
            for (var item in dataList) {
              result.add(item);
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

  Future<List<Map<String, dynamic>>> getListElevation() async {
    List<Map<String, dynamic>> result = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get(AppConstants.ospElevationUrl);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          var dataList = jsonResponse['data'] as List;
          if (dataList.isNotEmpty) {
            for (var item in dataList) {
              result.add(item);
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

  Future<OpenStandpipeModel> getData(String? station, String? elevation,
      DateTime startDate, DateTime endDate) async {
    // Initialize the result
    OpenStandpipeModel result = OpenStandpipeModel(
      listOpenStandpipe: [],
      listIntake: [],
    );

    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);

        var paramStation = station == null ? '' : '&station=$station';
        var paramElevation = elevation == null ? '' : '&elevation=$elevation';
        var params =
            '${AppConstants.ospUrl}?start_date=$formattedStart&end_date=$formattedEnd';
        if (station == null && elevation != null) {
          params += paramElevation;
        } else if (station != null && elevation == null) {
          params += paramStation;
        } else if (station != null && elevation != null) {
          params += '$paramStation$paramElevation';
        }
        final response = await apiService.get(params);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          List<dynamic>? opsList = jsonResponse['data']['openStandPipe'];
          List<dynamic>? intakeList = jsonResponse['data']['intake'];

          if (opsList != null) {
            for (var item in opsList) {
              result.listOpenStandpipe?.add(OpenStandpipe.fromJson(item));
            }
          }
          if (intakeList != null) {
            for (var item in intakeList) {
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
