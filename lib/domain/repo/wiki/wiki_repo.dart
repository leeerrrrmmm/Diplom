import 'package:diplom/domain/entity/wiki/wiki_entity.dart';

abstract class WikiRepo {
  Future<WikiSummary> getSummary(String term);
}
