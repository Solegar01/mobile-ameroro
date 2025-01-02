import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/models/open_standpipe_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/repository/open_standpipe_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OpenStandpipeController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  final OpenStandpipeRepository repository;
  OpenStandpipeController(this.repository);
  late TabController tabController;

  OpenStandpipeModel? model;
  RxMap<String, dynamic> selectedStation = <String, dynamic>{}.obs;
  RxMap<String, dynamic> selectedElevation = <String, dynamic>{}.obs;
  var selectedDateRange = Rxn<DateTimeRange>(DateTimeRange(
    start: DateTime.now(), // Start date: 7 days ago
    end: DateTime.now(), // End date: Today
  ));
  TextEditingController dateRangeController = TextEditingController();
  RxList<OpenStandpipe> listModel = RxList.empty(growable: true);
  RxList<Intake> listIntake = RxList.empty(growable: true);

  final int rowsPerPage = 10; // Rows per page
  RxList<OpenStandpipe> displayedData = <OpenStandpipe>[].obs; // Paginated data
  RxInt currentPage = 0.obs; // Current page

  late TableDataSource tableDataSource;

  @override
  void onInit() async {
    tabController = TabController(length: 3, vsync: this);
    await formInit();
    super.onInit();
  }

  formInit() async {
    change(null, status: RxStatus.loading());
    dateRangeController.text =
        '${AppConstants().dateFormatID.format(selectedDateRange.value!.start)} - ${AppConstants().dateFormatID.format(selectedDateRange.value!.end)}';
    await getStations();
    await getElevations();
    await getData();
    change(null, status: RxStatus.success());
  }

  Future<TableDataSource> getTableDataSource() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSource;
  }

  Future<List<Intake>> getListIntake() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listIntake;
  }

  Future<List<OpenStandpipe>> getListOsp() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listModel;
  }

  Future<OpenStandpipeModel?> getDataModel() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return model;
  }

  Future<List<Map<String, dynamic>>> getElevations() async {
    List<Map<String, dynamic>> res = List.empty(growable: true);
    try {
      res = await repository.getListElevation();
      if (res.isNotEmpty) selectedElevation.value = res.first;
    } catch (e) {
      rethrow;
    }
    return res;
  }

  Future<List<Map<String, dynamic>>> getStations() async {
    List<Map<String, dynamic>> res = List.empty(growable: true);
    try {
      res = await repository.getListStation();
      if (res.isNotEmpty) selectedStation.value = res.first;
    } catch (e) {
      rethrow;
    }
    return res;
  }

  getData() async {
    change(null, status: RxStatus.loading());
    listModel.clear();
    try {
      var sensor = selectedElevation['id'].toString().isNotEmpty
          ? selectedElevation['id']
          : null;
      await repository
          .getData(selectedStation['id'], sensor,
              selectedDateRange.value!.start, selectedDateRange.value!.end)
          .then((data) {
        model = data;
        if (data.listOpenStandpipe != null) {
          if (data.listOpenStandpipe!.isNotEmpty) {
            data.listOpenStandpipe!
                .sort((a, b) => b.readingDate!.compareTo(a.readingDate!));
            for (var item in data.listOpenStandpipe!) {
              listModel.add(item);
            }
          }
        }

        if (data.listIntake != null) {
          if (data.listIntake!.isNotEmpty) {
            data.listIntake!
                .sort((a, b) => b.readingDate!.compareTo(a.readingDate!));
            for (var item in data.listIntake!) {
              listIntake.add(item);
            }
          }
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
  final OpenStandpipeController controller =
      Get.find<OpenStandpipeController>();
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
        //OSP 1.1
        DataGridCell<double>(
          columnName: 'sensorOsp11WaterLevel',
          value: row.sensorOsp11WaterLevel != null
              ? double.parse(row.sensorOsp11WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp11WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp11ElvWaterLevel',
          value: row.sensorOsp11ElvWaterLevel != null
              ? double.parse(row.sensorOsp11ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp11ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp11TekananPori',
          value: row.sensorOsp11TekananPori != null
              ? double.parse(row.sensorOsp11TekananPori!.toStringAsFixed(2))
              : row.sensorOsp11TekananPori,
        ),
        //OSP 1.2
        DataGridCell<double>(
          columnName: 'sensorOsp12WaterLevel',
          value: row.sensorOsp12WaterLevel != null
              ? double.parse(row.sensorOsp12WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp12WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp12ElvWaterLevel',
          value: row.sensorOsp12ElvWaterLevel != null
              ? double.parse(row.sensorOsp12ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp12ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp12TekananPori',
          value: row.sensorOsp12TekananPori != null
              ? double.parse(row.sensorOsp12TekananPori!.toStringAsFixed(2))
              : row.sensorOsp12TekananPori,
        ),
        //OSP 2.1
        DataGridCell<double>(
          columnName: 'sensorOsp21WaterLevel',
          value: row.sensorOsp21WaterLevel != null
              ? double.parse(row.sensorOsp21WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp21WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp21ElvWaterLevel',
          value: row.sensorOsp21ElvWaterLevel != null
              ? double.parse(row.sensorOsp21ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp21ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp21TekananPori',
          value: row.sensorOsp21TekananPori != null
              ? double.parse(row.sensorOsp21TekananPori!.toStringAsFixed(2))
              : row.sensorOsp21TekananPori,
        ),
        //OSP 2.2
        DataGridCell<double>(
          columnName: 'sensorOsp22WaterLevel',
          value: row.sensorOsp22WaterLevel != null
              ? double.parse(row.sensorOsp22WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp22WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp22ElvWaterLevel',
          value: row.sensorOsp22ElvWaterLevel != null
              ? double.parse(row.sensorOsp22ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp22ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp22TekananPori',
          value: row.sensorOsp22TekananPori != null
              ? double.parse(row.sensorOsp22TekananPori!.toStringAsFixed(2))
              : row.sensorOsp22TekananPori,
        ),
        //OSP 3.1
        DataGridCell<double>(
          columnName: 'sensorOsp31WaterLevel',
          value: row.sensorOsp31WaterLevel != null
              ? double.parse(row.sensorOsp31WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp31WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp31ElvWaterLevel',
          value: row.sensorOsp31ElvWaterLevel != null
              ? double.parse(row.sensorOsp31ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp31ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp31TekananPori',
          value: row.sensorOsp31TekananPori != null
              ? double.parse(row.sensorOsp31TekananPori!.toStringAsFixed(2))
              : row.sensorOsp31TekananPori,
        ),
        //OSP 3.2
        DataGridCell<double>(
          columnName: 'sensorOsp32WaterLevel',
          value: row.sensorOsp32WaterLevel != null
              ? double.parse(row.sensorOsp32WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp32WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp32ElvWaterLevel',
          value: row.sensorOsp32ElvWaterLevel != null
              ? double.parse(row.sensorOsp32ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp32ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp32TekananPori',
          value: row.sensorOsp32TekananPori != null
              ? double.parse(row.sensorOsp32TekananPori!.toStringAsFixed(2))
              : row.sensorOsp32TekananPori,
        ),
        //OSP 4.1
        DataGridCell<double>(
          columnName: 'sensorOsp41WaterLevel',
          value: row.sensorOsp41WaterLevel != null
              ? double.parse(row.sensorOsp41WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp41WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp41ElvWaterLevel',
          value: row.sensorOsp41ElvWaterLevel != null
              ? double.parse(row.sensorOsp41ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp41ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp41TekananPori',
          value: row.sensorOsp41TekananPori != null
              ? double.parse(row.sensorOsp41TekananPori!.toStringAsFixed(2))
              : row.sensorOsp41TekananPori,
        ),
        //OSP 4.2
        DataGridCell<double>(
          columnName: 'sensorOsp42WaterLevel',
          value: row.sensorOsp42WaterLevel != null
              ? double.parse(row.sensorOsp42WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp42WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp42ElvWaterLevel',
          value: row.sensorOsp42ElvWaterLevel != null
              ? double.parse(row.sensorOsp42ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp42ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp42TekananPori',
          value: row.sensorOsp42TekananPori != null
              ? double.parse(row.sensorOsp42TekananPori!.toStringAsFixed(2))
              : row.sensorOsp42TekananPori,
        ),
        //OSP 5.1
        DataGridCell<double>(
          columnName: 'sensorOsp51WaterLevel',
          value: row.sensorOsp51WaterLevel != null
              ? double.parse(row.sensorOsp51WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp51WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp51ElvWaterLevel',
          value: row.sensorOsp51ElvWaterLevel != null
              ? double.parse(row.sensorOsp51ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp51ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp51TekananPori',
          value: row.sensorOsp51TekananPori != null
              ? double.parse(row.sensorOsp51TekananPori!.toStringAsFixed(2))
              : row.sensorOsp51TekananPori,
        ),
        //OSP 5.2
        DataGridCell<double>(
          columnName: 'sensorOsp52WaterLevel',
          value: row.sensorOsp52WaterLevel != null
              ? double.parse(row.sensorOsp52WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp52WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp52ElvWaterLevel',
          value: row.sensorOsp52ElvWaterLevel != null
              ? double.parse(row.sensorOsp52ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp52ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp52TekananPori',
          value: row.sensorOsp52TekananPori != null
              ? double.parse(row.sensorOsp52TekananPori!.toStringAsFixed(2))
              : row.sensorOsp52TekananPori,
        ),
        //OSP 6.1
        DataGridCell<double>(
          columnName: 'sensorOsp61WaterLevel',
          value: row.sensorOsp61WaterLevel != null
              ? double.parse(row.sensorOsp61WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp61WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp61ElvWaterLevel',
          value: row.sensorOsp61ElvWaterLevel != null
              ? double.parse(row.sensorOsp61ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp61ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp61TekananPori',
          value: row.sensorOsp61TekananPori != null
              ? double.parse(row.sensorOsp61TekananPori!.toStringAsFixed(2))
              : row.sensorOsp61TekananPori,
        ),
        //OSP 6.2
        DataGridCell<double>(
          columnName: 'sensorOsp62WaterLevel',
          value: row.sensorOsp62WaterLevel != null
              ? double.parse(row.sensorOsp62WaterLevel!.toStringAsFixed(2))
              : row.sensorOsp62WaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp62ElvWaterLevel',
          value: row.sensorOsp62ElvWaterLevel != null
              ? double.parse(row.sensorOsp62ElvWaterLevel!.toStringAsFixed(2))
              : row.sensorOsp62ElvWaterLevel,
        ),
        DataGridCell<double>(
          columnName: 'sensorOsp62TekananPori',
          value: row.sensorOsp62TekananPori != null
              ? double.parse(row.sensorOsp62TekananPori!.toStringAsFixed(2))
              : row.sensorOsp62TekananPori,
        ),
      ]);
    }).toList(growable: false);
  }
}
