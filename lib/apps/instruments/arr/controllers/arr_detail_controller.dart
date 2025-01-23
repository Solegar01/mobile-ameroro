import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_day_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_hour_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_detail_minute_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/models/arr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/repository/arr_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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

  late TableDataSourceHour tableDataSourceHour = TableDataSourceHour();
  late TableDataSourceDay tableDataSourceDay = TableDataSourceDay();
  late TableDataSourceMinute tableDataSourceMinute = TableDataSourceMinute();

  final int rowsPerPage = 10; // Rows per page
  RxInt currentPage = 0.obs; // Current page
  RxList<ArrDetailMinuteModel> displayedDataMinute =
      <ArrDetailMinuteModel>[].obs;
  RxList<ArrDetailHourModel> displayedDataHour = <ArrDetailHourModel>[].obs;
  RxList<ArrDetailDayModel> displayedDataDay = <ArrDetailDayModel>[].obs;

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

  Future<TableDataSourceHour> getTableDataSourceHour() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSourceHour;
  }

  Future<TableDataSourceDay> getTableDataSourceDay() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSourceDay;
  }

  Future<TableDataSourceMinute> getTableDataSourceMinute() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSourceMinute;
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
        response.sort((a, b) => b.readingHour!.compareTo(a.readingHour!));
        detailHourModel = response;
      });
      tableDataSourceHour = TableDataSourceHour();
      updateDisplayedDataHour();
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
        response.sort((a, b) => b.readingDate!.compareTo(a.readingDate!));
        detailDayModel = response;
      });
      tableDataSourceDay = TableDataSourceDay();
      updateDisplayedDataDay();
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
        response.sort((a, b) => b.readingAt!.compareTo(a.readingAt!));
        detailMinuteModel = response;
      });
      tableDataSourceMinute = TableDataSourceMinute();
      updateDisplayedDataMinute();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      msgToast(e.toString());
    }
  }

  void updateDisplayedDataHour() {
    int start = currentPage.value * rowsPerPage;
    int end = start + rowsPerPage;
    displayedDataHour.value = detailHourModel.sublist(
      start,
      end > detailHourModel.length ? detailHourModel.length : end,
    );
    tableDataSourceHour.buildPaginatedDataGridRows();
    update(['table']);
  }

  void updateDisplayedDataDay() {
    int start = currentPage.value * rowsPerPage;
    int end = start + rowsPerPage;
    displayedDataDay.value = detailDayModel.sublist(
      start,
      end > detailDayModel.length ? detailDayModel.length : end,
    );
    tableDataSourceDay.buildPaginatedDataGridRows();
    update(['table']);
  }

  void updateDisplayedDataMinute() {
    int start = currentPage.value * rowsPerPage;
    int end = start + rowsPerPage;
    displayedDataMinute.value = detailMinuteModel.sublist(
      start,
      end > detailMinuteModel.length ? detailMinuteModel.length : end,
    );
    tableDataSourceMinute.buildPaginatedDataGridRows();
    update(['table']);
  }
}

class TableDataSourceHour extends DataGridSource {
  final ArrDetailController controller = Get.find<ArrDetailController>();
  TableDataSourceHour() {
    if (controller.detailHourModel.isNotEmpty) {
      int perPage = controller.detailHourModel.length >= controller.rowsPerPage
          ? controller.rowsPerPage
          : controller.detailHourModel.length;
      controller.displayedDataHour.value = controller.detailHourModel
          .getRange(0, perPage)
          .toList(growable: false);
      buildPaginatedDataGridRows();
    }
  }

  List<DataGridRow> _model = [];

  @override
  List<DataGridRow> get rows => _model;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.r),
        child: Text(e.value != null ? e.value.toString() : ' - '),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * controller.rowsPerPage;
    int endIndex = startIndex + controller.rowsPerPage;
    if (startIndex < controller.detailHourModel.length &&
        endIndex <= controller.detailHourModel.length) {
      controller.displayedDataHour.value = controller.detailHourModel
          .getRange(startIndex, endIndex)
          .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      controller.displayedDataHour = RxList.empty(growable: true);
    }

    return true;
  }

  void buildPaginatedDataGridRows() {
    _model = controller.displayedDataHour.map<DataGridRow>((row) {
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'readingHour',
          value: (row.readingHour != null)
              ? AppConstants().dateFormatID.format(row.readingHour!)
              : '-',
        ),
        DataGridCell<String>(
          columnName: 'hourMinuteFormat',
          value: (row.readingHour != null)
              ? AppConstants().hourMinuteFormat.format(row.readingHour!)
              : '-',
        ),
        DataGridCell<double>(
          columnName: 'rainfall',
          value: row.rainfall != null
              ? double.parse(row.rainfall!.toStringAsFixed(2))
              : row.rainfall,
        ),
        DataGridCell<String>(
          columnName: 'intensity',
          value: row.intensity,
        ),
      ]);
    }).toList(growable: false);
  }
}

