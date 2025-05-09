import 'package:diplom/domain/entity/lib/open_lib.dart';

abstract class OpenLibRep {
  Future<List<OpenLibEntity>> searchBooks(String query, int page, int limit);
}
