part of 'youtube_bloc.dart';

abstract class YoutubeEvent extends Equatable {
  const YoutubeEvent();
  @override
  List<Object?> get props => [];
}

class SearchResults extends YoutubeEvent {
  final String query;

  const SearchResults(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreResults extends YoutubeEvent {}

class LoadInitialResults extends YoutubeEvent {}
