import 'package:diplom/domain/entity/app_lang_entity/app_lan_entity.dart';
import 'package:diplom/domain/repo/lang_repo/lan_repo.dart';

class GetSavedLocale {
  final LocaleRepo lanRepo;

  GetSavedLocale(this.lanRepo);

  Future<AppLocale> call() async {
    return await lanRepo.getSavedLocale();
  }
}
