import 'package:diplom/presentation/service/bloc/open_lib_bloc/open_lib_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenLib extends StatefulWidget {
  const OpenLib({super.key});
  @override
  State<OpenLib> createState() => _OpenLibState();
}

class _OpenLibState extends State<OpenLib> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OpenLibBloc>().add(LoadInitialBooks());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<OpenLibBloc>().add(LoadMoreBooks());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Open Library")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (query) {
                context.read<OpenLibBloc>().add(SearchBooks(query));
              },
              decoration: InputDecoration(
                hintText: "Search books...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<OpenLibBloc, OpenLibState>(
              builder: (context, state) {
                if (state.isLoading && state.books.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state.currentQuery.isEmpty) {}
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.books.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.books.length) {
                      final book = state.books[index];
                      return ListTile(
                        leading:
                            book.coverUrl != null
                                ? Image.network(book.coverUrl!)
                                : null,
                        title: Text(book.title),
                        subtitle: Text(book.author),
                      );
                    } else {
                      return state.isLoading
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : SizedBox();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
