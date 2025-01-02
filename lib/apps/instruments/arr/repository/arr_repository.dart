import 'dart:convert';

import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_model.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/api/api_service.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';

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
}
