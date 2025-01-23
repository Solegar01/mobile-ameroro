import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_day_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_hour_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_minute_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';
import 'package:mobile_ameroro_app/services/local/preference_utils.dart';

class ArrRepository {
  final ApiService apiService;
  ArrRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<List<ArrModel>> getList() async {
    List<ArrModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get(AppConstants.arrUrl);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(ArrModel.fromJson(item));
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      rethrow;
    }

    return listModel;
  }

  Future<void> cacheData(ArrModel model) async {
    try {
      final jsonString = arrModelToJson(model);
      PreferenceUtils.saveToDisk(AppConstants.selectedArr, jsonString);
    } catch (e) {
      throw Exception('Failed to cache data - $e');
    }
  }

  Future<ArrModel> getCacheData() {
    try {
      final jsonString = PreferenceUtils.getFromDisk(AppConstants.selectedArr);
      if (jsonString != null) {
        ArrModel model = arrModelFromJson(jsonString);
        return Future.value(model);
      } else {
        throw Exception('No data to retrieve');
      }
    } catch (e) {
      throw Exception('Failed to get data - $e');
    }
  }

  Future<List<ArrDetailHourModel>> getDataDetailHour(
      String deviceId, DateTime? startDate, DateTime? endDate) async {
    List<ArrDetailHourModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.arrReadingUrl}?device_id=$deviceId&selected_time=hour&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(ArrDetailHourModel.fromJson(item));
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      rethrow;
    }

    return listModel;
  }

  Future<List<ArrDetailDayModel>> getDataDetailDay(
      String deviceId, DateTime? startDate, DateTime? endDate) async {
    List<ArrDetailDayModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.arrReadingUrl}?device_id=$deviceId&selected_time=day&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(ArrDetailDayModel.fromJson(item));
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      rethrow;
    }

    return listModel;
  }

  Future<List<ArrDetailMinuteModel>> getDataDetailMinute(
      String deviceId, DateTime? startDate, DateTime? endDate) async {
    List<ArrDetailMinuteModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.arrReadingUrl}?device_id=$deviceId&selected_time=minute&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(ArrDetailMinuteModel.fromJson(item));
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      rethrow;
    }

    return listModel;
  }
}
