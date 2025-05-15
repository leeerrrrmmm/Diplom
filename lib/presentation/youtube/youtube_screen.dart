import 'package:diplom/core/components/build_text.dart';
import 'package:diplom/domain/entity/youtube/youtube_entity.dart';
import 'package:diplom/generated/l10n.dart';
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
    final localString = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final accentColor = isDark ? Colors.black : Colors.red;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("YouTube"),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (query) {
                context.read<YoutubeBloc>().add(SearchResults(query));
              },
              decoration: InputDecoration(
                hintText: localString.enter_text,
                prefixIcon: const Icon(Icons.search),
                fillColor: isDark ? Colors.grey[800] : Colors.grey[300],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
          ),
          Expanded(
            child: BlocBuilder<YoutubeBloc, YoutubeState>(
              builder: (context, state) {
                if (state.isLoading && state.results.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.results.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.results.length) {
                      final res = state.results[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: SizedBox(
                                child: Image.network(
                                  res.thumbnailUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                BuildText(
                                  text: res.title,
                                  textColor: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                Row(
                                  children: [
                                    BuildText(
                                      text: res.channelTitle,
                                      textColor: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
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
