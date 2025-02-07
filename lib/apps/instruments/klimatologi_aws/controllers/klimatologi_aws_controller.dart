import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/klimatologi_aws_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/models/last_reading_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/repository/klimatologi_aws_repository.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/models/weather_model.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KlimatologiAwsController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  final KlimatologiAwsRepository repository;
  KlimatologiAwsController(this.repository);
  late TabController tabController;
  late TabController sensorTabController;
  final List<String> sensors = [
    'Baterai',
    'Suhu',
    'Kelembaban',
    'Titik Embun',
    'Kecepatan Angin',
    'Radiasi Matahari',
    'Curah Hujan',
    'Tekanan Barometrik'
  ];

  var selectedSensorIndex = 0.obs;
  var selectedTabIndex = 0.obs;
  LastReadingModel? lastReadingModel;
  RxList<KlimatologiAwsModel> listModel = RxList.empty(growable: true);
  var selectedDateRange = Rxn<DateTimeRange>(
      DateTimeRange(start: DateTime.now(), end: DateTime.now()));
  TextEditingController dateRangeController = TextEditingController();

  final int rowsPerPage = 10; // Rows per page
  RxList<KlimatologiAwsModel> displayedData =
      <KlimatologiAwsModel>[].obs; // Paginated data
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
    change(null, status: RxStatus.success());
  }

  Future<TableDataSource> getTableDataSource() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSource;
  }

  Future<List<KlimatologiAwsModel>> getChartData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listModel;
  }

  Future<LastReadingModel?> getLastReading() async {
    LastReadingModel? model;
    try {
      model = await repository.getLastReading();
    } catch (e) {
      msgToast(e.toString());
    }
    return model;
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
  final KlimatologiAwsController controller =
      Get.find<KlimatologiAwsController>();
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
        padding: EdgeInsets.all(10),
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
          value: AppConstants().dateTimeFormatID.format(row.readingDate!),
        ),
        DataGridCell<int>(
          columnName: 'record',
          value: row.record,
        ),
        DataGridCell<double>(
          columnName: 'battery',
          value: row.battery != null
              ? double.parse(row.battery!.toStringAsFixed(2))
              : row.battery,
        ),
        DataGridCell<double>(
          columnName: 'airtempMin',
          value: row.airtempMin != null
              ? double.parse(row.airtempMin!.toStringAsFixed(2))
              : row.airtempMin,
        ),
        DataGridCell<double>(
          columnName: 'airtempMax',
          value: row.airtempMax != null
              ? double.parse(row.airtempMax!.toStringAsFixed(2))
              : row.airtempMax,
        ),
        DataGridCell<double>(
          columnName: 'rhMin',
          value: row.rhMin != null
              ? double.parse(row.rhMin!.toStringAsFixed(2))
              : row.rhMin,
        ),
        DataGridCell<double>(
          columnName: 'rhMax',
          value: row.rhMax != null
              ? double.parse(row.rhMax!.toStringAsFixed(2))
              : row.rhMax,
        ),
        DataGridCell<double>(
          columnName: 'dewpointMin',
          value: row.dewpointMin != null
              ? double.parse(row.dewpointMin!.toStringAsFixed(2))
              : row.dewpointMin,
        ),
        DataGridCell<double>(
          columnName: 'dewpointMax',
          value: row.dewpointMax != null
              ? double.parse(row.dewpointMax!.toStringAsFixed(2))
              : row.dewpointMax,
        ),
        DataGridCell<double>(
          columnName: 'wsMin',
          value: row.wsMin != null
              ? double.parse(row.wsMin!.toStringAsFixed(2))
              : row.wsMin,
        ),
        DataGridCell<double>(
          columnName: 'wsMax',
          value: row.wsMax != null
              ? double.parse(row.wsMax!.toStringAsFixed(2))
              : row.wsMax,
        ),
        DataGridCell<double>(
          columnName: 'solar',
          value: row.solar != null
              ? double.parse(row.solar!.toStringAsFixed(2))
              : row.solar,
        ),
        DataGridCell<double>(
          columnName: 'rainfall',
          value: row.rainfall != null
              ? double.parse(row.rainfall!.toStringAsFixed(2))
              : row.rainfall,
        ),
        DataGridCell<double>(
          columnName: 'bpMin',
          value: row.bpMin != null
              ? double.parse(row.bpMin!.toStringAsFixed(2))
              : row.bpMin,
        ),
        DataGridCell<double>(
          columnName: 'bpMax',
          value: row.bpMax != null
              ? double.parse(row.bpMax!.toStringAsFixed(2))
              : row.bpMax,
        ),
      ]);
    }).toList(growable: false);
  }
}
