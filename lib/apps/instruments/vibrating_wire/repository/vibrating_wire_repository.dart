import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/vibrating_wire/models/vibrating_wire_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class VibratingWireRepository {
  final ApiService apiService;
  VibratingWireRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<List<Map<String, dynamic>>> getListElevation(
      String instrumentType) async {
    List<Map<String, dynamic>> result = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response =
            await apiService.get('${AppConstants.vwSensorUrl}/$instrumentType');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          var dataList = jsonResponse as List;
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

  Future<VibratingWireModel?> getData(String instrumentType, String? sensor,
      DateTime startDate, DateTime endDate) async {
    // Initialize the result
    VibratingWireModel result = VibratingWireModel(
      listVibratingWire: [],
      listIntake: [],
      listRainFall: [],
    );

    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);

        // Set params based on whether `sensor` is null or not
        var params = sensor == null
            ? '${AppConstants.vibratingWireUrl}?instrument=$instrumentType&start_date=$formattedStart&end_date=$formattedEnd'
            : '${AppConstants.vibratingWireUrl}?instrument=$instrumentType&sensor=$sensor&start_date=$formattedStart&end_date=$formattedEnd';
        // params =
        //     '${AppConstants.vibratingWireUrl}?instrument=$instrumentType&start_date=2024-08-01&end_date=2024-11-08';
        // Call the API
        final response = await apiService.get(params);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          List<dynamic>? vList = jsonResponse['data']['vibratingWire'];
          List<dynamic>? iList = jsonResponse['data']['intake'];
          List<dynamic>? rList = jsonResponse['data']['rainfall'];

          if (vList != null) {
            for (var item in vList) {
              result.listVibratingWire?.add(VibratingWire.fromJson(item));
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
