import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/observation_well/models/observation_well_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/observation_well/repository/observation_well_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ObservationWellController extends GetxController
    with StateMixin, GetSingleTickerProviderStateMixin {
  final ObservationWellRepository repository;
  ObservationWellController(this.repository);
  late TabController tabController;

  ObservationWellModel? model;
  List<Map<String, dynamic>> sensors = List.empty(growable: true);
  RxList<ObservationWell> listModel = RxList.empty(growable: true);
  TextEditingController dateRangeController = TextEditingController();
  var selectedDateRange = Rxn<DateTimeRange>(DateTimeRange(
    start: DateTime.now(), // Start date: 7 days ago
    end: DateTime.now(), // End date: Today
  ));
  RxMap<String, dynamic> selectedSensor =
      RxMap<String, dynamic>({'id': 'all', 'text': 'Semua'});

  final int rowsPerPage = 10; // Rows per page
  RxList<ObservationWell> displayedData =
      <ObservationWell>[].obs; // Paginated data
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
    await getSensors();
    await getData();
  }

  Future<TableDataSource> getTableDataSource() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSource;
  }

  Future<List<ObservationWell>> getChartData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listModel;
  }

  Future<ObservationWellModel?> getDataModel() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return model;
  }

  getData() async {
    change(null, status: RxStatus.loading());
    listModel.clear();
    try {
      var sensor = selectedSensor['id'].toString().isNotEmpty
          ? selectedSensor['id']
          : null;
      await repository
          .getData(sensor, selectedDateRange.value!.start,
              selectedDateRange.value!.end)
          .then((data) => model = data);
      if (model != null) {
        if (model!.listIntake != null) {
          if (model!.listIntake!.isNotEmpty) {
            model!.listIntake!
                .sort((a, b) => b.readingDate!.compareTo(a.readingDate!));
          }
        }
        if (model!.listRainFall != null) {
          if (model!.listRainFall!.isNotEmpty) {
            model!.listRainFall!
                .sort((a, b) => b.readingDate!.compareTo(a.readingDate!));
          }
        }
        if (model!.listObservationWell != null) {
          if (model!.listObservationWell!.isNotEmpty) {
            model!.listObservationWell!
                .sort((a, b) => b.readingDate.compareTo(a.readingDate));
            var result = model!.listObservationWell!;
            if (result.isNotEmpty) {
              for (var item in result) {
                listModel.add(item);
              }
            }
          }
        }
      }
      tableDataSource = TableDataSource();
      updateDisplayedData();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
      msgToast(e.toString());
    }
    update(['grafik']);
  }

  getSensors() async {
    change(null, status: RxStatus.loading());
    try {
      sensors.clear();
      await repository.getSensorList().then((data) {
        if (data.isNotEmpty) {
          sensors.addAll(data);
          selectedSensor.value = sensors.first;
        }
      });
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
      msgToast(e.toString());
    }
  }

  void updateDisplayedData() {
    int start = currentPage.value * rowsPerPage;
    int end = start + rowsPerPage;
    displayedData.value = listModel.sublist(
      start,
      end > listModel.length ? listModel.length : end,
    );
    update(['table']);
  }

  void onPageChanged(int pageIndex) {
    currentPage.value = pageIndex;
    updateDisplayedData();
  }
}

