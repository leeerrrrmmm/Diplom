import 'package:diplom/domain/entity/wiki/wiki_entity.dart';
import 'package:diplom/domain/repo/wiki/wiki_repo.dart';

class GetWikiSummary {
  final WikiRepo repository;

  GetWikiSummary(this.repository);

  Future<WikiSummary> call(String term) {
    return repository.getSummary(term);
  }
}
