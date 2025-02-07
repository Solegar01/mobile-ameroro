import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/Repository/klimatologi_manual_repository.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/models/klimatologi_manual_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/models/weather_model.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KlimatologiManualController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  final KlimatologiManualRepository repository;
  KlimatologiManualController(this.repository);
  late TabController tabController;
  late TabController sensorTabController;
  final List<String> sensors = [
    'Thermometer',
    'Psychrometer Standar',
    'Thermometer Apung',
    'Penguapan',
    'Kecepatan Angin',
    'Curah Hujan'
  ];

  var selectedSensorIndex = 0.obs;
  var selectedTabIndex = 0.obs;
  RxList<KlimatologiManualModel> listModel = RxList.empty(growable: true);
  var selectedDateRange = Rxn<DateTimeRange>(
      DateTimeRange(start: DateTime.now(), end: DateTime.now()));
  TextEditingController dateRangeController = TextEditingController();

  final int rowsPerPage = 10; // Rows per page
  RxList<KlimatologiManualModel> displayedData =
      <KlimatologiManualModel>[].obs; // Paginated data
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

  Future<List<KlimatologiManualModel>> getChartData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listModel;
  }

  Future<List<Cuaca>> getCuacaList() async {
    List<Cuaca> resultList = List.empty(growable: true);
    try {
      var response = await repository.getWeather();
      if (response != null) {
        if (response.data.isNotEmpty) {
          var tempList = response.data[0].cuaca;
          if (tempList.isNotEmpty) {
            for (var item in tempList) {
              resultList.addAll(item);
            }
          }
        }
      }
    } catch (e) {
      msgToast(e.toString());
    }
    return resultList;
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    try {
      listModel.clear();
      var result = await repository.getData(
          selectedDateRange.value!.start, selectedDateRange.value!.end);
      if (result.isNotEmpty) {
        result.sort((a, b) => b.readingDate.compareTo(a.readingDate));
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

  Future<String> getSvgPic(String svgUrl) async {
    try {
      final res = await repository.fetchSvgData(svgUrl);
      return res;
    } catch (e) {
      return '';
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
  final KlimatologiManualController controller =
      Get.find<KlimatologiManualController>();
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
        padding: const EdgeInsets.all(10),
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
        DataGridCell<double>(
          columnName: 'thermometerMin',
          value: row.thermometerMin != null
              ? double.parse(row.thermometerMin!.toStringAsFixed(2))
              : row.thermometerMin,
        ),
        DataGridCell<double>(
          columnName: 'thermometerMax',
          value: row.thermometerMax != null
              ? double.parse(row.thermometerMax!.toStringAsFixed(2))
              : row.thermometerMax,
        ),
        DataGridCell<double>(
          columnName: 'thermometerAvg',
          value: row.thermometerAvg != null
              ? double.parse(row.thermometerAvg!.toStringAsFixed(2))
              : row.thermometerAvg,
        ),
        DataGridCell<double>(
          columnName: 'psychrometerDryBall',
          value: row.psychrometerDryBall != null
              ? double.parse(row.psychrometerDryBall!.toStringAsFixed(2))
              : row.psychrometerDryBall,
        ),
        DataGridCell<double>(
          columnName: 'psychrometerWetBall',
          value: row.psychrometerWetBall != null
              ? double.parse(row.psychrometerWetBall!.toStringAsFixed(2))
              : row.psychrometerWetBall,
        ),
        DataGridCell<double>(
          columnName: 'psycrometerDepresi',
          value: row.psycrometerDepresi != null
              ? double.parse(row.psycrometerDepresi!.toStringAsFixed(2))
              : row.psycrometerDepresi,
        ),
        DataGridCell<double>(
          columnName: 'pychrometerRh',
          value: row.pychrometerRh != null
              ? double.parse(row.pychrometerRh!.toStringAsFixed(2))
              : row.pychrometerRh,
        ),
        DataGridCell<double>(
          columnName: 'thermometerApungMin',
          value: row.thermometerApungMin != null
              ? double.parse(row.thermometerApungMin!.toStringAsFixed(2))
              : row.thermometerApungMin,
        ),
        DataGridCell<double>(
          columnName: 'thermometerApungMax',
          value: row.thermometerApungMax != null
              ? double.parse(row.thermometerApungMax!.toStringAsFixed(2))
              : row.thermometerApungMax,
        ),
        DataGridCell<double>(
          columnName: 'thermometerApungAvg',
          value: row.thermometerApungAvg != null
              ? double.parse(row.thermometerApungAvg!.toStringAsFixed(2))
              : row.thermometerApungAvg,
        ),
        DataGridCell<double>(
          columnName: 'evaporationWaterAdded',
          value: row.evaporationWaterAdded != null
              ? double.parse(row.evaporationWaterAdded!.toStringAsFixed(2))
              : row.evaporationWaterAdded,
        ),
        DataGridCell<double>(
          columnName: 'evaporationWaterRemoved',
          value: row.evaporationWaterRemoved != null
              ? double.parse(row.evaporationWaterRemoved!.toStringAsFixed(2))
              : row.evaporationWaterRemoved,
        ),
        DataGridCell<double>(
          columnName: 'evaporationWaterSum',
          value: row.evaporationWaterSum != null
              ? double.parse(row.evaporationWaterSum!.toStringAsFixed(2))
              : row.evaporationWaterSum,
        ),
        DataGridCell<double>(
          columnName: 'anemometerWind',
          value: row.anemometerWind != null
              ? double.parse(row.anemometerWind!.toStringAsFixed(2))
              : row.anemometerWind,
        ),
        DataGridCell<double>(
          columnName: 'anemometerSpeed',
          value: row.anemometerSpeed != null
              ? double.parse(row.anemometerSpeed!.toStringAsFixed(2))
              : row.anemometerSpeed,
        ),
        DataGridCell<double>(
          columnName: 'rainfallManual',
          value: row.rainfallManual != null
              ? double.parse(row.rainfallManual!.toStringAsFixed(2))
              : row.rainfallManual,
        ),
        DataGridCell<double>(
          columnName: 'rainfalAutomatic',
          value: row.rainfalAutomatic != null
              ? double.parse(row.rainfalAutomatic!.toStringAsFixed(2))
              : row.rainfalAutomatic,
        ),
        DataGridCell<String>(columnName: 'note', value: row.note),
      ]);
    }).toList(growable: false);
  }
}