class TableDataSource extends DataGridSource {
  final ObservationWellController controller =
      Get.find<ObservationWellController>();
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
          value: AppConstants().dateFormatID.format(row.readingDate),
        ),
        //OW1
        DataGridCell<double>(
          columnName: 'sensorOw1Pengukuran',
          value: row.sensorOw1Pengukuran != null
              ? double.parse(row.sensorOw1Pengukuran!.toStringAsFixed(2))
              : row.sensorOw1Pengukuran,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw1Elevasi',
          value: row.sensorOw1Elevasi != null
              ? double.parse(row.sensorOw1Elevasi!.toStringAsFixed(2))
              : row.sensorOw1Elevasi,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw1Keterangan',
          value: row.sensorOw1Keterangan != null
              ? double.parse(row.sensorOw1Keterangan!.toStringAsFixed(2))
              : row.sensorOw1Keterangan,
        ),
        //OW2
        DataGridCell<double>(
          columnName: 'sensorOw2Pengukuran',
          value: row.sensorOw2Pengukuran != null
              ? double.parse(row.sensorOw2Pengukuran!.toStringAsFixed(2))
              : row.sensorOw2Pengukuran,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw2Elevasi',
          value: row.sensorOw2Elevasi != null
              ? double.parse(row.sensorOw2Elevasi!.toStringAsFixed(2))
              : row.sensorOw2Elevasi,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw2Keterangan',
          value: row.sensorOw2Keterangan != null
              ? double.parse(row.sensorOw2Keterangan!.toStringAsFixed(2))
              : row.sensorOw2Keterangan,
        ),
        //OW3
        DataGridCell<double>(
          columnName: 'sensorOw3Pengukuran',
          value: row.sensorOw3Pengukuran != null
              ? double.parse(row.sensorOw3Pengukuran!.toStringAsFixed(2))
              : row.sensorOw3Pengukuran,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw3Elevasi',
          value: row.sensorOw3Elevasi != null
              ? double.parse(row.sensorOw3Elevasi!.toStringAsFixed(2))
              : row.sensorOw3Elevasi,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw3Keterangan',
          value: row.sensorOw3Keterangan != null
              ? double.parse(row.sensorOw3Keterangan!.toStringAsFixed(2))
              : row.sensorOw3Keterangan,
        ),
        //OW4
        DataGridCell<double>(
          columnName: 'sensorOw4Pengukuran',
          value: row.sensorOw4Pengukuran != null
              ? double.parse(row.sensorOw4Pengukuran!.toStringAsFixed(2))
              : row.sensorOw4Pengukuran,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw4Elevasi',
          value: row.sensorOw4Elevasi != null
              ? double.parse(row.sensorOw4Elevasi!.toStringAsFixed(2))
              : row.sensorOw4Elevasi,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw4Keterangan',
          value: row.sensorOw4Keterangan != null
              ? double.parse(row.sensorOw4Keterangan!.toStringAsFixed(2))
              : row.sensorOw4Keterangan,
        ),
        //OW5
        DataGridCell<double>(
          columnName: 'sensorOw5Pengukuran',
          value: row.sensorOw5Pengukuran != null
              ? double.parse(row.sensorOw5Pengukuran!.toStringAsFixed(2))
              : row.sensorOw5Pengukuran,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw5Elevasi',
          value: row.sensorOw5Elevasi != null
              ? double.parse(row.sensorOw5Elevasi!.toStringAsFixed(2))
              : row.sensorOw5Elevasi,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw5Keterangan',
          value: row.sensorOw5Keterangan != null
              ? double.parse(row.sensorOw5Keterangan!.toStringAsFixed(2))
              : row.sensorOw5Keterangan,
        ),
        //OW6
        DataGridCell<double>(
          columnName: 'sensorOw6Pengukuran',
          value: row.sensorOw6Pengukuran != null
              ? double.parse(row.sensorOw6Pengukuran!.toStringAsFixed(2))
              : row.sensorOw6Pengukuran,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw6Elevasi',
          value: row.sensorOw6Elevasi != null
              ? double.parse(row.sensorOw6Elevasi!.toStringAsFixed(2))
              : row.sensorOw6Elevasi,
        ),
        //OW7
        DataGridCell<double>(
          columnName: 'sensorOw7Keterangan',
          value: row.sensorOw7Keterangan != null
              ? double.parse(row.sensorOw7Keterangan!.toStringAsFixed(2))
              : row.sensorOw7Keterangan,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw7Pengukuran',
          value: row.sensorOw7Pengukuran != null
              ? double.parse(row.sensorOw7Pengukuran!.toStringAsFixed(2))
              : row.sensorOw7Pengukuran,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw7Elevasi',
          value: row.sensorOw7Elevasi != null
              ? double.parse(row.sensorOw7Elevasi!.toStringAsFixed(2))
              : row.sensorOw7Elevasi,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw7Keterangan',
          value: row.sensorOw7Keterangan != null
              ? double.parse(row.sensorOw7Keterangan!.toStringAsFixed(2))
              : row.sensorOw7Keterangan,
        ),
        //Ow8
        DataGridCell<double>(
          columnName: 'sensorOw8Pengukuran',
          value: row.sensorOw8Pengukuran != null
              ? double.parse(row.sensorOw8Pengukuran!.toStringAsFixed(2))
              : row.sensorOw8Pengukuran,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw8Elevasi',
          value: row.sensorOw8Elevasi != null
              ? double.parse(row.sensorOw8Elevasi!.toStringAsFixed(2))
              : row.sensorOw8Elevasi,
        ),
        DataGridCell<double>(
          columnName: 'sensorOw8Keterangan',
          value: row.sensorOw8Keterangan != null
              ? double.parse(row.sensorOw8Keterangan!.toStringAsFixed(2))
              : row.sensorOw8Keterangan,
        ),
      ]);
    }).toList(growable: false);
  }
}
