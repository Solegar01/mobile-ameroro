import 'package:intl/intl.dart';

class AppConstants {
  //Time
  final dateTimeFullFormatID = DateFormat('dd MMM yyyy HH:mm', 'id_ID');
  final dateTimeFormatID = DateFormat('yyyy MMM dd HH:mm', 'id_ID');
  final dateFormatID = DateFormat('d MMMM yyyy', 'id_ID');
  final dateFullDayFormatID = DateFormat('EEEE, MMM d, yyyy', 'id_ID');
  final dateTimeFullDayFormatID = DateFormat('EEEE, d MMMM, yyyy', 'id_ID');
  final hourMinuteFormat = DateFormat('HH:mm', 'id_ID');
  final numFormat = NumberFormat('#,###.###');

  //Home
  static String alarmTopic = 'ews/EWS001/alarm';
  static String muteTopic = 'ews/EWS001/mute';
  static String bsh1Topic = 'ews/EWS001/devices/HGT686/realtime';
  static String intakeTopic = 'ews/EWS001/devices/HGT685/realtime';
  static String bsh2Topic = 'ews/EWS001/devices/HGT687/realtime';
  static String bsh3Topic = 'ews/EWS001/devices/HGT684/realtime';
  static String bsh1StatusTopic = 'ews/EWS001/devices/HGT686/statusLevel';
  static String bsh2StatusTopic = 'ews/EWS001/devices/HGT687/statusLevel';
  static String bsh3StatusTopic = 'ews/EWS001/devices/HGT684/statusLevel';
  static String intakeStatusTopic = 'ews/EWS001/devices/HGT685/statusLevel';

  //Pagination table
  static double dataPagerHeight = 60;
  static double dataRowHeight = 40;

  //Url API
  static String bmkgUrl =
      'https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=36.04.28.2012';
  static String cctvUrl = 'cctv';
  static String awlrUrl = 'awlr';
  static String awlrReadingUrl = 'awlr/reading';
  static String arrUrl = 'arr';
  static String arrReadingUrl = 'arr/reading';
  static String awlrDetailUrl = 'instrument/awlr/detail';
  static String stationDeviceUrl = 'station/device';
  static String inklinometerUrl = 'inklinometer';
  static String intakeUrl = 'intake';
  static String awsLastReadingUrl = 'aws/last';
  static String awsReadingUrl = 'aws/reading';
  static String awsUrl = 'klimatologi/aws';
  static String klimatologiManualUrl = 'klimatologi/manual';
  static String owsSensorUrl = 'observationwell/sensors';
  static String owsUrl = 'observationwell';
  static String ospStationUrl = 'openstandpipe/station';
  static String ospElevationUrl = 'openstandpipe/elevasi';
  static String ospUrl = 'openstandpipe';
  static String rtsUrl = 'rts';
  static String vibratingWireUrl = 'vibrating-wire';
  static String vwSensorUrl = 'vibrating-wire/sensors';
  static String vnotchUrl = 'vnotch';

  // Storage Key (name + Key)
  static const String tokenKey = 'token';
  static const String loginKey = 'login';
  static const String selectedAwlr = 'selected-awlr';
  static const String selectedArr = 'selected-arr';
}
