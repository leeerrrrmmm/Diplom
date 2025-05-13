import 'package:diplom/core/const/app_locale.dart';
import 'package:diplom/domain/entity/app_lang_entity/app_lan_entity.dart';
import 'package:diplom/domain/repo/lang_repo/lan_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepoImpl extends LocaleRepo {
  @override
  Future<AppLocale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(localeKey) ?? 'en';
    return AppLocale(code);
  }

  @override
  Future<void> saveLocale(AppLocale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(localeKey, locale.languageCode);
  }
}
