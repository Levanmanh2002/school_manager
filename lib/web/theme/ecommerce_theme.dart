import 'package:flutter/material.dart';
import 'package:school_web/web/theme/base_app_theme.dart';
import 'package:school_web/web/theme/base_theme_data.dart';

class AppThemeDefault extends BaseAppTheme<AppLightThemeDefault, AppDarkThemeDefault> {
  @override
  AppDarkThemeDefault get darkTheme => AppDarkThemeDefault();

  @override
  AppLightThemeDefault get lightTheme => AppLightThemeDefault();
}

class AppLightThemeDefault extends BaseThemeData {
  @override
  Color get primaryColor => const Color(0xFF0F172A);

  @override
  Color get secondaryColor => const Color(0xFFFF9F29);

  @override
  Color get primaryTextColor => Colors.white;

  @override
  Color get thirdColor => const Color(0xFF0F172A);

  @override
  Color get fadeTextColor => const Color(0xFF94A3B8);
}

class AppDarkThemeDefault extends BaseThemeData {
  @override
  Color get background => const Color(0xFF0F172A);

  @override
  Color get fadeTextColor => const Color(0xFF64748B);

  @override
  Color get primaryTextColor => const Color(0xFF0F172A);

  @override
  Color get secondaryTextColor => const Color(0xFFFF9F29);

  @override
  Color get primaryColor => Colors.white;
}
