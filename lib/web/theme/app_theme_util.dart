import 'package:flutter/material.dart';
import 'package:school_web/web/theme/base_app_theme.dart';
import 'package:school_web/web/theme/base_theme_data.dart';
import 'package:school_web/web/theme/ecommerce_theme.dart';

class AppThemeUtil {
  final theme = AppThemeDefault();

  final ValueNotifier<ThemeType> themeType = ValueNotifier(ThemeType.light);

  BaseAppTheme get appTheme => theme;

  void dispose() {
    themeType.dispose();
  }

  ThemeData getThemeData() {
    return theme.getThemeData(themeType.value);
  }

  BaseThemeData getAppTheme() {
    return theme.getBaseTheme(themeType.value);
  }

  onChangeLightDarkMode() {
    if (themeType.value == ThemeType.light) {
      themeType.value = ThemeType.dark;
    } else {
      themeType.value = ThemeType.light;
    }
  }
}
