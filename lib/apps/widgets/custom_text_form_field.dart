import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';

enum InputFormatter {
  number,
  decimal,
  text,
}

Widget customTextFormField({
  required TextEditingController controller,
  required String text,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
  bool enabled = true,
  int maxLines = 1,
  int? minLines,
  int? maxLength,
  void Function(String)? onFieldSubmitted,
  InputFormatter? inputFormatter,
  List<TextInputFormatter>? inputFormatters,
  void Function()? onTap,
  void Function(String)? onChanged,
  void Function()? onEditingComplete,
  bool? filled,
  Widget? suffixIcon,
  Widget? prefixIcon,
  bool obscureText = false,
  String? msgValidator,
  Iterable<String>? autofillHints,
  Color fillColor = Colors.white,
  Color textColor = Colors.black87,
  FocusNode? focusNode,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: inputFormatter == InputFormatter.number
        ? TextInputType.number
        : inputFormatter == InputFormatter.decimal
            ? const TextInputType.numberWithOptions(
                decimal: true, signed: false)
            : keyboardType,
    readOnly: readOnly,
    enabled: enabled,
    maxLines: maxLines,
    minLines: minLines,
    onFieldSubmitted: onFieldSubmitted,
    inputFormatters: inputFormatter == InputFormatter.number
        ? [FilteringTextInputFormatter.digitsOnly]
        : inputFormatter == InputFormatter.decimal
            ? [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text;
                  return text.isEmpty
                      ? newValue
                      : double.tryParse(text) == null
                          ? oldValue
                          : newValue;
                }),
              ]
            : inputFormatters,
    autofillHints: autofillHints,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    onChanged: onChanged,
    obscureText: obscureText,
    style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
    decoration: InputDecoration(
      hintText: text,
      hintStyle: TextStyle(
        color: enabled
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.1),
      ),
      fillColor: fillColor,
      filled: filled,
      alignLabelWithHint: true,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppConfig.primaryColor, width: 2.r),
          borderRadius: BorderRadius.circular(12.r)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.r),
          borderRadius: BorderRadius.circular(12.r)),
      disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12.r)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: GFColors.DANGER, width: 2.r),
          borderRadius: BorderRadius.circular(12)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: GFColors.DANGER, width: 2.r),
          borderRadius: BorderRadius.circular(12.r)),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    ),
    validator: (value) {
      if (value!.isEmpty && msgValidator != null && enabled == true) {
        return msgValidator;
      }
      return null;
    },
    maxLength: maxLength,
    onEditingComplete: onEditingComplete,
    focusNode: focusNode,
  );
}
