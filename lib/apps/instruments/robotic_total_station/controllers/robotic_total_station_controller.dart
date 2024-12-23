import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/robotic_total_station/models/robotic_total_station_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/robotic_total_station/repository/robotic_total_station_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RoboticTotalStationController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  final RoboticTotalStationRepository repository;
  RoboticTotalStationController(this.repository);
  late TabController tabController;
  late TabController sensorTabController;
  final List<String> sensors = ['Perubahan Sumbu Z', 'Pergeseran Arah'];

  var selectedSensorIndex = 0.obs;
  var selectedTabIndex = 0.obs;
  var selectedDateRange = Rxn<DateTimeRange>(DateTimeRange(
    start: DateTime.now(), // Start date: 7 days ago
    end: DateTime.now(), // End date: Today
  ));
  TextEditingController dateRangeController = TextEditingController();
  RxList<RoboticTotalStationModel> listModel = RxList.empty(growable: true);

  final int rowsPerPage = 10; // Rows per page
  RxList<RoboticTotalStationModel> displayedData =
      <RoboticTotalStationModel>[].obs; // Paginated data
  RxInt currentPage = 0.obs; // Current page

  late TableDataSource tableDataSource;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);
    sensorTabController = TabController(length: sensors.length, vsync: this);
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

  Future<List<RoboticTotalStationModel>> getChartData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listModel;
  }

  getData() async {
    change(null, status: RxStatus.loading());
    listModel.clear();
    try {
      await repository
          .getData(selectedDateRange.value!.start, selectedDateRange.value!.end)
          .then((datas) {
        if (datas.isNotEmpty) {
          datas.sort((a, b) => b.readingAt!.compareTo(a.readingAt!));
          listModel.addAll(datas);
        }
      });
      tableDataSource = TableDataSource();
      updateDisplayedData();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
      msgToast(e.toString());
    }
    update(['grafik']);
  }

  changeSensorTabIndex(int index) {
    selectedSensorIndex.value = index;
  }

  changeGrapTabIndex(int index) {
    selectedTabIndex.value = index;
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
  final RoboticTotalStationController controller =
      Get.find<RoboticTotalStationController>();
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
          columnName: 'readingAt',
          value: AppConstants().dateTimeFormatID.format(row.readingAt!),
        ),
        DataGridCell<String>(
          columnName: 'point',
          value: row.point,
        ),
        DataGridCell<double>(
          columnName: 'baseE',
          value: row.baseE != null
              ? double.parse(row.baseE!.toStringAsFixed(2))
              : row.baseE,
        ),
        DataGridCell<double>(
          columnName: 'baseN',
          value: row.baseN != null
              ? double.parse(row.baseN!.toStringAsFixed(2))
              : row.baseN,
        ),
        DataGridCell<double>(
          columnName: 'baseRl',
          value: row.baseRl != null
              ? double.parse(row.baseRl!.toStringAsFixed(2))
              : row.baseRl,
        ),
        DataGridCell<double>(
          columnName: 'easting',
          value: row.easting != null
              ? double.parse(row.easting!.toStringAsFixed(2))
              : row.easting,
        ),
        DataGridCell<double>(
          columnName: 'northing',
          value: row.northing != null
              ? double.parse(row.northing!.toStringAsFixed(2))
              : row.northing,
        ),
        DataGridCell<double>(
          columnName: 'reducedLevel',
          value: row.reducedLevel != null
              ? double.parse(row.reducedLevel!.toStringAsFixed(2))
              : row.reducedLevel,
        ),
        DataGridCell<double>(
          columnName: 'de',
          value: row.de != null
              ? double.parse(row.de!.toStringAsFixed(2))
              : row.de,
        ),
        DataGridCell<double>(
          columnName: 'dn',
          value: row.dn != null
              ? double.parse(row.dn!.toStringAsFixed(2))
              : row.dn,
        ),
        DataGridCell<double>(
          columnName: 'drl',
          value: row.drl != null
              ? double.parse(row.drl!.toStringAsFixed(2))
              : row.drl,
        ),
        DataGridCell<double>(
          columnName: 'dx',
          value: row.dx != null
              ? double.parse(row.dx!.toStringAsFixed(2))
              : row.dx,
        ),
        DataGridCell<double>(
          columnName: 'dy',
          value: row.dy != null
              ? double.parse(row.dy!.toStringAsFixed(2))
              : row.dy,
        ),
        DataGridCell<double>(
          columnName: 'dz',
          value: row.dz != null
              ? double.parse(row.dz!.toStringAsFixed(2))
              : row.dz,
        ),
      ]);
    }).toList(growable: false);
  }
}
