import 'dart:convert';
import 'package:diplom/data/models/wiki/wiki_model.dart';
import 'package:http/http.dart' as http;

class WikiRemoteDataSource {
  Future<WikiSummaryModel> getSummary(String term, String languageCode) async {
    try {
      final res = await http.get(
        Uri.parse(
          "https://$languageCode.wikipedia.org/api/rest_v1/page/summary/$term",
        ),
      );

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
