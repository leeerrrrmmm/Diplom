import 'package:diplom/domain/entity/app_lang_entity/app_lan_entity.dart';

abstract class LocaleRepo {
  Future<void> saveLocale(AppLocale locale);
  Future<AppLocale> getSavedLocale();
}
