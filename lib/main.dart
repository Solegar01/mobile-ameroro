import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';
import 'package:mobile_ameroro_app/bindings/initial_bindings.dart';
import 'package:mobile_ameroro_app/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Allow only portrait up
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          375, 812), // Ukuran desain yang diinginkan (misalnya iPhone X)
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Bendungan Ameroro',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English
            Locale('id', 'ID'), // INDONESIA
          ],
          theme: AppConfig.themeData,
          initialBinding: InitialBindings(),
          initialRoute: AppRoutes.SPLASH,
          getPages: AppRoutes.pages,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
