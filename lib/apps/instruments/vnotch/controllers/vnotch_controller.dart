import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:mobile_ameroro_app/apps/instruments/vnotch/models/vnotch_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/vnotch/repository/vnotch_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/app_enum.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VNotchController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  final VNotchRepository repository;
  VNotchController(this.repository);
  late TabController tabController;
  late TabController sensorTabController;
  final List<String> sensors = ['TMA', 'Debit', 'Baterai'];

  var selectedSensorIndex = 0.obs;
  var selectedTabIndex = 0.obs;
  RxList<VNotchModel> listModel = RxList.empty(growable: true);
  var selectedDateRange = Rxn<DateTimeRange>(
      DateTimeRange(start: DateTime.now(), end: DateTime.now()));
  TextEditingController dateRangeController = TextEditingController();

  final int rowsPerPage = 10; // Rows per page
  RxList<VNotchModel> displayedData = <VNotchModel>[].obs; // Paginated data
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

  Future<List<VNotchModel>> getChartData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listModel;
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
        result.sort((a, b) => b.readingAt!.compareTo(a.readingAt!));
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

  getChangeValue(String changeVal, double val) {
    Widget result = const SizedBox();
    try {
      switch (changeVal.toLowerCase()) {
        case 'increase':
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
        case 'decrease':
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
        case 'constant':
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
  final VNotchController controller = Get.find<VNotchController>();
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
      if (e.columnName == 'changeValue') {
        final int index = effectiveRows.indexOf(row);
        return Center(
          child: controller.getChangeValue(
              controller.listModel[index].changeStatus ?? '',
              controller.listModel[index].changeValue ?? 0),
        );
      } else if (e.columnName == 'warningStatus') {
        final int index = effectiveRows.indexOf(row);
        String status = controller.listModel[index].warningStatus ?? '';
        StatusLevel? statusLevel;
        switch (status.toLowerCase()) {
          case 'normal':
            statusLevel = StatusLevel.normal;
            break;
          case 'siaga1':
            statusLevel = StatusLevel.siaga1;
            break;
          case 'siaga2':
            statusLevel = StatusLevel.siaga2;
            break;
          case 'siaga3':
            statusLevel = StatusLevel.siaga3;
            break;
          default:
        }
        return Container(
          color: (statusLevel == null)
              ? GFColors.WHITE
              : statusLevel.color.withOpacity(0.5),
          child: Center(
            child: Text(e.value.toString()),
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
          value: AppConstants().dateFormatID.format(row.readingAt!),
        ),
        DataGridCell<String>(
          columnName: 'hourMinuteFormat',
          value: AppConstants().hourMinuteFormat.format(row.readingAt!),
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
          columnName: 'warningStatus',
          value: row.warningStatus ?? '',
        ),
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
