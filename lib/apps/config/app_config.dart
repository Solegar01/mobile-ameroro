import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';

class AppConfig {
  static double fontSizeLarge = 20;
  static double fontSizeXL = 24;
  static double fontSize = 16;
  static double fontMedion = 14;
  static double fontSizeSmall = 12;

  static double verticalSpace = 20;
  static double defaultPadding = 20;

  static Color bgLogin = const Color(0XFF3A57E8);
  static Color focusTextField = const Color(0xFFFFC828);
  static const Color primaryColor = Color(0XFF3A57E8);
  static const Color secondaryColor = Color(0xFFFFC828);
  static const Color errorColor = Color(0xFFEC4134);

  static ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.blueGrey[50],
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
