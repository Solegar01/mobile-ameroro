import 'dart:convert';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/home/models/graphic_model.dart';
import 'package:mobile_ameroro_app/apps/home/models/weather_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

class HomeRepository {
  final ApiService apiService;
  HomeRepository(this.apiService);
  final connectivityService = Get.find<ConnectivityService>();

  Future<GraphicModel?> getGraphics() async {
    GraphicModel? model;
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get('dashboard');
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          model = GraphicModel(
              listIntake: List.empty(growable: true),
              listRainFall: List.empty(growable: true),
              listVnotch: List.empty(growable: true),
              listAwlr: List.empty(growable: true));
          if (jsonResponse['data']['intake'] != null) {
            for (var item in jsonResponse['data']['intake'] as List) {
              model.listIntake!.add(Intake.fromJson(item));
            }
          }
          if (jsonResponse['data']['rainFall'] != null) {
            for (var item in jsonResponse['data']['rainfall'] as List) {
              var tempList = item as List;
              if (tempList.isNotEmpty) {
                if (tempList[0] != null && tempList[1] != null) {
                  model.listRainFall?.add(RainFall(
                      readingAt:
                          DateTime.fromMillisecondsSinceEpoch(tempList[0]),
                      rainFall: tempList[1].toDouble()));
                }
              }
            }
          }
          if (jsonResponse['data']['vnotch'] != null) {
            for (var item in jsonResponse['data']['vnotch'] as List) {
              model.listVnotch!.add(Vnotch.fromJson(item));
            }
          }
          if (jsonResponse['data']['awlr'] != null) {
            for (var item in jsonResponse['data']['awlr'] as List) {
              model.listAwlr!.add(Awlr.fromJson(item));
            }
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      }
    } catch (e) {
      rethrow;
    }
    return model;
  }

  Future<WeatherModel?> getWeather() async {
    WeatherModel? model;
    const bmkgUrl =
        'https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=36.04.28.2012';
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response =
            await GetConnect(timeout: Duration(seconds: 30)).get(bmkgUrl);
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

  Future<List<AwlrModel>> getAwlrList() async {
    List<AwlrModel> datas = List.empty(growable: true);
    try {
      if (await connectivityService.checkInternetConnection()) {
        final response = await apiService.get(AppConstants.awlrUrl);
        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          for (var data in jsonResponse['data'] as List) {
            datas.add(AwlrModel.fromJson(data));
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
}
