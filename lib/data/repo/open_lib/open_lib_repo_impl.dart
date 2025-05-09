import 'package:diplom/data/data_source/open_lib/remote_lib_data_source.dart';
import 'package:diplom/domain/entity/lib/open_lib.dart';
import 'package:diplom/domain/repo/open_lib_repo/open_lib_rep.dart';

class OpenLibRepoImpl extends OpenLibRep {
  final RemoteLibDataSource remoteDataSource;

  OpenLibRepoImpl(this.remoteDataSource);

  @override
  Future<List<OpenLibEntity>> searchBooks(String query, int page, int limit) {
    return remoteDataSource.searchBoks(query, page, limit);
  }
}
