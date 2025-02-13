import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_day_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_hour_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_minute_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/last_reading_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/models/weather_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class KlimatologiAwsRepository {
  final ApiService apiService;
  KlimatologiAwsRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<LastReadingModel?> getLastReading() async {
    LastReadingModel? model;
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get(AppConstants.awsLastReadingUrl);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          model = (LastReadingModel.fromJson(jsonResponse['data']));
        } else {
          throw Exception("Terjadi kesalahan saat mamuat data terakhir");
        }
      }
    } catch (e) {
      rethrow;
    }

    return model;
  }

  Future<List<KlimatologiAwsMinuteModel>> getDataDetailMinute(
      DateTime? startDate, DateTime? endDate) async {
    List<KlimatologiAwsMinuteModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.awsReadingUrl}?selected_time=minute&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(KlimatologiAwsMinuteModel.fromJson(item));
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

  Future<List<KlimatologiAwsHourModel>> getDataDetailHour(
      DateTime? startDate, DateTime? endDate) async {
    List<KlimatologiAwsHourModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.awsReadingUrl}?selected_time=hour&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(KlimatologiAwsHourModel.fromJson(item));
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

  Future<List<KlimatologiAwsDayModel>> getDataDetailDay(
      DateTime? startDate, DateTime? endDate) async {
    List<KlimatologiAwsDayModel> listModel = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        String formattedStart = DateFormat('yyyy-MM-dd').format(startDate!);
        String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate!);
        final response = await apiService.get(
            '${AppConstants.awsReadingUrl}?selected_time=day&StartDate=$formattedStart&EndDate=$formattedEnd');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var item in jsonResponse['data'] as List) {
            listModel.add(KlimatologiAwsDayModel.fromJson(item));
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

  Future<WeatherModel?> getWeather() async {
    WeatherModel? model;
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await GetConnect().get(AppConstants.bmkgUrl);
        final jsonResponse = json.decode(response.bodyString ?? "");

        if (response.statusCode == 200) {
          model = (WeatherModel.fromJson(jsonResponse));
        } else {
          throw Exception("Terjadi kesalahan saat memanggil service API BMKG");
        }
      }
    } catch (e) {
      rethrow;
    }

    return model;
  }

  Future<List<KlimatologiAwsModel>> getData(
      DateTime? startDate, DateTime? endDate) async {
    List<KlimatologiAwsModel> result = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        var params = "";
        if (startDate != null && endDate != null) {
          String formattedStart = DateFormat('yyyy-MM-dd').format(startDate);
          String formattedEnd = DateFormat('yyyy-MM-dd').format(endDate);
          params = "?start_date=$formattedStart&end_date=$formattedEnd";
          // params = "?start_date=2024-05-01&end_date=2024-05-03";
        }
        final response = await apiService.get('${AppConstants.awsUrl}$params');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          var dataList = jsonResponse['data'] as List;
          if (dataList.isNotEmpty) {
            for (var item in dataList) {
              result.add(KlimatologiAwsModel.fromJson(item));
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
