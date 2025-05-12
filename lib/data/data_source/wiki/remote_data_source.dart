import 'dart:convert';

import 'package:diplom/data/models/wiki/wiki_model.dart';
import 'package:http/http.dart' as http;

class WikiRemoteDataSource {
  final String _url = "https://en.wikipedia.org/api/rest_v1/page/summary";

  Future<WikiSummaryModel> getSummary(String term) async {
    try {
      final res = await http.get(Uri.parse("$_url/$term"));

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        return WikiSummaryModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load summary: ${res.statusCode} ${res.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load summary: $e');
    }
  }
}
