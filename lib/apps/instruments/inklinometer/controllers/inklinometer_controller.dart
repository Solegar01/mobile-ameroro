import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/inklinometer/models/inklinometer_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/inklinometer/repository/inklinometer_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InklinometerController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  final InklinometerRepository repository;
  InklinometerController(this.repository);
  late TabController tabController;

  var selectedSensorIndex = 0.obs;
  RxList<InklinometerModel> listModel = RxList.empty(growable: true);
  var selectedDateRange = Rxn<DateTimeRange>(
      DateTimeRange(start: DateTime.now(), end: DateTime.now()));
  TextEditingController dateRangeController = TextEditingController();
  RxMap<int, Map<int, Map<int, List<InklinometerModel>>>> groupedData =
      <int, Map<int, Map<int, List<InklinometerModel>>>>{}.obs;

  final int rowsPerPage = 10; // Rows per page
  RxList<InklinometerModel> displayedData =
      <InklinometerModel>[].obs; // Paginated data
  RxInt currentPage = 0.obs; // Current page

  late TableDataSource tableDataSource;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);
    await formInit();
    super.onInit();
  }

  formInit() async {
    dateRangeController.text =
        '${AppConstants().dateFormatID.format(selectedDateRange.value!.start)} - ${AppConstants().dateFormatID.format(selectedDateRange.value!.end)}';
    await getData();
  }

  Future<TableDataSource> getTableDataSource() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSource;
  }

  Future<List<InklinometerModel>> getChartData() async => listModel;
  Future<RxMap<int, Map<int, Map<int, List<InklinometerModel>>>>>
      getGroupedData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return groupedData;
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    try {
      listModel.clear();
      var paramStart = DateTime.now();
      var paramEnd = DateTime.now();
      if (selectedDateRange.value != null) {
        paramStart = selectedDateRange.value!.start;
        paramEnd = selectedDateRange.value!.end;
      }
      var result = await repository.getData(paramStart, paramEnd);
      if (result.isNotEmpty) {
        result.sort((a, b) => b.readingDate!.compareTo(a.readingDate!));
        groupedData.value = {};
        for (var level in result) {
          int year = level.readingDate!.year;
          int month = level.readingDate!.month;
          int day = level.readingDate!.day;

          groupedData.putIfAbsent(year, () => {});
          groupedData[year]!.putIfAbsent(month, () => {});
          groupedData[year]![month]!.putIfAbsent(day, () => []);
          groupedData[year]![month]![day]!.add(level);
        }
        for (var item in result) {
          listModel.add(item);
        }
      }
      tableDataSource = TableDataSource();
      updateDisplayedData();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      msgToast(e.toString());
    }
  }

  changeSensorTabIndex(int index) {
    selectedSensorIndex.value = index;
  }

  changeGrapTabIndex(int index) {
    selectedSensorIndex.value = index;
  }

  void updateDisplayedData() {
    int start = currentPage.value * rowsPerPage;
    int end = start + rowsPerPage;
    displayedData.value = listModel.sublist(
      start,
      end > listModel.length ? listModel.length : end,
    );
    tableDataSource.buildPaginatedDataGridRows();
    update(['table']);
  }
}

class TableDataSource extends DataGridSource {
  final InklinometerController controller = Get.find<InklinometerController>();
  TableDataSource() {
    if (controller.listModel.isNotEmpty) {
      int perPage = controller.listModel.length >= controller.rowsPerPage
          ? controller.rowsPerPage
          : controller.listModel.length;
      controller.displayedData.value =
          controller.listModel.getRange(0, perPage).toList(growable: false);
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
    if (startIndex < controller.listModel.length &&
        endIndex <= controller.listModel.length) {
      controller.displayedData.value = controller.listModel
          .getRange(startIndex, endIndex)
          .toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      controller.displayedData = RxList.empty(growable: true);
    }

    return true;
  }

  void buildPaginatedDataGridRows() {
    _model = controller.displayedData.map<DataGridRow>((row) {
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'readingDate',
          value: AppConstants().dateFormatID.format(row.readingDate!),
        ),
        DataGridCell<double>(
          columnName: 'depth',
          value: row.depth != null
              ? double.parse(row.depth!.toStringAsFixed(2))
              : row.depth,
        ),
        DataGridCell<double>(
          columnName: 'faceAPlus',
          value: row.faceAPlus != null
              ? double.parse(row.faceAPlus!.toStringAsFixed(2))
              : row.faceAPlus,
        ),
        DataGridCell<double>(
          columnName: 'faceAMinus',
          value: row.faceAMinus != null
              ? double.parse(row.faceAMinus!.toStringAsFixed(2))
              : row.faceAMinus,
        ),
        DataGridCell<double>(
          columnName: 'faceBPlus',
          value: row.faceBPlus != null
              ? double.parse(row.faceBPlus!.toStringAsFixed(2))
              : row.faceBPlus,
        ),
        DataGridCell<double>(
          columnName: 'faceBMinus',
          value: row.faceBMinus != null
              ? double.parse(row.faceBMinus!.toStringAsFixed(2))
              : row.faceBMinus,
        ),
      ]);
    }).toList(growable: false);
  }
}
