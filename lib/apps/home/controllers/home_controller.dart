import 'dart:convert';

import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/home/models/graphic_model.dart';
import 'package:mobile_ameroro_app/apps/home/models/weather_model.dart';
import 'package:mobile_ameroro_app/apps/home/repository/home_repository.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_model.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/services/connectivity/connectivity_service.dart';
import 'package:mobile_ameroro_app/services/mqtt/mqtt_service.dart';

class HomeController extends GetxController with StateMixin {
  final HomeRepository repository;
  HomeController(this.repository);

  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final MqttService mqttService = Get.find<MqttService>();
  Rxn<int> alarmVal = Rxn<int>();
  Rxn<int> muteVal = Rxn<int>();
  Rxn<int> bsh1Status = Rxn<int>();
  Rxn<int> bsh2Status = Rxn<int>();
  Rxn<int> bsh3Status = Rxn<int>();
  Rxn<int> intakeStatus = Rxn<int>();
  RxMap<String, String> bsh1Data = RxMap<String, String>({});
  RxMap<String, String> bsh2Data = RxMap<String, String>({});
  RxMap<String, String> bsh3Data = RxMap<String, String>({});
  RxMap<String, String> intakeData = RxMap<String, String>({});
  late List<String> topics = [
    AppConstants.bsh1Topic,
    AppConstants.bsh2Topic,
    AppConstants.bsh3Topic,
    AppConstants.intakeTopic,
    AppConstants.bsh1StatusTopic,
    AppConstants.bsh2StatusTopic,
    AppConstants.bsh3StatusTopic,
    AppConstants.intakeStatusTopic,
    AppConstants.alarmTopic,
    AppConstants.muteTopic,
  ];

  List<AwlrModel> listAwlr = List.empty(growable: true);
  late GraphicModel graphicModel;

  @override
  void onInit() async {
    connectivityService.isConnected.listen((bool isConnected) async {
      if (isConnected) {
        await formInit();
      }
    });
    change(null, status: RxStatus.success());
    super.onInit();
  }

  @override
  void onClose() async {
    for (var topic in topics) {
      await mqttService.unsubscribeFromTopic(topic);
    }
    super.onClose();
  }

  setSpeakerStatus(String val) async {
    try {
      if (connectivityService.isConnected.value) {
        await mqttService.publishMessage(AppConstants.muteTopic, val,
            retain: true);
      }
    } catch (e) {
      msgToast(e.toString());
    }
  }

  registMqttTopics() {
    try {
      if (mqttService.isClientInitializedAndConnected()) {
        for (var topic in topics) {
          mqttService.subscribeToTopic(topic);
        }
        mqttService.topicMessages.listen((message) {
          for (var msg in message.entries) {
            if (msg.key == AppConstants.alarmTopic) {
              alarmVal.value = int.parse(msg.value);
            } else if (msg.key == AppConstants.muteTopic) {
              muteVal.value = int.parse(msg.value);
            } else if (msg.key == AppConstants.bsh1Topic) {
              Map<String, dynamic> tempMap = jsonDecode(msg.value);
              bsh1Data.value =
                  tempMap.map((key, value) => MapEntry(key, value.toString()));
            } else if (msg.key == AppConstants.bsh2Topic) {
              Map<String, dynamic> tempMap = jsonDecode(msg.value);
              bsh2Data.value =
                  tempMap.map((key, value) => MapEntry(key, value.toString()));
            } else if (msg.key == AppConstants.bsh3Topic) {
              Map<String, dynamic> tempMap = jsonDecode(msg.value);
              bsh3Data.value =
                  tempMap.map((key, value) => MapEntry(key, value.toString()));
            } else if (msg.key == AppConstants.intakeTopic) {
              Map<String, dynamic> tempMap = jsonDecode(msg.value);
              intakeData.value =
                  tempMap.map((key, value) => MapEntry(key, value.toString()));
            } else if (msg.key == AppConstants.bsh1StatusTopic) {
              bsh1Status.value = int.parse(msg.value);
            } else if (msg.key == AppConstants.bsh2StatusTopic) {
              bsh2Status.value = int.parse(msg.value);
            } else if (msg.key == AppConstants.bsh3StatusTopic) {
              bsh3Status.value = int.parse(msg.value);
            } else if (msg.key == AppConstants.intakeStatusTopic) {
              intakeStatus.value = int.parse(msg.value);
            }
          }
        });
      }
    } catch (e) {
      msgToast(e.toString());
    }
  }

  Future<bool> getConnection() async {
    await registMqttTopics();
    return connectivityService.isConnected.value;
  }

  formInit() async {
    change(null, status: RxStatus.loading());
    try {
      // await registMqttTopics();
      graphicModel = GraphicModel(
        listIntake: List.empty(growable: true),
        listRainFall: List.empty(growable: true),
        listVnotch: List.empty(growable: true),
        listAwlr: List.empty(growable: true),
      );
      // await getAwlrList();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<GraphicModel?> getGraphic() async {
    GraphicModel? result;
    try {
      // result = await repository.getGraphics();
    } catch (e) {
      msgToast(e.toString());
    }
    return result;
  }

  Future<List<Cuaca>> getCuacaList() async {
    List<Cuaca> resultList = List.empty(growable: true);
    try {
      var response = await repository.getWeather();
      if (response != null) {
        if (response.data.isNotEmpty) {
          var tempList = response.data[0].cuaca;
          if (tempList.isNotEmpty) {
            for (var item in tempList) {
              resultList.addAll(item);
            }
          }
        }
      }
    } catch (e) {
      msgToast(e.toString());
    }
    return resultList;
  }

  Future<String> getSvgPic(String svgUrl) async {
    try {
      final res = await repository.fetchSvgData(svgUrl);
      return res;
    } catch (e) {
      return '';
    }
  }

  getAwlrList() async {
    change(null, status: RxStatus.loading());
    try {
      listAwlr.clear();
      await repository.getAwlrList().then((values) {
        if (values.isNotEmpty) {
          for (var val in values) {
            listAwlr.add(val);
          }
        }
      });
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
      msgToast(e.toString());
    }
  }
}
