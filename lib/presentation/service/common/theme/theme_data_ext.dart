import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  String toShortString() {
    return toString().split('.').last;
  }

  static ThemeMode fromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
