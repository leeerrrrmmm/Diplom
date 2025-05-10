import 'package:diplom/domain/entity/youtube/youtube_entity.dart';

class YoutubeModel extends YoutubeVideoEntity {
  YoutubeModel({
    required super.videoId,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.channelTitle,
  });

  factory YoutubeModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final snippet = json['snippet'];
    final thumbnails = snippet?['thumbnails'];
    final highResThumb = thumbnails?['high'];

    return YoutubeModel(
      videoId: id?['videoId'] ?? '',
      title: snippet?['title'] ?? 'No Title',
      description: snippet?['description'] ?? 'No Description',
      thumbnailUrl: highResThumb?['url'] ?? '',
      channelTitle: snippet?['channelTitle'] ?? 'Unknown Channel',
    );
  }
}
