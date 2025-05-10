import 'package:diplom/domain/entity/youtube/youtube_entity.dart';

abstract class YoutubeRepository {
  Future<(List<YoutubeVideoEntity>, String?)> searchYoutube({
    required String query,
    int maxResults,
    String? pageToken,
  });
}
