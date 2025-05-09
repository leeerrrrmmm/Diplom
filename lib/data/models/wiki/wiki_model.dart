import 'package:diplom/domain/entity/wiki/wiki_entity.dart';

class WikiSummaryModel extends WikiSummary {
  WikiSummaryModel({
    required super.title,
    required super.extract,
    super.imageUrl,
  });
  factory WikiSummaryModel.fromJson(Map<String, dynamic> json) {
    return WikiSummaryModel(
      title: json['title'],
      extract: json['extract'],
      imageUrl: json['thumbnail']?['source'],
    );
  }
}
