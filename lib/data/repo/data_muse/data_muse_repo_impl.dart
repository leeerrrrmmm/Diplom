import 'package:diplom/data/data_source/data_muse_data_source/data_muse_data_source.dart';
import 'package:diplom/domain/entity/data_muse/data_muse_entity.dart';
import 'package:diplom/domain/repo/data_muse/data_muse_repo.dart';

class DataMuseRepoImpl extends DataMuseRepo {
  final DataMuseDataSource dataMuseDataSource;

  DataMuseRepoImpl(this.dataMuseDataSource);

  @override
  Future<List<DataMuseEntity>> fetchWords(String query) async {
    return dataMuseDataSource.fetchWords(query);
  }

  @override
  Future<List<DataMuseEntity>> fetchRhymeWords(String query) async {
    return dataMuseDataSource.fetchRhyme(query);
  }

  @override
  Future<List<DataMuseEntity>> fetchSynonymWords(String query) async {
    return dataMuseDataSource.fetchSynonym(query);
  }

  @override
  Future<List<DataMuseEntity>> fetchAntonymWords(String query) async {
    return dataMuseDataSource.fetchAntonym(query);
  }
}
