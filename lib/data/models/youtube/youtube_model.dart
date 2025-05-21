import 'package:diplom/domain/entity/youtube/youtube_entity.dart';

class YoutubeModel extends YoutubeVideoEntity {
  YoutubeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.channelTitle,
    required super.channelId,
    required super.channelImg,
    required super.publishedAt,
    required super.videoUrl,
    required super.viewCount,
  });

  // Из search JSON
  factory YoutubeModel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final id = json['id'] ?? {};

    final isVideo = id['kind'] == 'youtube#video';
    final videoId = isVideo ? id['videoId'] : id['channelId'];
    final videoUrl =
        isVideo
            ? 'https://www.youtube.com/watch?v=$videoId'
            : 'https://www.youtube.com/channel/$videoId';

    final highThumb = snippet['thumbnails']?['high']?['url'] ?? '';

    return YoutubeModel(
      id: videoId ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnailUrl: highThumb,
      channelTitle: snippet['channelTitle'] ?? '',
      channelId: snippet['channelId'] ?? '',
      channelImg: '', // поки що пусто, заповніться потім
      publishedAt: snippet['publishedAt'] ?? '',
      videoUrl: videoUrl,
      viewCount: '0', // поки 0, додається потім
    );
  }

  // Оновлення моделі з додатковими данними: Іконка каналу та перегляди
  YoutubeModel copyWith({String? channelImg, String? viewCount}) {
    return YoutubeModel(
      id: id,
      title: title,
      description: description,
      thumbnailUrl: thumbnailUrl,
      channelTitle: channelTitle,
      channelId: channelId,
      channelImg: channelImg ?? this.channelImg,
      publishedAt: publishedAt,
      videoUrl: videoUrl,
      viewCount: viewCount ?? this.viewCount,
    );
  }
}
