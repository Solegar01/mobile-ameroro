import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlrlist_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/station_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class AwlrRepository {
  final ApiService apiService;
  AwlrRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<List<AwlrListModel>> getAwlrList() async {
    List<AwlrListModel> datas = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get(AppConstants.awlrUrl);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var data in jsonResponse['data'] as List) {
            datas.add(AwlrListModel.fromJson(data));
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

  Future<List<AwlrModel>> getData(
      String deviceId, DateTime? startDate, DateTime? endDate) async {
    List<AwlrModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        var params = "";
        if (startDate != null && endDate != null) {
          String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
          String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);
          params =
              "?device_id=$deviceId&start_date=$formattedStart&end_date=$formattedEnd";
        }
        final response =
            await apiService.get('${AppConstants.awlrDetailUrl}$params');
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
