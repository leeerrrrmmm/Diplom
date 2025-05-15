import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diplom/data/models/youtube/youtube_model.dart';

class YoutubeDataSource {
  final String _searchUrl = 'https://www.googleapis.com/youtube/v3/search';
  final String _channelsUrl = 'https://www.googleapis.com/youtube/v3/channels';
  final String _apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';

  Future<(List<YoutubeModel>, String?)> searchYoutubeRes({
    required String query,
    int maxResults = 20,
    String? pageToken,
  }) async {
    final searchUri = Uri.parse(
      '$_searchUrl?part=snippet&q=$query&type=video&maxResults=$maxResults&key=$_apiKey'
      '${pageToken != null ? '&pageToken=$pageToken' : ''}',
    );

    final searchRes = await http.get(searchUri);

    if (searchRes.statusCode != 200) {
      throw Exception('Failed to load search results');
    }

    final searchData = jsonDecode(searchRes.body);
    final items = searchData['items'] as List;
    final nextPageToken = searchData['nextPageToken'] as String?;

    final videos = items.map((item) => YoutubeModel.fromJson(item)).toList();

    final videoIds = videos.map((v) => v.id).toList();

    // Запрос статистики видео
    final statsUri = Uri.parse(
      'https://www.googleapis.com/youtube/v3/videos?part=statistics&id=${videoIds.join(",")}&key=$_apiKey',
    );

    final statsRes = await http.get(statsUri);

    if (statsRes.statusCode != 200) {
      throw Exception('Failed to load videos statistics');
    }

    final statsData = jsonDecode(statsRes.body);
    final statsItems = statsData['items'] as List;

    // Создаем мапу videoId -> statistics (viewCount)
    final Map<String, String> viewCountMap = {};
    for (var statItem in statsItems) {
      final id = statItem['id'];
      final viewCount = statItem['statistics']['viewCount'] ?? '0';
      viewCountMap[id] = viewCount;
    }

    // Запрос информации о каналах
    final channelIds = videos.map((v) => v.channelId).toSet().toList();

    final channelsUri = Uri.parse(
      '$_channelsUrl?part=snippet&id=${channelIds.join(",")}&key=$_apiKey',
    );

    final channelsRes = await http.get(channelsUri);

    if (channelsRes.statusCode != 200) {
      throw Exception('Failed to load channels info');
    }

    final channelsData = jsonDecode(channelsRes.body);
    final channelsItems = channelsData['items'] as List;

    final Map<String, String> channelImgMap = {};
    for (var ch in channelsItems) {
      final id = ch['id'];
      final img = ch['snippet']['thumbnails']['default']['url'];
      channelImgMap[id] = img;
    }

    // Обновляем видео, добавляя channelImg и viewCount
    final videosWithExtra =
        videos.map((v) {
          return v.copyWith(
            channelImg: channelImgMap[v.channelId] ?? '',
            viewCount: viewCountMap[v.id] ?? '0',
          );
        }).toList();

    return (videosWithExtra, nextPageToken);
  }
}
