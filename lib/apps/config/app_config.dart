import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/colors/gf_color.dart';

class AppConfig {
  static double fontSizeLarge = 20.r;
  static double fontSizeXL = 24.r;
  static double fontSize = 16.r;
  static double fontMedion = 14.r;
  static double fontSizeSmall = 12.r;

  static double verticalSpace = 20.r;
  static double defaultPadding = 20.r;

  static Color bgLogin = const Color(0XFF3A57E8);
  static Color focusTextField = const Color(0xFFFFC828);
  static const Color primaryColor = Color(0XFF3A57E8);

  static ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: GFColors.WHITE,
    colorScheme: const ColorScheme(
      primary: primaryColor,
      secondary: GFColors.SECONDARY,
      surface: primaryColor,
      error: GFColors.DANGER,
      onPrimary: GFColors.LIGHT,
      onSecondary: GFColors.SECONDARY,
      onSurface: GFColors.FOCUS,
      onError: GFColors.WHITE,
      brightness: Brightness.light,
    ),
  );
}
