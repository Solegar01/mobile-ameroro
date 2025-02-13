import 'package:flutter/material.dart';
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
      cursorColor: GFColors.WHITE,
      controller: controller,
      style: TextStyle(
        fontSize: AppConfig.fontSize,
        color: GFColors.WHITE,
      ),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: AppConfig.fontSize,
            color: GFColors.WHITE,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: GFColors.WHITE,
              width: 2.0,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: GFColors.WHITE,
              width: 2.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: GFColors.WHITE.withOpacity(0.1),
              width: 2.0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: GFColors.WHITE,
              width: 2.0,
            ),
          ),
          floatingLabelStyle: const TextStyle(color: GFColors.WHITE),
          prefixIcon: Icon(
            icon,
            color: const Color(0XFF213265),
          ),
          suffixIcon: enableSuffixIcon == true
              ? GestureDetector(
                  onTap: onTapSuffixIcon,
                  child: Icon(
                    color: const Color(0XFF213265),
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
