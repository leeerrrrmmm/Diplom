import 'package:diplom/domain/entity/data_muse/data_muse_entity.dart';

class DataMuseModel extends DataMuseEntity {
  DataMuseModel({required super.word});

  factory DataMuseModel.fromJson(Map<String, dynamic> json) {
    return DataMuseModel(word: json['word']);
  }
}
