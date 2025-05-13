import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:diplom/data/models/lib/open_lib_model.dart';

class RemoteLibDataSource {
  final _baseurl = 'https://openlibrary.org/search.json';
  final _detailUrl = 'https://openlibrary.org';

  Future<List<OpenLibModel>> searchBoks(
    String query,
    int page,
    int limit,
  ) async {
    try {
      final res = await http.get(
        Uri.parse('$_baseurl?q=$query&page=$page&limit=$limit'),
      );

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        final List docs = jsonData['docs'];
        return docs.map((e) => OpenLibModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load books. Status code: ${res.statusCode}');
      }
    } catch (e) {
      log('Error in REMOTE LIB DATA SOURCE:$e');
      throw Exception('Error while fetching books: $e');
    }
  }

  Future<OpenLibModel> fetchCurrentBook(String bookKey) async {
    try {
      final res = await http.get(Uri.parse("$_detailUrl/$bookKey.json"));

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        final data = OpenLibModel.fromJson(json);

        return data;
      } else {
        throw Exception('Error fetch current book data');
      }
    } catch (e) {
      log('Error in REMOTE LIB DATA FETCHING CURRENT BOOK SOURCE:$e');
      throw Exception('Error while fetching current book: $e');
    }
  }
}
