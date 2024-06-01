import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/formatter/no_initial_spaceInput_formatter_widgets.dart';

Widget itemInput({
  required String title,
  required TextEditingController controller,
  required String hintText,
  required String textValue,
  TextInputType? keyboardType,
  int? maxLines = 1,
}) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              title,
              style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
            ),
            const SizedBox(width: 4),
            Text('*', style: TextStyle(color: appTheme.errorColor)),
          ],
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s\s\s+')),
          LengthLimitingTextInputFormatter(300),
          NoInitialSpaceInputFormatterWidgets(),
        ],
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: StyleThemeData.styleSize14Weight400(color: const Color(0xFFB6BBC3)),
          errorStyle: TextStyle(color: appTheme.errorColor),
          labelStyle: StyleThemeData.styleSize14Weight400(height: 0),
          border: const OutlineInputBorder(),
          prefix: const SizedBox(width: 12),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.errorColor),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD2D5DA)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD2D5DA)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return textValue;
          }

          return null;
        },
      ),
    ],
  );
}
