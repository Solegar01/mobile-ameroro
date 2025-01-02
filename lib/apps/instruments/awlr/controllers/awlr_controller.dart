import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlr_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/repository/awlr_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AwlrController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  final AwlrRepository repository;
  AwlrController(this.repository);

  RxList<AwlrModel> listAwlr = RxList.empty(growable: true);

  final int rowsPerPage = 10; // Rows per page
  RxList<AwlrModel> displayedData = <AwlrModel>[].obs; // Paginated data
  RxInt currentPage = 0.obs; // Current page
  late TableDataSource tableDataSource;

  @override
  void onInit() async {
    await formInit();
    super.onInit();
  }

  formInit() async {
    await getData();
  }

  Future<TableDataSource> getTableDataSource() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSource;
  }

  Future<List<AwlrModel>> getChartData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listAwlr;
  }

  bool checkPeriode(DateTime startDatex, DateTime endDatex) {
    bool result = true;
    if (startDatex.isAfter(endDatex)) {
      result = false;
    }

    if (endDatex.isBefore(startDatex)) {
      result = false;
    }
    return result;
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    listAwlr.clear();
    try {
      var listResponse = await repository.getData();
      if (listResponse.isNotEmpty) {
        listResponse.sort((a, b) => b.readingAt!.compareTo(a.readingAt!));
        for (var item in listResponse) {
          listAwlr.add(item);
        }
      }
      // tableDataSource = TableDataSource();
      // updateDisplayedData();
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

  // Update displayed data for the current page
  void updateDisplayedData() {
    int start = currentPage.value * rowsPerPage;
    int end = start + rowsPerPage;
    displayedData.value = listAwlr.sublist(
      start,
      end > listAwlr.length ? listAwlr.length : end,
    );
    tableDataSource.buildPaginatedDataGridRows();
    update(['table']);
  }
}

class TableDataSource extends DataGridSource {
  final AwlrController controller = Get.find<AwlrController>();
  TableDataSource() {
    if (controller.listAwlr.isNotEmpty) {
      int perPage = controller.listAwlr.length >= controller.rowsPerPage
          ? controller.rowsPerPage
          : controller.listAwlr.length;
      controller.displayedData.value =
          controller.listAwlr.getRange(0, perPage).toList(growable: false);
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
              controller.listAwlr[index].changeStatus ?? '',
              controller.listAwlr[index].changeValue ?? 0),
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
    if (startIndex < controller.listAwlr.length &&
        endIndex <= controller.listAwlr.length) {
      controller.displayedData.value = controller.listAwlr
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
