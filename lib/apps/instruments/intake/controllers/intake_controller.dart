import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/models/intake_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/repository/intake_repository.dart';
import 'dart:developer';
import 'package:mobile_ameroro_app/apps/instruments/intake/models/station_model.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:mobile_ameroro_app/helpers/date_convertion.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class IntakeController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  final IntakeRepository repository;
  IntakeController(this.repository);
  late TabController tabController;

  RxList<WaterIntake> listIntake = RxList.empty(growable: true);
  var currentIndex = 0.obs;
  late IntakeModel intakeData;
  String dateFormatGraph = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String lastStatus = "";
  final List<int> hollowJetFilter = [600, 1000];
  final List<String> hollowJetPercentFilter = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%',
    '35%',
    '40%',
    '45%',
    '50%',
    '55%',
    '60%',
    '65%',
    '70%',
    '75%',
    '80%',
    '85%',
    '90%',
    '95%',
    '100%'
  ];

  RxInt selectedHollow = RxInt(600);
  RxString selectedHollowPerc = RxString('0%');
  Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>(
      DateTimeRange(start: DateTime.now(), end: DateTime.now()));
  TextEditingController dateRangeController = TextEditingController();
  RxString lastReading =
      DateFormatter.formatDateTimeToLocal(DateTime.now()).obs;
  RxString unit = 'mdpl'.obs;
  RxDouble tma = 0.0.obs;
  Rx<Station> station = Station().obs;

  final int rowsPerPage = 10; // Rows per page
  RxList<WaterIntake> displayedData = <WaterIntake>[].obs; // Paginated data
  RxInt currentPage = 0.obs; // Current page

  late TableDataSource tableDataSource;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);
    await formInit();

    super.onInit();
  }

  void changeTab(int index) {
    currentIndex.value = index;
    log(currentIndex.value.toString());
    update();
  }

  formInit() async {
    intakeData = IntakeModel(intake: [], rainfall: []);
    dateRangeController.text =
        '${AppConstants().dateFormatID.format(selectedDateRange.value!.start)} - ${AppConstants().dateFormatID.format(selectedDateRange.value!.end)}';
    await getData();
    await _getDataStation();
    update();
  }

  Future<TableDataSource> getTableDataSource() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return tableDataSource;
  }

  Future<List<WaterIntake>> getChartData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listIntake;
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

  _getDataStation() async {
    await repository.getStation('HGT685').then((data) {
      if (data != null) {
        station.value = data;
      }
    });
  }

  getData() async {
    change(null, status: RxStatus.loading());
    listIntake.clear();
    try {
      intakeData = IntakeModel(intake: [], rainfall: []);
      await repository
          .getData(selectedDateRange.value!.start, selectedDateRange.value!.end)
          .then((value) {
        if (value != null) intakeData = value;
      });

      if (intakeData.intake.isNotEmpty) {
        intakeData.intake.sort((a, b) => b.readingAt.compareTo(a.readingAt));
        for (var data in intakeData.intake) {
          listIntake.add(data);
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

  void updateDisplayedData() {
    int start = currentPage.value * rowsPerPage;
    int end = start + rowsPerPage;
    displayedData.value = listIntake.sublist(
      start,
      end > listIntake.length ? listIntake.length : end,
    );
    tableDataSource.buildPaginatedDataGridRows();
    update(['table']);
  }
}

class TableDataSource extends DataGridSource {
  final IntakeController controller = Get.find<IntakeController>();
  TableDataSource() {
    if (controller.listIntake.isNotEmpty) {
      int perPage = controller.listIntake.length >= controller.rowsPerPage
          ? controller.rowsPerPage
          : controller.listIntake.length;
      controller.displayedData.value =
          controller.listIntake.getRange(0, perPage).toList(growable: false);
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
    if (startIndex < controller.listIntake.length &&
        endIndex <= controller.listIntake.length) {
      controller.displayedData.value = controller.listIntake
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
      double? hollJetVal = controller.selectedHollow.value == 600
          ? row.hollowJetAperture600
          : row.hollowJetAperture1000;
      double percVal = double.parse(
              controller.selectedHollowPerc.value.replaceAll('%', '')) /
          100;
      double hollJetPercVal = (hollJetVal ?? 0) * percVal;
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'readingAt',
          value: AppConstants().dateFormatID.format(row.readingAt),
        ),
        DataGridCell<String>(
          columnName: 'hourMinuteFormat',
          value: AppConstants().hourMinuteFormat.format(row.readingAt),
        ),
        DataGridCell<double>(
          columnName: 'waterLevel',
          value: row.waterLevel != null
              ? double.parse(row.waterLevel!.toStringAsFixed(2))
              : row.waterLevel,
        ),
        DataGridCell<double>(
          columnName: 'storageVolume',
          value: row.storageVolume != null
              ? double.parse(row.storageVolume!.toStringAsFixed(2))
              : row.storageVolume,
        ),
        DataGridCell<double>(
          columnName: 'floodArea',
          value: row.floodArea != null
              ? double.parse(row.floodArea!.toStringAsFixed(2))
              : row.floodArea,
        ),
        DataGridCell<double>(
          columnName: 'debit',
          value: row.debit != null
              ? double.parse(row.debit!.toStringAsFixed(2))
              : row.debit,
        ),
        DataGridCell<double>(
          columnName: 'hollJetVal',
          value: hollJetVal != null
              ? double.parse(hollJetVal.toStringAsFixed(2))
              : hollJetVal,
        ),
        DataGridCell<double>(
            columnName: 'hollJetPercVal',
            value: double.parse(hollJetPercVal.toStringAsFixed(2))),
        DataGridCell<double>(
          columnName: 'overflow',
          value: row.overflow != null
              ? double.parse(row.overflow!.toStringAsFixed(2))
              : row.overflow,
        ),
        DataGridCell<double>(
          columnName: 'totalRunoffPlusHollowJet',
          value: row.totalRunoffPlusHollowJet != null
              ? double.parse(row.totalRunoffPlusHollowJet!.toStringAsFixed(2))
              : row.totalRunoffPlusHollowJet,
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
