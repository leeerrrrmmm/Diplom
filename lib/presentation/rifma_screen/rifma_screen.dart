import 'package:diplom/presentation/bloc/data_muse_bloc/data_muse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RifmaScreen extends StatelessWidget {
  const RifmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("DataMuse Words")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              onSubmitted: (value) {
                context.read<DataMuseBloc>().add(SearchWords(query: value));
              },
              decoration: const InputDecoration(
                hintText: "Введите слово",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DataMuseBloc, DataMuseState>(
              builder: (context, state) {
                if (state is DataMuseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DataMuseLoaded) {
                  return ListView.builder(
                    itemCount: state.words.length,
                    itemBuilder:
                        (_, i) => ListTile(title: Text(state.words[i].word)),
                  );
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
}