class TableDataSourceMinute extends DataGridSource {
  final ArrDetailController controller = Get.find<ArrDetailController>();
  TableDataSourceMinute() {
    if (controller.detailMinuteModel.isNotEmpty) {
      int perPage =
          controller.detailMinuteModel.length >= controller.rowsPerPage
              ? controller.rowsPerPage
              : controller.detailMinuteModel.length;
      controller.displayedDataMinute.value = controller.detailMinuteModel
          .getRange(0, perPage)
          .toList(growable: false);
      buildPaginatedDataGridRows();
    }
  }

  List<DataGridRow> _model = [];

  @override
  List<DataGridRow> get rows => _model;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.r),
        child: Text(e.value != null ? e.value.toString() : ' - '),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * controller.rowsPerPage;
    int endIndex = startIndex + controller.rowsPerPage;
    if (startIndex < controller.detailMinuteModel.length &&
        endIndex <= controller.detailMinuteModel.length) {
      controller.displayedDataMinute.value = controller.detailMinuteModel
          .getRange(startIndex, endIndex)
          .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      controller.displayedDataMinute = RxList.empty(growable: true);
    }

    return true;
  }

  void buildPaginatedDataGridRows() {
    _model = controller.displayedDataMinute.map<DataGridRow>((row) {
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'readingAt',
          value: (row.readingAt) != null
              ? AppConstants().dateFormatID.format(row.readingAt!)
              : '-',
        ),
        DataGridCell<String>(
          columnName: 'hourMinuteFormat',
          value: (row.readingAt) != null
              ? AppConstants().hourMinuteFormat.format(row.readingAt!)
              : '-',
        ),
        DataGridCell<double>(
          columnName: 'rainfall',
          value: row.rainfall != null
              ? double.parse(row.rainfall!.toStringAsFixed(2))
              : row.rainfall,
        ),
        DataGridCell<int>(
          columnName: 'batteryCapacity',
          value: row.batteryCapacity,
        ),
      ]);
    }).toList(growable: false);
  }
}

class TableDataSourceDay extends DataGridSource {
  final ArrDetailController controller = Get.find<ArrDetailController>();
  TableDataSourceDay() {
    if (controller.detailDayModel.isNotEmpty) {
      int perPage = controller.detailDayModel.length >= controller.rowsPerPage
          ? controller.rowsPerPage
          : controller.detailDayModel.length;
      controller.displayedDataDay.value = controller.detailDayModel
          .getRange(0, perPage)
          .toList(growable: false);
      buildPaginatedDataGridRows();
    }
  }

  List<DataGridRow> _model = [];

  @override
  List<DataGridRow> get rows => _model;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.r),
        child: Text(e.value != null ? e.value.toString() : ' - '),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * controller.rowsPerPage;
    int endIndex = startIndex + controller.rowsPerPage;
    if (startIndex < controller.detailDayModel.length &&
        endIndex <= controller.detailDayModel.length) {
      controller.displayedDataDay.value = controller.detailDayModel
          .getRange(startIndex, endIndex)
          .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      controller.displayedDataHour = RxList.empty(growable: true);
    }

    return true;
  }

  void buildPaginatedDataGridRows() {
    _model = controller.displayedDataDay.map<DataGridRow>((row) {
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'readingDate',
          value: (row.readingDate != null)
              ? AppConstants().dateFormatID.format(row.readingDate!)
              : '-',
        ),
        DataGridCell<double>(
          columnName: 'rainFall',
          value: row.rainfall != null
              ? double.parse(row.rainfall!.toStringAsFixed(2))
              : row.rainfall,
        ),
        DataGridCell<String>(
          columnName: 'intensity',
          value: row.intensity,
        ),
      ]);
    }).toList(growable: false);
  }
}
