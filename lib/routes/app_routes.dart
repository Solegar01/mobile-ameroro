// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/cctv/views/cctv_view.dart';
import 'package:mobile_ameroro_app/apps/cctv/views/cctv_detail_view.dart';
import 'package:mobile_ameroro_app/apps/home/views/home_view.dart';
import 'package:mobile_ameroro_app/apps/instrument/views/instrument_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/arr/views/arr_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/views/awlr_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/ews/views/ews_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/inklinometer/views/inklinometer_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/intake/views/intake_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_aws/views/klimatologi_aws_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/klimatologi_manual/views/klimatologi_manual_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/observation_well/views/observation_well_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/open_standpipe/views/open_standpipe_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/robotic_total_station/views/robotic_total_station_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/settlement_meter/views/settlement_meter_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/vibrating_wire/views/vibrating_wire_view.dart';
import 'package:mobile_ameroro_app/apps/instruments/vnotch/views/vnotch_view.dart';
import 'package:mobile_ameroro_app/apps/login/views/login_view.dart';
import 'package:mobile_ameroro_app/apps/map/views/map_view.dart';
import 'package:mobile_ameroro_app/apps/menu/views/menu_view.dart';
import 'package:mobile_ameroro_app/apps/profile/views/profile_view.dart';
import 'package:mobile_ameroro_app/apps/profile/views/profile_detail_view.dart';
import 'package:mobile_ameroro_app/apps/splash/views/splash_view.dart';
import 'package:mobile_ameroro_app/bindings/arr_binding.dart';
import 'package:mobile_ameroro_app/bindings/awlr_binding.dart';
import 'package:mobile_ameroro_app/bindings/cctv_binding.dart';
import 'package:mobile_ameroro_app/bindings/ews_binding.dart';
import 'package:mobile_ameroro_app/bindings/home_binding.dart';
import 'package:mobile_ameroro_app/bindings/inklinometer_binding.dart';
import 'package:mobile_ameroro_app/bindings/instrumnet_binding.dart';
import 'package:mobile_ameroro_app/bindings/intake_binding.dart';
import 'package:mobile_ameroro_app/bindings/klimatologi_aws_binding.dart';
import 'package:mobile_ameroro_app/bindings/klimatologi_manual_binding.dart';
import 'package:mobile_ameroro_app/bindings/login_binding.dart';
import 'package:mobile_ameroro_app/bindings/map_binding.dart';
import 'package:mobile_ameroro_app/bindings/menu_binding.dart';
import 'package:mobile_ameroro_app/bindings/observation_well_binding.dart';
import 'package:mobile_ameroro_app/bindings/open_standpipe_binding.dart';
import 'package:mobile_ameroro_app/bindings/profile_binding.dart';
import 'package:mobile_ameroro_app/bindings/robotic_total_station_binding.dart';
import 'package:mobile_ameroro_app/bindings/settlement_meter_binding.dart';
import 'package:mobile_ameroro_app/bindings/splash_binding.dart';
import 'package:mobile_ameroro_app/bindings/vibrating_wire_binding.dart';
import 'package:mobile_ameroro_app/bindings/vnotch_binding.dart';

class AppRoutes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const PROFILE_DETAIL = '/profile_detail';
  static const MAP = '/map';
  static const CCTV = '/cctv';
  static const CCTV_DETAIL = '/cctv_detail';
  static const INSTRUMENT = '/intrument';
  static const MENU = '/menu';
  static const INTAKE = '/instrument/intake';
  static const AWLR = '/instrument/awlr';
  static const ARR = '/instrument/arr';
  static const AWLR_DETAIL = '/instrument/awlr_detail';
  static const KLIMATOLOGI_MANUAL = '/instrument/klimatologi_manual';
  static const KLIMATOLOGI_AWS = '/instrument/klimatologi_aws';
  static const VNOTCH = '/instrument/vnotch';
  static const ROBOTIC_TOTAL_STATION = '/instrument/robotic_total_station';
  static const VIBRATING_WIRE = '/instrument/vibrating_wire';
  static const OPEN_STANDPIPE = '/instrument/open_standpipe';
  static const EWS = '/instrument/ews';
  static const INKLINOMETER = '/instrument/inklinometer';
  static const OBSERVATION_WELL = '/instrument/observation_well';
  static const SETTLEMENT_METER = '/instrument/settlement_meter';

  static final pages = [
    GetPage(
      name: SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: PROFILE_DETAIL,
      page: () => ProfileDetailView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: CCTV,
      page: () => CctvView(),
      binding: CctvBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: CCTV_DETAIL,
      page: () => CctvDetailView(),
      binding: CctvBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: MAP,
      page: () => PetaView(),
      binding: MapBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: MENU,
      page: () => MenuView(),
      binding: MenuBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: INTAKE,
      page: () => IntakeView(),
      binding: IntakeBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: INSTRUMENT,
      page: () => InstrumentView(),
      binding: InstrumnetBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: AWLR,
      page: () => AwlrView(),
      binding: AwlrBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: ARR,
      page: () => ArrView(),
      binding: ArrBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: AWLR_DETAIL,
      page: () => AwlrView(),
      binding: AwlrBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: KLIMATOLOGI_MANUAL,
      page: () => KlimatologiManualView(),
      binding: KlimatologiManualBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: KLIMATOLOGI_AWS,
      page: () => KlimatologiAwsView(),
      binding: KlimatologiAwsBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: VNOTCH,
      page: () => VNotchView(),
      binding: VNotchBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: ROBOTIC_TOTAL_STATION,
      page: () => RoboticTotalStationView(),
      binding: RoboticTotalStationBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: VIBRATING_WIRE,
      page: () => VibratingWireView(),
      binding: VibratingWireBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: OPEN_STANDPIPE,
      page: () => OpenStandpipeView(),
      binding: OpenStandpipeBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: EWS,
      page: () => EwsView(),
      binding: EwsBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: INKLINOMETER,
      page: () => InklinometerView(),
      binding: InklinometerBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: OBSERVATION_WELL,
      page: () => ObservationWellView(),
      binding: ObservationWellBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      name: SETTLEMENT_METER,
      page: () => SettlementMeterView(),
      binding: SettlementMeterBinding(),
    ),
  ];
}
