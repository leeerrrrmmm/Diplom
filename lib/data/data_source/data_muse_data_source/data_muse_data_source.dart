import 'dart:convert';
import 'dart:developer';
import 'package:diplom/data/models/data_muse_model/data_muse_model.dart';
import 'package:http/http.dart' as http;

class DataMuseDataSource {
  final String _baseUrl = 'https://api.datamuse.com/words';

  Future<List<DataMuseModel>> fetchWords(String query) async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl?ml=$query'));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((el) => DataMuseModel.fromJson(el)).toList();
      } else {
        throw Exception('Failed to fetch words');
      }
    } catch (e) {
      log('Error fetching words: $e');
      throw Exception('throw ERROR: $e');
    }
  }

  Future<List<DataMuseModel>> fetchRhyme(String query) async {
    try {
      final uri = Uri.https('api.datamuse.com', '/words', {'rel_rhy': query});
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((el) => DataMuseModel.fromJson(el)).toList();
      } else {
        throw Exception('Failed to fetch rhyme words');
      }
    } catch (e) {
      log('Error fetching rhyme words: $e');
      throw Exception('throw rhyme ERROR: $e');
    }
  }

  Future<List<DataMuseModel>> fetchSynonym(String query) async {
    try {
      final uri = Uri.http('api.datamuse.com', '/words', {'rel_syn': query});
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((el) => DataMuseModel.fromJson(el)).toList();
      } else {
        throw Exception('Error fetch synonym words');
      }
    } catch (e) {
      log('Error fetching synonym words: $e');
      throw Exception('throw synonym ERROR: $e');
    }
  }

  Future<List<DataMuseModel>> fetchAntonym(String query) async {
    try {
      final uri = Uri.http('api.datamuse.com', '/words', {'rel_ant': query});
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        return data.map((el) => DataMuseModel.fromJson(el)).toList();
      } else {
        throw Exception('Error fetch synonym words');
      }
    } catch (e) {
      log('Error fetching antonym words: $e');
      throw Exception('throw antonym ERROR: $e');
    }
  }
}
