import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_detail_day_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_detail_hour_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_detail_minute_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/repository/awlr_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AwlrDetailController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  final AwlrRepository repository;
  AwlrDetailController(this.repository);
  late AnimationController animationController;
  late Animation<double> animation;

  AwlrModel? model;
  List<AwlrDetailHourModel> detailHourModel = List.empty(growable: true);
  List<AwlrDetailDayModel> detailDayModel = List.empty(growable: true);
  List<AwlrDetailMinuteModel> detailMinuteModel = List.empty(growable: true);
  Rx<DataFilterType> filterType = DataFilterType.fiveMinutely.obs;
  final List<DataFilterType> listFilterType = DataFilterType.values;
  Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>(
      DateTimeRange(start: DateTime.now(), end: DateTime.now()));
  TextEditingController dateRangeController = TextEditingController();
  late TabController tabController;
  late TabController sensorTabController;
  final List<String> sensors = [
    'TMA',
    'Debit',
    'Baterai',
  ];
  var selectedSensorIndex = 0.obs;
  var selectedTabIndex = 0.obs;
  late TableDataSourceHour tableDataSourceHour = TableDataSourceHour();
  late TableDataSourceDay tableDataSourceDay = TableDataSourceDay();
  late TableDataSourceMinute tableDataSourceMinute = TableDataSourceMinute();

  final int rowsPerPage = 10; // Rows per page
  RxInt currentPage = 0.obs; // Current page
  RxList<AwlrDetailMinuteModel> displayedDataMinute =
      <AwlrDetailMinuteModel>[].obs;
  RxList<AwlrDetailHourModel> displayedDataHour = <AwlrDetailHourModel>[].obs;
  RxList<AwlrDetailDayModel> displayedDataDay = <AwlrDetailDayModel>[].obs;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);
    sensorTabController = TabController(length: sensors.length, vsync: this);
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
    sensorTabController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    animationController.dispose();
    tabController.dispose();
    sensorTabController.dispose();
    super.onClose();
  }

  formInit() async {
    dateRangeController.text =
        '${AppConstants().dateFormatID.format(selectedDateRange.value!.start)} - ${AppConstants().dateFormatID.format(selectedDateRange.value!.end)}';
    await getCacheData();
    // await getData();
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

  Future<List<AwlrDetailHourModel>> getChartDataHour() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return detailHourModel;
  }

  Future<List<AwlrDetailMinuteModel>> getChartDataMinute() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return detailMinuteModel;
  }

  Future<List<AwlrDetailDayModel>> getChartDataDay() async {
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

  getChangeValue(String changeVal, double val) {
    Widget result = const SizedBox();
    try {
      switch (changeVal.toLowerCase()) {
        case 'inc':
          result = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_upward,
                color: GFColors.DANGER,
                size: 17,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${val.toString()} m',
                style: const TextStyle(color: GFColors.DANGER),
              )
            ],
          );
          break;
        case 'dec':
          result = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_downward,
                  color: GFColors.SUCCESS, size: 17),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${val.toString()} m',
                style: const TextStyle(color: GFColors.SUCCESS),
              )
            ],
          );
          break;
        case 'const':
          result = const Text(
            '-',
            style: TextStyle(fontWeight: FontWeight.bold),
          );
          break;
        default:
      }
    } catch (e) {
      rethrow;
    }
    return result;
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
  final AwlrDetailController controller = Get.find<AwlrDetailController>();
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
      if (e.columnName == 'warningStatus') {
        WarningStatus? status = switch (e.value.toString().toLowerCase()) {
          'normal' => WarningStatus.normal,
          'awas' => WarningStatus.awas,
          'waspada' => WarningStatus.waspada,
          'siaga' => WarningStatus.siaga,
          String() => null,
        };
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.r),
          child: Text(
            e.value != null ? e.value.toString() : ' - ',
            style:
                TextStyle(color: status != null ? status.color : GFColors.DARK),
          ),
        );
      }
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
          columnName: 'waterLevel',
          value: row.waterLevel != null
              ? double.parse(row.waterLevel!.toStringAsFixed(2))
              : row.waterLevel,
        ),
        DataGridCell<double>(
          columnName: 'debit',
          value: row.debit != null
              ? double.parse(row.debit!.toStringAsFixed(2))
              : row.debit,
        ),
        DataGridCell<String>(
          columnName: 'warningStatus',
          value: row.warningStatus ?? '-',
        ),
      ]);
    }).toList(growable: false);
  }
}

class TableDataSourceMinute extends DataGridSource {
  final AwlrDetailController controller = Get.find<AwlrDetailController>();
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
      if (e.columnName == 'changeValue') {
        final int index = effectiveRows.indexOf(row);
        return Center(
          child: controller.getChangeValue(
              controller.detailMinuteModel[index].changeStatus ?? '',
              controller.detailMinuteModel[index].changeValue ?? 0),
        );
      }
      if (e.columnName == 'warningStatus') {
        WarningStatus? status = switch (e.value.toString().toLowerCase()) {
          'normal' => WarningStatus.normal,
          'awas' => WarningStatus.awas,
          'waspada' => WarningStatus.waspada,
          'siaga' => WarningStatus.siaga,
          String() => null,
        };
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.r),
          child: Text(
            e.value != null ? e.value.toString() : ' - ',
            style:
                TextStyle(color: status != null ? status.color : GFColors.DARK),
          ),
        );
      }
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
          columnName: 'waterLevel',
          value: row.waterLevel != null
              ? double.parse(row.waterLevel!.toStringAsFixed(2))
              : row.waterLevel,
        ),
        DataGridCell<double>(
          columnName: 'debit',
          value: row.debit != null
              ? double.parse(row.debit!.toStringAsFixed(2))
              : row.debit,
        ),
        DataGridCell<double>(
          columnName: 'changeValue',
          value: row.changeValue != null
              ? double.parse(row.changeValue!.toStringAsFixed(2))
              : row.changeValue,
        ),
        DataGridCell<String>(
            columnName: 'warningStatus', value: row.warningStatus),
        DataGridCell<double>(
          columnName: 'battery',
          value: row.battery != null
              ? double.parse(row.battery!.toStringAsFixed(2))
              : row.battery,
        ),
      ]);
    }).toList(growable: false);
  }
}

class TableDataSourceDay extends DataGridSource {
  final AwlrDetailController controller = Get.find<AwlrDetailController>();
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
          columnName: 'waterLevelMin',
          value: row.waterLevelMin != null
              ? double.parse(row.waterLevelMin!.toStringAsFixed(2))
              : row.waterLevelMin,
        ),
        DataGridCell<double>(
          columnName: 'waterLevelMax',
          value: row.waterLevelMax != null
              ? double.parse(row.waterLevelMax!.toStringAsFixed(2))
              : row.waterLevelMax,
        ),
        DataGridCell<double>(
          columnName: 'waterLevelMax',
          value: row.waterLevelAvg != null
              ? double.parse(row.waterLevelAvg!.toStringAsFixed(2))
              : row.waterLevelAvg,
        ),
      ]);
    }).toList(growable: false);
  }
}
