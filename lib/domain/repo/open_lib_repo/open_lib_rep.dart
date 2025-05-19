import 'package:diplom/domain/entity/open_lib/open_lib.dart';

abstract class OpenLibRep {
  Future<List<OpenLibEntity>> searchBooks(String query, int page, int limit);

  Future<OpenLibEntity> fetchCurrentBook(String bookId);
}
