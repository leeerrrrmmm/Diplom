import 'package:diplom/domain/entity/data_muse/data_muse_entity.dart';

abstract class DataMuseRepo {
  Future<List<DataMuseEntity>> fetchWords(String query);
}
