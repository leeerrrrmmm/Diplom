import 'package:diplom/domain/entity/data_muse/data_muse_entity.dart';
import 'package:diplom/domain/repo/data_muse/data_muse_repo.dart';

class DataMuseUseCases {
  final DataMuseRepo reposiitory;

  DataMuseUseCases(this.reposiitory);

  Future<List<DataMuseEntity>> call(String query) async {
    return reposiitory.fetchWords(query);
  }

  Future<List<DataMuseEntity>> callRhyme(String query) async {
    return reposiitory.fetchRhymeWords(query);
  }

  Future<List<DataMuseEntity>> fethSynonymWords(String query) async {
    return reposiitory.fetchSynonymWords(query);
  }

  Future<List<DataMuseEntity>> fetchAntonymWords(String query) async {
    return reposiitory.fetchAntonymWords(query);
  }
}
