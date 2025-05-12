part of 'data_muse_bloc.dart';

sealed class DataMuseEvent extends Equatable {
  const DataMuseEvent();

  @override
  List<Object> get props => [];
}

class SearchWords extends DataMuseEvent {
  final String query;
  const SearchWords({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchRhymeWords extends DataMuseEvent {
  final String rhymeQuery;
  const SearchRhymeWords({required this.rhymeQuery});

  @override
  List<Object> get props => [rhymeQuery];
}

class SearchSynonymWords extends DataMuseEvent {
  final String synonymQuery;

  const SearchSynonymWords({required this.synonymQuery});

  @override
  List<Object> get props => [synonymQuery];
}

class SearchAntonymWords extends DataMuseEvent {
  final String antonymQuery;

  const SearchAntonymWords({required this.antonymQuery});

  @override
  List<Object> get props => [antonymQuery];
}
