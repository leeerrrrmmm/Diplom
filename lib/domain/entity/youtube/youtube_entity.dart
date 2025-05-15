// lib/domain/entities/youtube_video_entity.dart

class YoutubeVideoEntity {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final String channelId;
  final String channelImg; // Ссылка на иконку канала
  final String publishedAt;
  final String videoUrl;
  final String viewCount;

  YoutubeVideoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.channelId,
    required this.channelImg,
    required this.publishedAt,
    required this.videoUrl,
    required this.viewCount,
  });
}
