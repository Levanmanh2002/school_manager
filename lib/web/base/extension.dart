import 'package:flutter/material.dart';
import 'package:school_web/main.dart';

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

AppSchoolWebState? findRootAncestorState(BuildContext context) {
  return context.findRootAncestorStateOfType<AppSchoolWebState>();
}

void someFunction(BuildContext context, Locale locale) {
  AppSchoolWebState? mainAppState = findRootAncestorState(context);
  if (mainAppState != null) {
    mainAppState.handleLanguageChange(locale);
  }
}
