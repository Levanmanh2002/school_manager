import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/constants/app_constant_key.dart';
import 'package:uuid/uuid.dart';

extension DateStringExtension on String {
  bool get isTodayDateFormat {
    final splitText = split('/');
    final now = DateTime.now();
    return now.day == int.parse(splitText[0]) &&
        int.parse(splitText[2]) == now.year &&
        now.month == int.parse(splitText[1]);
  }
}

extension DateTimeExtension on DateTime? {
  String? get toHourFormat {
    return this == null ? null : DateFormat(HOUR_FORMAT).format(this ?? DateTime.now());
  }

  String? get toDayFormat {
    return this == null ? null : DateFormat(DAY_FORMAT).format(this ?? DateTime.now());
  }

  bool isSameTime(DateTime dateTime) {
    final now = this ?? DateTime.now();
    return now.day == dateTime.day &&
        now.month == dateTime.month &&
        now.year == dateTime.year &&
        now.hour == dateTime.hour &&
        now.minute == dateTime.minute;
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  Size get screenSize => MediaQuery.of(this).size;
}

extension FocusNodeExtension on FocusNode {
  void unfocusListener(VoidCallback function) {
    addListener(() {
      if (!hasFocus) {
        function();
      }
    });
  }
}

const _uuid = Uuid();

String getUuid() {
  return _uuid.v1();
}

// MainAppState? findRootAncestorState(BuildContext context) {
//   return context.findRootAncestorStateOfType<MainAppState>();
// }

// void someFunction(BuildContext context, Locale locale) {
//   MainAppState? mainAppState = findRootAncestorState(context);
//   if (mainAppState != null) {
//     mainAppState.handleLanguageChange(locale);
//   }
// }

String removeWhiteSpaceString(String text) {
  var a = text.split(" ")..removeWhere((element) => element.isEmpty);
  return a.join(" ");
}
