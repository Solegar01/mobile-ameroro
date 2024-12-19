import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instrument/controllers/instrument_controller.dart';

class InstrumnetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstrumentController>(() => InstrumentController());
  }
}
