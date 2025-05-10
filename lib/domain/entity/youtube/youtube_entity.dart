class YoutubeVideoEntity {
  final String videoId;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;

  YoutubeVideoEntity({
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
  });
}
