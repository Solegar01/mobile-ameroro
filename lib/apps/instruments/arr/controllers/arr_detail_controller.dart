import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_day_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_hour_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_minute_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/repository/arr_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';

class ArrDetailController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  final ArrRepository repository;
  ArrDetailController(this.repository);
  late AnimationController animationController;
  late Animation<double> animation;

  ArrModel? model;
  List<ArrDetailHourModel> detailHourModel = List.empty(growable: true);
  List<ArrDetailDayModel> detailDayModel = List.empty(growable: true);
  List<ArrDetailMinuteModel> detailMinuteModel = List.empty(growable: true);
  Rx<DataFilterType> filterType = DataFilterType.fiveMinutely.obs;
  final List<DataFilterType> listFilterType = DataFilterType.values;
  Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>(
      DateTimeRange(start: DateTime.now(), end: DateTime.now()));
  TextEditingController dateRangeController = TextEditingController();
  late TabController tabController;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);
    // Initialize the AnimationController
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat animation back and forth

    // Define the animation as a tween between 0.0 (invisible) and 1.0 (fully visible)
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    await formInit();
    change(null, status: RxStatus.success());
    super.onInit();
  }

  @override
  void dispose() {
    animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  formInit() async {
    dateRangeController.text =
        '${AppConstants().dateFormatID.format(selectedDateRange.value!.start)} - ${AppConstants().dateFormatID.format(selectedDateRange.value!.end)}';
    await getCacheData();
  }

  Future<List<ArrDetailHourModel>> getChartDataHour() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return detailHourModel;
  }

  Future<List<ArrDetailMinuteModel>> getChartDataMinute() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return detailMinuteModel;
  }

  Future<List<ArrDetailDayModel>> getChartDataDay() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return detailDayModel;
  }

  Future<void> getCacheData() async {
    change(null, status: RxStatus.loading());
    model = null;
    try {
      await repository.getCacheData().then((response) {
        model = response;
      });
      change(null, status: RxStatus.success());
    } catch (e) {
      msgToast(e.toString());
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> getDataHour() async {
    change(null, status: RxStatus.loading());
    detailHourModel.clear();
    try {
      await repository
          .getDataDetailHour(model!.deviceId ?? '',
              selectedDateRange.value!.start, selectedDateRange.value!.end)
          .then((response) {
        detailHourModel = response;
      });
      // tableDataSourceHour = TableDataSourceHour();
      // updateDisplayedDataHour();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      msgToast(e.toString());
    }
  }

  Future<void> getDataDay() async {
    change(null, status: RxStatus.loading());
    detailDayModel.clear();
    try {
      await repository
          .getDataDetailDay(model!.deviceId ?? '',
              selectedDateRange.value!.start, selectedDateRange.value!.end)
          .then((response) {
        detailDayModel = response;
      });
      // tableDataSourceDay = TableDataSourceDay();
      // updateDisplayedDataDay();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      msgToast(e.toString());
    }
  }

  Future<void> getDataMinute() async {
    change(null, status: RxStatus.loading());
    detailMinuteModel.clear();
    try {
      await repository
          .getDataDetailMinute(model!.deviceId ?? '',
              selectedDateRange.value!.start, selectedDateRange.value!.end)
          .then((response) {
        detailMinuteModel = response;
      });
      // tableDataSourceMinute = TableDataSourceMinute();
      // updateDisplayedDataMinute();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      msgToast(e.toString());
    }
  }
}
