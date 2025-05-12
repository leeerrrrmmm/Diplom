part of 'youtube_bloc.dart';

class YoutubeState extends Equatable {
  final List<YoutubeVideoEntity> results;
  final bool isLoading;
  final bool hasReachedEnd;
  final String query;
  final String? nextPageToken;

  const YoutubeState({
    required this.results,
    required this.isLoading,
    required this.hasReachedEnd,
    required this.query,
    required this.nextPageToken,
  });

  factory YoutubeState.initial() => const YoutubeState(
    results: [],
    isLoading: false,
    hasReachedEnd: false,
    query: '',
    nextPageToken: null,
  );

  YoutubeState copyWith({
    List<YoutubeVideoEntity>? results,
    bool? isLoading,
    bool? hasReachedEnd,
    String? query,
    String? nextPageToken,
  }) {
    return YoutubeState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      query: query ?? this.query,
      nextPageToken: nextPageToken ?? this.nextPageToken,
    );
  }

  @override
  List<Object?> get props => [
    results,
    isLoading,
    hasReachedEnd,
    query,
    nextPageToken,
  ];
}
