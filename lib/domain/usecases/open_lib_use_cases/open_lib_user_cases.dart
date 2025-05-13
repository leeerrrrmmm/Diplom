import 'package:diplom/domain/entity/lib/open_lib.dart';
import 'package:diplom/domain/repo/open_lib_repo/open_lib_rep.dart';

class GetBooksUseCase {
  final OpenLibRep repository;

  GetBooksUseCase(this.repository);

  Future<List<OpenLibEntity>> call(String query, int page, int limit) async {
    return repository.searchBooks(query, page, limit);
  }

  Future<OpenLibEntity> fetchCurrentBook(String bookKey) async {
    return repository.fetchCurrentBook(bookKey);
  }
}
