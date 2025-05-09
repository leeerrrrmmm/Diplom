import 'package:diplom/domain/entity/lib/open_lib.dart';

class OpenLibModel extends OpenLibEntity {
  OpenLibModel({required super.title, required super.author, super.coverUrl});

  factory OpenLibModel.fromJson(Map<String, dynamic> json) {
    return OpenLibModel(
      title: json['title'] ?? 'Нет названия',
      author:
          (json['author_name'] != null && json['author_name'].isNotEmpty)
              ? json['author_name'][0]
              : 'Неизвестный автор',
      coverUrl:
          json['cover_i'] != null
              ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
              : null,
    );
  }
}
