class OpenLibEntity {
  final String title;
  final String author;
  final String? coverUrl;
  final String? description;
  final String bookKey;

  OpenLibEntity({
    required this.title,
    required this.author,
    this.description,
    required this.bookKey,
    this.coverUrl,
  });
}
