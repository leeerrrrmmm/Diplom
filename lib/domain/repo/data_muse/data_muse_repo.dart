import 'package:diplom/domain/entity/data_muse/data_muse_entity.dart';

abstract class DataMuseRepo {
  Future<List<DataMuseEntity>> fetchWords(String query);

  Future<List<DataMuseEntity>> fetchRhymeWords(String query);

  Future<List<DataMuseEntity>> fetchSynonymWords(String query);

  Future<List<DataMuseEntity>> fetchAntonymWords(String query);
}
