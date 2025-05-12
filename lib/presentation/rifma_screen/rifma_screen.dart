import 'package:diplom/presentation/service/bloc/data_muse_bloc/data_muse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RifmaScreen extends StatefulWidget {
  const RifmaScreen({super.key});

  @override
  State<RifmaScreen> createState() => _RifmaScreenState();
}

class _RifmaScreenState extends State<RifmaScreen> {
  final controller = TextEditingController();

  String searchMode = 'Слова'; // Значения: 'Слова', 'Рифмы', 'Синонимы'

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final bloc = context.read<DataMuseBloc>();
    switch (searchMode) {
      case 'Слова':
        bloc.add(SearchWords(query: value));
        break;
      case 'Рифмы':
        bloc.add(SearchRhymeWords(rhymeQuery: value));
        break;
      case 'Синонимы':
        bloc.add(SearchSynonymWords(synonymQuery: value));
        break;
      case 'Антонимы':
        bloc.add(SearchAntonymWords(antonymQuery: value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DataMuse Поиск"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              value: searchMode,
              items: const [
                DropdownMenuItem(value: 'Слова', child: Text('Слова')),
                DropdownMenuItem(value: 'Рифмы', child: Text('Рифмы')),
                DropdownMenuItem(value: 'Синонимы', child: Text('Синонимы')),
                DropdownMenuItem(value: 'Антонимы', child: Text('Антонимы')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    searchMode = val;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              onSubmitted: _submit,
              decoration: const InputDecoration(
                hintText: "Введите слово",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DataMuseBloc, DataMuseState>(
              builder: (context, state) {
                if (state is DataMuseLoading ||
                    state is DataMuseRhymeLoading ||
                    state is DataMuseSynonymLoading ||
                    state is DataMuseAntonymLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DataMuseLoaded) {
                  return _buildList(state.words);
                } else if (state is DataMuseRhymeLoaded) {
                  return _buildList(state.rhymeWords);
                } else if (state is DataMuseSynonymLoaded) {
                  return _buildList(state.synonyms);
                } else if (state is DataMuseSAntonymLoaded) {
                  return _buildList(state.antonyms);
                } else if (state is DataMuseError) {
                  return Center(child: Text(state.errorText));
                }
                return const Center(child: Text("Введите слово для поиска"));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List words) {
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (_, i) => ListTile(title: Text(words[i].word)),
    );
  }
}
