import 'package:diplom/presentation/bloc/wiki_bloc/wiki_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WikiPage extends StatefulWidget {
  const WikiPage({super.key});

  @override
  State<WikiPage> createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wikipedia Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Enter a term..."),
              onSubmitted: (value) {
                context.read<WikiBloc>().add(FetchWiki(term: value));
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<WikiBloc, WikiState>(
                builder: (context, state) {
                  if (state is WikiLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is WikiLoaded) {
                    return Column(
                      children: [
                        if (state.summary.imageUrl != null)
                          Image.network(state.summary.imageUrl!),
                        Text(
                          state.summary.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(state.summary.extract),
                      ],
                    );
                  } else if (state is WikiError) {
                    return Center(child: Text(state.errorMsg));
                  }
                  return Center(child: Text("Введите термин для поиска"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
