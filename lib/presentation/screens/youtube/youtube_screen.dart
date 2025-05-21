import 'package:diplom/core/components/build_text.dart';
import 'package:diplom/generated/l10n.dart';
import 'package:diplom/presentation/screens/detail/youtube/youtube_detail.dart';
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

  String formatViewCount(String viewCount) {
    final int count = int.tryParse(viewCount) ?? 0;

    if (count >= 1000000000) {
      return '${(count / 1000000000).toStringAsFixed(1)}B';
    } else if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localString = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final containerColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
              BlocBuilder<YoutubeBloc, YoutubeState>(
                builder: (context, state) {
                  if (state.isLoading && state.results.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: state.results.length + (state.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.results.length) {
                        final res = state.results[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          YoutubeVideoPlayer(videoId: res.id),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(color: containerColor),
                              child: Column(
                                children: <Widget>[
                                  Image.network(
                                    res.thumbnailUrl,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                              res.channelImg,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              BuildText(
                                                text: res.title,
                                                textColor: textColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              Row(
                                                children: [
                                                  BuildText(
                                                    text:
                                                        ' ${res.channelTitle} ·',
                                                    textColor:
                                                        isDark
                                                            ? Colors.white70
                                                            : Colors.black87,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  BuildText(
                                                    text:
                                                        ' ${formatViewCount(res.viewCount)} views',
                                                    textColor:
                                                        isDark
                                                            ? Colors.white70
                                                            : Colors.black87,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
            ],
          ),
        ),
      ),
    );
  }
}
