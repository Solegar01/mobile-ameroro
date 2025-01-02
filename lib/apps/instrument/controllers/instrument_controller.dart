import 'package:get/get.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';

class InstrumentController extends GetxController {
  List<Map<String, String>> sensors = [
    // {
    //   'sensor': 'TMA Intake',
    //   'image': 'intake-icon.png',
    //   'route': AppRoutes.INTAKE
    // },
    {'sensor': 'AWLR', 'image': 'awlr-icon.png', 'route': AppRoutes.AWLR},
    {'sensor': 'ARR', 'image': 'arr-icon.png', 'route': AppRoutes.ARR},
    // {
    //   'sensor': 'Klimatologi Manual',
    //   'image': 'klimatologi-manual-icon.png',
    //   'route': AppRoutes.KLIMATOLOGI_MANUAL
    // },
    // {
    //   'sensor': 'AWS',
    //   'image': 'aws-icon.png',
    //   'route': AppRoutes.KLIMATOLOGI_AWS
    // },
    // {
    //   'sensor': 'V-Notch',
    //   'image': 'vnotch-icon.png',
    //   'route': AppRoutes.VNOTCH
    // },
    // {
    //   'sensor': 'Robotic Total Station',
    //   'image': 'rts-icon.png',
    //   'route': AppRoutes.ROBOTIC_TOTAL_STATION
    // },
    // {
    //   'sensor': 'Vibrating Wire',
    //   'image': 'vibrating-wire-icon.png',
    //   'route': AppRoutes.VIBRATING_WIRE
    // },
    // {
    //   'sensor': 'Open Standpipe',
    //   'image': 'open-stand-pipe-icon.png',
    //   'route': AppRoutes.OPEN_STANDPIPE
    // },
    // {
    //   'sensor': 'Inklinometer',
    //   'image': 'inklinometer-icon.png',
    //   'route': AppRoutes.INKLINOMETER
    // },
    // {
    //   'sensor': 'Observation Well',
    //   'image': 'observation-well-icon.png',
    //   'route': AppRoutes.OBSERVATION_WELL
    // },
  ];
}
