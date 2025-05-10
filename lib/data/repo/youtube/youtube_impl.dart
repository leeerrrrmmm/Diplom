import 'package:diplom/data/data_source/youtube/youtube_data_source.dart';
import 'package:diplom/domain/repo/youtube/youtube_repo.dart';
import 'package:diplom/domain/entity/youtube/youtube_entity.dart';

class YoutubeRepositoryImpl implements YoutubeRepository {
  final YoutubeDataSource dataSource;

  YoutubeRepositoryImpl(this.dataSource);

  @override
  @override
  Future<(List<YoutubeVideoEntity>, String?)> searchYoutube({
    required String query,
    int maxResults = 20,
    String? pageToken,
  }) async {
    final (items, nextPageToken) = await dataSource.searchYoutubeRes(
      query: query,
      maxResults: maxResults,
      pageToken: pageToken,
    );

    return (items, nextPageToken);
  }
}
