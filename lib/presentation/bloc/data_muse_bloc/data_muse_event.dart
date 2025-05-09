part of 'data_muse_bloc.dart';

sealed class DataMuseEvent extends Equatable {
  const DataMuseEvent();

  @override
  List<Object> get props => [];
}

class SearchWords extends DataMuseEvent {
  final String query;
  const SearchWords({required this.query});
}
