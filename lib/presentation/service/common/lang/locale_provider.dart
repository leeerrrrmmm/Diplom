import 'package:diplom/domain/entity/app_lang_entity/app_lan_entity.dart';
import 'package:diplom/domain/usecases/app_lang/get_saved_locale.dart';
import 'package:diplom/domain/usecases/app_lang/set_locale.dart';
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  final GetSavedLocale getSavedLocale;
  final SetLocale setLocaleUseCase;

  Locale? _locale;
  bool _isLoaded = false;

  Locale? get locale => _locale;
  bool get isLoaded => _isLoaded;

  LocaleProvider({
    required this.getSavedLocale,
    required this.setLocaleUseCase,
  }) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final saved = await getSavedLocale();
    _locale = saved.toLocale();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateLocale(Locale locale) async {
    _locale = locale;
    await setLocaleUseCase(AppLocale(locale.languageCode));
    notifyListeners();
  }
}
