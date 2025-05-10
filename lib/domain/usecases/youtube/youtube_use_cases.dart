import 'package:diplom/domain/entity/youtube/youtube_entity.dart';
import 'package:diplom/domain/repo/youtube/youtube_repo.dart';

class YoutubeUseCases {
  final YoutubeRepository repo;

  YoutubeUseCases(this.repo);

  Future<(List<YoutubeVideoEntity>, String?)> call({
    required String query,
    int maxResults = 20,
    String? pageToken,
  }) async {
    return await repo.searchYoutube(
      query: query,
      maxResults: maxResults,
      pageToken: pageToken,
    );
  }
}
