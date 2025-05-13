import 'package:diplom/domain/entity/app_lang_entity/app_lan_entity.dart';
import 'package:diplom/domain/repo/lang_repo/lan_repo.dart';

class SetLocale {
  final LocaleRepo repo;
  SetLocale(this.repo);

  Future<void> call(AppLocale locale) async {
    await repo.saveLocale(locale);
  }
}
