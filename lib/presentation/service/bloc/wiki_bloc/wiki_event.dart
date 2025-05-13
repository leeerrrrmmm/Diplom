part of 'wiki_bloc.dart';

sealed class WikiEvent extends Equatable {
  const WikiEvent();

  @override
  List<Object> get props => [];
}

class FetchWiki extends WikiEvent {
  final String term;
  final String language;
  const FetchWiki({required this.term, required this.language});
}
