import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/vibrating_wire/models/vibrating_wire_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/vibrating_wire/repository/vibrating_wire_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';
import 'package:mobile_ameroro_app/helpers/app_constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VibratingWireController extends GetxController with StateMixin {
  final VibratingWireRepository repository;
  VibratingWireController(this.repository);
  VibratingWireModel? model;
  final List<Map<String, String>> instrumentTypes = [
    {'id': 'EP', 'text': 'Tubuh Bendungan'},
    {'id': 'FP', 'text': 'Pondasi Bendungan'}
  ];
  RxMap selectedInstrument = {'id': 'EP', 'text': 'Tubuh Bendungan'}.obs;
  RxMap<String, dynamic> selectedElevation =
      RxMap<String, dynamic>({'id': '', 'text': 'Semua'});
  var selectedDateRange = Rxn<DateTimeRange>(DateTimeRange(
    start: DateTime.now(), // Start date: 7 days ago
    end: DateTime.now(), // End date: Today
  ));
  TextEditingController dateRangeController = TextEditingController();
  RxList<VibratingWire> listModel = RxList.empty(growable: true);

  final int rowsPerPage = 10; // Rows per page
  RxList<VibratingWire> displayedData = <VibratingWire>[].obs; // Paginated data
  RxInt currentPage = 0.obs; // Current page

  late TableDataSource tableDataSource;

  @override
  void onInit() async {
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

  Future<List<VibratingWire>> getChartData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return listModel;
  }

  Future<VibratingWireModel?> getDataModel() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return model;
  }

  Future<List<Map<String, dynamic>>> getElevations() async {
    List<Map<String, dynamic>> res = List.empty(growable: true);
    try {
      String selectedId = selectedInstrument['id'];
      res = await repository.getListElevation(selectedId);
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
          .getData(selectedInstrument['id'], sensor,
              selectedDateRange.value!.start, selectedDateRange.value!.end)
          .then((data) {
        model = data;
        if (model != null) {
          if (model!.listIntake != null) {
            model!.listIntake!
                .sort((a, b) => b.readingDate!.compareTo(a.readingDate!));
          }
          if (model!.listRainFall != null) {
            model!.listRainFall!
                .sort((a, b) => b.readingDate!.compareTo(a.readingDate!));
          }
          if (model!.listVibratingWire != null) {
            model!.listVibratingWire!
                .sort((a, b) => b.readingDate.compareTo(a.readingDate));
          }
        }
      });
      if (model != null) {
        if (model!.listVibratingWire != null) {
          var result = model!.listVibratingWire;
          if (result!.isNotEmpty) {
            result.sort((a, b) => b.readingDate.compareTo(a.readingDate));
            for (var item in result) {
              listModel.add(item);
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
  final VibratingWireController controller =
      Get.find<VibratingWireController>();
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
        //EP1
        DataGridCell<double>(
          columnName: 'sensorEp1R1',
          value: row.sensorEp1R1 != null
              ? double.parse(row.sensorEp1R1!.toStringAsFixed(2))
              : row.sensorEp1R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp1WaterPressureE',
          value: row.sensorEp1WaterPressureE != null
              ? double.parse(row.sensorEp1WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp1WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp1WaterPressureM',
          value: row.sensorEp1WaterPressureM != null
              ? double.parse(row.sensorEp1WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp1WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp1Elevation',
          value: row.sensorEp1Elevation != null
              ? double.parse(row.sensorEp1Elevation!.toStringAsFixed(2))
              : row.sensorEp1Elevation,
        ),
        //EP2
        DataGridCell<double>(
          columnName: 'sensorEp2R1',
          value: row.sensorEp2R1 != null
              ? double.parse(row.sensorEp2R1!.toStringAsFixed(2))
              : row.sensorEp2R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp2WaterPressureE',
          value: row.sensorEp2WaterPressureE != null
              ? double.parse(row.sensorEp2WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp2WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp2WaterPressureM',
          value: row.sensorEp2WaterPressureM != null
              ? double.parse(row.sensorEp2WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp2WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp2Elevation',
          value: row.sensorEp2Elevation != null
              ? double.parse(row.sensorEp2Elevation!.toStringAsFixed(2))
              : row.sensorEp2Elevation,
        ),
        //EP3
        DataGridCell<double>(
          columnName: 'sensorEp3R1',
          value: row.sensorEp3R1 != null
              ? double.parse(row.sensorEp3R1!.toStringAsFixed(2))
              : row.sensorEp3R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp3WaterPressureE',
          value: row.sensorEp3WaterPressureE != null
              ? double.parse(row.sensorEp3WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp3WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp3WaterPressureM',
          value: row.sensorEp3WaterPressureM != null
              ? double.parse(row.sensorEp3WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp3WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp3Elevation',
          value: row.sensorEp3Elevation != null
              ? double.parse(row.sensorEp3Elevation!.toStringAsFixed(2))
              : row.sensorEp3Elevation,
        ),
        //EP4
        DataGridCell<double>(
          columnName: 'sensorEp4R1',
          value: row.sensorEp4R1 != null
              ? double.parse(row.sensorEp4R1!.toStringAsFixed(2))
              : row.sensorEp4R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp4WaterPressureE',
          value: row.sensorEp4WaterPressureE != null
              ? double.parse(row.sensorEp4WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp4WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp4WaterPressureM',
          value: row.sensorEp4WaterPressureM != null
              ? double.parse(row.sensorEp4WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp4WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp4Elevation',
          value: row.sensorEp4Elevation != null
              ? double.parse(row.sensorEp4Elevation!.toStringAsFixed(2))
              : row.sensorEp4Elevation,
        ),
        //EP5
        DataGridCell<double>(
          columnName: 'sensorEp5R1',
          value: row.sensorEp5R1 != null
              ? double.parse(row.sensorEp5R1!.toStringAsFixed(2))
              : row.sensorEp5R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp5WaterPressureE',
          value: row.sensorEp5WaterPressureE != null
              ? double.parse(row.sensorEp5WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp5WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp5WaterPressureM',
          value: row.sensorEp5WaterPressureM != null
              ? double.parse(row.sensorEp5WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp5WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp5Elevation',
          value: row.sensorEp5Elevation != null
              ? double.parse(row.sensorEp5Elevation!.toStringAsFixed(2))
              : row.sensorEp5Elevation,
        ),
        //EP6
        DataGridCell<double>(
          columnName: 'sensorEp6R1',
          value: row.sensorEp6R1 != null
              ? double.parse(row.sensorEp6R1!.toStringAsFixed(2))
              : row.sensorEp6R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp6WaterPressureE',
          value: row.sensorEp6WaterPressureE != null
              ? double.parse(row.sensorEp6WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp6WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp6WaterPressureM',
          value: row.sensorEp6WaterPressureM != null
              ? double.parse(row.sensorEp6WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp6WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp6Elevation',
          value: row.sensorEp6Elevation != null
              ? double.parse(row.sensorEp6Elevation!.toStringAsFixed(2))
              : row.sensorEp6Elevation,
        ),
        //EP7
        DataGridCell<double>(
          columnName: 'sensorEp7R1',
          value: row.sensorEp7R1 != null
              ? double.parse(row.sensorEp7R1!.toStringAsFixed(2))
              : row.sensorEp7R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp7WaterPressureE',
          value: row.sensorEp7WaterPressureE != null
              ? double.parse(row.sensorEp7WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp7WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp7WaterPressureM',
          value: row.sensorEp7WaterPressureM != null
              ? double.parse(row.sensorEp7WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp7WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp7Elevation',
          value: row.sensorEp7Elevation != null
              ? double.parse(row.sensorEp7Elevation!.toStringAsFixed(2))
              : row.sensorEp7Elevation,
        ),
        //EP8
        DataGridCell<double>(
          columnName: 'sensorEp8R1',
          value: row.sensorEp8R1 != null
              ? double.parse(row.sensorEp8R1!.toStringAsFixed(2))
              : row.sensorEp8R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp8WaterPressureE',
          value: row.sensorEp8WaterPressureE != null
              ? double.parse(row.sensorEp8WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp8WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp8WaterPressureM',
          value: row.sensorEp8WaterPressureM != null
              ? double.parse(row.sensorEp8WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp8WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp8Elevation',
          value: row.sensorEp8Elevation != null
              ? double.parse(row.sensorEp8Elevation!.toStringAsFixed(2))
              : row.sensorEp8Elevation,
        ),
        //EP9
        DataGridCell<double>(
          columnName: 'sensorEp9R1',
          value: row.sensorEp9R1 != null
              ? double.parse(row.sensorEp9R1!.toStringAsFixed(2))
              : row.sensorEp9R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp9WaterPressureE',
          value: row.sensorEp9WaterPressureE != null
              ? double.parse(row.sensorEp9WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp9WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp9WaterPressureM',
          value: row.sensorEp9WaterPressureM != null
              ? double.parse(row.sensorEp9WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp9WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp9Elevation',
          value: row.sensorEp9Elevation != null
              ? double.parse(row.sensorEp9Elevation!.toStringAsFixed(2))
              : row.sensorEp9Elevation,
        ),
        //EP10
        DataGridCell<double>(
          columnName: 'sensorEp10R1',
          value: row.sensorEp10R1 != null
              ? double.parse(row.sensorEp10R1!.toStringAsFixed(2))
              : row.sensorEp10R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp10WaterPressureE',
          value: row.sensorEp10WaterPressureE != null
              ? double.parse(row.sensorEp10WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp10WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp10WaterPressureM',
          value: row.sensorEp10WaterPressureM != null
              ? double.parse(row.sensorEp10WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp10WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp10Elevation',
          value: row.sensorEp10Elevation != null
              ? double.parse(row.sensorEp10Elevation!.toStringAsFixed(2))
              : row.sensorEp10Elevation,
        ),
        //EP11
        DataGridCell<double>(
          columnName: 'sensorEp11R1',
          value: row.sensorEp11R1 != null
              ? double.parse(row.sensorEp11R1!.toStringAsFixed(2))
              : row.sensorEp11R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp11WaterPressureE',
          value: row.sensorEp11WaterPressureE != null
              ? double.parse(row.sensorEp11WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp11WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp11WaterPressureM',
          value: row.sensorEp11WaterPressureM != null
              ? double.parse(row.sensorEp11WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp11WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp11Elevation',
          value: row.sensorEp11Elevation != null
              ? double.parse(row.sensorEp11Elevation!.toStringAsFixed(2))
              : row.sensorEp11Elevation,
        ),
        //EP12
        DataGridCell<double>(
          columnName: 'sensorEp12R1',
          value: row.sensorEp12R1 != null
              ? double.parse(row.sensorEp12R1!.toStringAsFixed(2))
              : row.sensorEp12R1,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp12WaterPressureE',
          value: row.sensorEp12WaterPressureE != null
              ? double.parse(row.sensorEp12WaterPressureE!.toStringAsFixed(2))
              : row.sensorEp12WaterPressureE,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp12WaterPressureM',
          value: row.sensorEp12WaterPressureM != null
              ? double.parse(row.sensorEp12WaterPressureM!.toStringAsFixed(2))
              : row.sensorEp12WaterPressureM,
        ),
        DataGridCell<double>(
          columnName: 'sensorEp12Elevation',
          value: row.sensorEp12Elevation != null
              ? double.parse(row.sensorEp12Elevation!.toStringAsFixed(2))
              : row.sensorEp12Elevation,
        ),
        DataGridCell<double>(
          columnName: 'pileElevation',
          value: row.pileElevation != null
              ? double.parse(row.pileElevation!.toStringAsFixed(2))
              : row.pileElevation,
        ),
      ]);
    }).toList(growable: false);
  }
}
