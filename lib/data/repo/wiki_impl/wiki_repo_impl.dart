import 'package:diplom/data/data_source/wiki/remote_data_source.dart';
import 'package:diplom/domain/entity/wiki/wiki_entity.dart';
import 'package:diplom/domain/repo/wiki/wiki_repo.dart';

class WikiRepositoryImpl implements WikiRepo {
  final WikiRemoteDataSource remoteDataSource;

  WikiRepositoryImpl(this.remoteDataSource);

  @override
  Future<WikiSummary> getSummary(String term) {
    return remoteDataSource.getSummary(term);
  }
}
