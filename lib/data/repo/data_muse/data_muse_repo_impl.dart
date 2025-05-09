import 'package:diplom/data/data_source/data_muse_data_source/data_muse_data_source.dart';
import 'package:diplom/domain/entity/data_muse/data_muse_entity.dart';
import 'package:diplom/domain/repo/data_muse/data_muse_repo.dart';

class DataMuseRepoImpl extends DataMuseRepo {
  final DataMuseDataSource dataMuseDataSource;

  DataMuseRepoImpl(this.dataMuseDataSource);

  @override
  Future<List<DataMuseEntity>> fetchWords(String query) {
    return dataMuseDataSource.fetchWords(query);
  }
}
