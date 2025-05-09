import 'package:diplom/domain/entity/data_muse/data_muse_entity.dart';
import 'package:diplom/domain/repo/data_muse/data_muse_repo.dart';

class DataMuseUseCases {
  final DataMuseRepo reposiitory;

  DataMuseUseCases(this.reposiitory);

  Future<List<DataMuseEntity>> call(String query) async {
    return reposiitory.fetchWords(query);
  }
}
