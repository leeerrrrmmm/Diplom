import 'package:diplom/presentation/service/bloc/youtube_bloc/youtube_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Youtube extends StatefulWidget {
  const Youtube({super.key});
  @override
  State<Youtube> createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<YoutubeBloc>().add(LoadInitialResults());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<YoutubeBloc>().add(LoadMoreResults());
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
                context.read<YoutubeBloc>().add(SearchResults(query));
              },
              decoration: InputDecoration(
                hintText: "Search ress...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<YoutubeBloc, YoutubeState>(
              builder: (context, state) {
                if (state.isLoading && state.results.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state.query.isEmpty) {}
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.results.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.results.length) {
                      final res = state.results[index];
                      return Card(
                        child: Row(
                          children: <Widget>[
                            Image.network(res.thumbnailUrl, scale: 5),
                            Text(res.channelTitle),
                          ],
                        ),
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
