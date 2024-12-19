import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';

class TextInputCustom extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function()? onTapSuffixIcon;
  final bool? enableSuffixIcon;

  const TextInputCustom(
      {Key? key,
      required this.label,
      required this.controller,
      this.icon,
      this.obscureText = false,
      this.enableSuffixIcon = false,
      this.onTapSuffixIcon,
      required this.onChanged,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: AppConfig.fontSize,
        color: GFColors.LIGHT,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0.r),
          labelText: label,
          labelStyle: TextStyle(fontSize: AppConfig.fontSize),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: GFColors.WHITE.withOpacity(0.35), // Default border color
              width: 2.0,
            ),
          ),
          prefixIcon: Icon(
            icon,
            color: GFColors.INFO.withOpacity(0.65),
          ),
          suffixIcon: enableSuffixIcon == true
              ? GestureDetector(
                  onTap: onTapSuffixIcon,
                  child: Icon(
                    suffixIcon,
                  ),
                )
              : null
          // suffixIcon: Icon(Icons.remove_red_eye_outlined),
          ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}