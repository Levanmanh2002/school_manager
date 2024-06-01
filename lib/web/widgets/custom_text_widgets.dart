import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/email_validator/email_validator.dart';

class CustomTextWidgets extends StatelessWidget {
  const CustomTextWidgets({
    super.key,
    this.controller,
    this.title = '',
    this.initialData,
    this.color,
    this.keyboardType = TextInputType.text,
    this.validator = false,
    this.style,
    this.enabled = true,
    this.prefixIcon,
    this.boolTitle = false,
    this.colorHint,
    this.inputFormatters,
    this.hintText = '',
    this.borderRadius,
    this.suffixIcon,
    this.showBorder,
    this.contentPadding,
    this.fillColor,
    this.onChanged,
    this.checkEmail = false,
    this.checkLength = false,
    this.checkPhone = false,
    this.maxLines = 1,
  });

  final String title;
  final String? initialData;
  final Color? color;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool validator;
  final TextStyle? style;
  final bool enabled;
  final Widget? prefixIcon;
  final bool boolTitle;
  final Color? colorHint;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final double? borderRadius;
  final Widget? suffixIcon;
  final BorderSide? showBorder;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Function(String)? onChanged;
  final bool checkEmail;
  final bool checkLength;
  final bool checkPhone;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        boolTitle == true
            ? const SizedBox.shrink()
            : Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: style ?? StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                    ),
                  ),
                  validator ? const SizedBox(width: 4) : const SizedBox.shrink(),
                  validator
                      ? Text(
                          '*',
                          style: StyleThemeData.styleSize14Weight400(color: appTheme.errorColor),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
        boolTitle == true ? const SizedBox.shrink() : const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          inputFormatters: inputFormatters,
          cursorColor: appTheme.appColor,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            isDense: true,
            fillColor: fillColor,
            filled: fillColor != null ? true : null,
            hintText: enabled == false ? initialData : hintText,
            hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: colorHint ?? appTheme.textDesColor),
            errorStyle: TextStyle(color: appTheme.errorColor),
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color ?? appTheme.blackColor),
            border: const OutlineInputBorder(),
            prefix: showBorder != null ? null : const SizedBox(width: 12),
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 14),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorBorder: OutlineInputBorder(
              borderSide: showBorder ?? BorderSide(color: appTheme.errorColor),
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: showBorder ?? BorderSide(color: appTheme.errorColor),
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: showBorder ?? const BorderSide(color: Color(0xFFD2D5DA)),
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: showBorder ?? const BorderSide(color: Color(0xFFD2D5DA)),
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
            ),
          ),
          keyboardType: keyboardType,
          // style: StyleThemeData.styleSize14Weight400(color: color, height: 0),
          validator: (value) {
            if (validator != false) {
              if (value == null || value.isEmpty) {
                return 'Thông tin không được để trống';
              } else if (checkEmail && !EmailValidator.validate(value.toString())) {
                return 'Email không hợp lệ';
              } else if (checkLength && value.length < 5) {
                return 'Phải có ít nhất 5 ký tự';
              } else if (checkPhone && !_isPhoneNumberValid(value)) {
                return 'Số điện thoại không hợp lệ!';
              }
            } else {
              return null;
            }

            return null;
          },
        ),
      ],
    );
  }

  bool _isPhoneNumberValid(String value) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(value);
  }
}
