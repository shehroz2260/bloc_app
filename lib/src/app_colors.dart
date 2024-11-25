// ignore_for_file: overridden_fields, annotate_overrides, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../services/local_storage_service.dart';

class AppColors {
  static Color blackColor = Colors.black;
  static Color whiteColor = Colors.white;
  static Color offWhiteColor = const Color(0xffF3F3F3);
  static Color borderColor = const Color(0xffF3F3F3);
  static Color borderGreyColor = const Color(0xffE8E6EA);
  static Color redColor = const Color(0xffE94057);
  static Color blueColor = Colors.blue.shade600;
}

const kThemeModeKey = '__theme_mode__';

abstract class AppTheme {
  late Color bgColor;
  late Color textColor;
  static final ValueNotifier<ThemeMode> _themeNotifier =
      ValueNotifier(ThemeMode.light);

  static ValueNotifier<ThemeMode> get themeNotifier => _themeNotifier;

  static ThemeMode get themeMode {
    final darkMode = LocalStorageService.storage.read(kThemeModeKey);
    if (darkMode != null) {
      return darkMode ? ThemeMode.dark : ThemeMode.light;
    }
    final Brightness brightness =
        SchedulerBinding.instance.window.platformBrightness;
    bool isDark = brightness == Brightness.dark;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static void initThemeMode() {
    bool? isDarkTheme = LocalStorageService.storage.read(kThemeModeKey);
    _themeNotifier.value = isDarkTheme == null
        ? ThemeMode.system
        : isDarkTheme
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) {
    mode == ThemeMode.system
        ? LocalStorageService.storage.remove(kThemeModeKey)
        : LocalStorageService.storage
            .write(kThemeModeKey, mode == ThemeMode.dark);
    _themeNotifier.value = mode == ThemeMode.system
        ? ThemeMode.system
        : mode == ThemeMode.light
            ? ThemeMode.light
            : ThemeMode.dark;
  }

  static AppTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? DarkModeTheme()
          : LightModeTheme();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFECEFF0),
    brightness: Brightness.dark,
  );
}

class DarkModeTheme extends AppTheme {
  late Color bgColor = Colors.black;
  late Color textColor = Colors.white;
}

class LightModeTheme extends AppTheme {
  late Color bgColor = Colors.white;
  late Color textColor = Colors.black;
}
