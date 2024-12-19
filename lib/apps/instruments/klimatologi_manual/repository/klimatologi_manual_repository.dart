import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/models/klimatologi_manual_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/models/weather_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class KlimatologiManualRepository {
  final ApiService apiService;
  KlimatologiManualRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<WeatherModel?> getWeather() async {
    WeatherModel? model;
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await GetConnect().get(AppConstants.bmkgUrl);
        final jsonResponse = json.decode(response.bodyString ?? "");

        if (response.statusCode == 200) {
          model = (WeatherModel.fromJson(jsonResponse));
        } else {
          throw Exception("An error occured during call BMKG API service");
        }
      }
    } catch (e) {
      rethrow;
    }

    return model;
  }

  Future<List<KlimatologiManualModel>> getData(
      DateTime? startDate, DateTime? endDate) async {
    List<KlimatologiManualModel> result = List.empty(growable: true);
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
            await apiService.get('${AppConstants.klimatologiManualUrl}$params');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          var dataList = jsonResponse['data'] as List;
          if (dataList.isNotEmpty) {
            for (var item in dataList) {
              result.add(KlimatologiManualModel.fromJson(item));
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

  Future<String> fetchSvgData(String svgUrl) async {
    if (await connectivityService.checkInternetConnection()) {
      final response = await GetConnect().get(svgUrl);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load SVG');
      }
    } else {
      throw Exception('Failed to load SVG');
    }
  }
}
