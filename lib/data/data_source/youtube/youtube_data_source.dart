import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:diplom/data/models/youtube/youtube_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YoutubeDataSource {
  final String _baseUrl = 'https://www.googleapis.com/youtube/v3/search';
  final String _apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';

  Future<(List<YoutubeModel>, String?)> searchYoutubeRes({
    required String query,
    int maxResults = 20,
    String? pageToken,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?part=snippet&q=$query&type=video&maxResults=$maxResults&key=$_apiKey'
        '${pageToken != null ? '&pageToken=$pageToken' : ''}',
      );

      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        final items = jsonData['items'] as List;
        final nextPageToken = jsonData['nextPageToken'] as String?;

        final videos =
            items.map((item) => YoutubeModel.fromJson(item)).toList();

        return (videos, nextPageToken);
      } else {
        throw Exception('Failed to load results');
      }
    } catch (e) {
      log('Error loading YouTube results: $e');
      throw Exception('Error data source: $e');
    }
  }
}
