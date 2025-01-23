import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_detail_day_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_detail_hour_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_detail_minute_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';
import 'package:mobile_ameroro_app/services/local/preference_utils.dart';

class AwlrRepository {
  final ApiService apiService;
  AwlrRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<List<AwlrModel>> getData() async {
    List<AwlrModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get(AppConstants.awlrUrl);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(AwlrModel.fromJson(item));
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

  Future<List<AwlrDetailHourModel>> getDataDetailHour(
      String deviceId, DateTime? startDate, DateTime? endDate) async {
    List<AwlrDetailHourModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.awlrReadingUrl}?device_id=$deviceId&selected_time=hour&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(AwlrDetailHourModel.fromJson(item));
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

  Future<List<AwlrDetailDayModel>> getDataDetailDay(
      String deviceId, DateTime? startDate, DateTime? endDate) async {
    List<AwlrDetailDayModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.awlrReadingUrl}?device_id=$deviceId&selected_time=day&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(AwlrDetailDayModel.fromJson(item));
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

  Future<List<AwlrDetailMinuteModel>> getDataDetailMinute(
      String deviceId, DateTime? startDate, DateTime? endDate) async {
    List<AwlrDetailMinuteModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.awlrReadingUrl}?device_id=$deviceId&selected_time=minute&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(AwlrDetailMinuteModel.fromJson(item));
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

  Future<void> cacheData(AwlrModel model) async {
    try {
      final jsonString = awlrModelToJson(model);
      PreferenceUtils.saveToDisk(AppConstants.selectedAwlr, jsonString);
    } catch (e) {
      throw Exception('Failed to cache data - $e');
    }
  }

  Future<AwlrModel> getCacheData() {
    try {
      final jsonString = PreferenceUtils.getFromDisk(AppConstants.selectedAwlr);
      if (jsonString != null) {
        AwlrModel model = awlrModelFromJson(jsonString);
        return Future.value(model);
      } else {
        throw Exception('No data to retrieve');
      }
    } catch (e) {
      throw Exception('Failed to get data - $e');
    }
  }
}
