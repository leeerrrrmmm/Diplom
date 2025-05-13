import 'dart:ui';

class AppLocale {
  final String languageCode;

  AppLocale(this.languageCode);

  Locale toLocale() => Locale(languageCode);
}
