import 'package:diplom/presentation/service/common/theme/theme_data_ext.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const _key = 'theme_mode';

  static Future<void> saveThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, theme.toShortString());
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value != null) {
      return ThemeModeExtension.fromString(value);
    }
    return ThemeMode.light;
  }
}
