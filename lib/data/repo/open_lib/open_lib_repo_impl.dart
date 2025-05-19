import 'package:diplom/data/data_source/open_lib/remote_lib_data_source.dart';
import 'package:diplom/data/models/open_lib/open_lib_model.dart';
import 'package:diplom/domain/entity/open_lib/open_lib.dart';
import 'package:diplom/domain/repo/open_lib_repo/open_lib_rep.dart';

class OpenLibRepoImpl extends OpenLibRep {
  final RemoteLibDataSource remoteDataSource;

  OpenLibRepoImpl(this.remoteDataSource);

  @override
  Future<List<OpenLibEntity>> searchBooks(
    String query,
    int page,
    int limit,
  ) async {
    return remoteDataSource.searchBoks(query, page, limit);
  }

  @override
  Future<OpenLibModel> fetchCurrentBook(String bookKey) async {
    return remoteDataSource.fetchCurrentBook(bookKey);
  }
}
