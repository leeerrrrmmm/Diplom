part of 'open_lib_bloc.dart';

sealed class OpenLibEvent extends Equatable {
  const OpenLibEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialBooks extends OpenLibEvent {}

class SearchBooks extends OpenLibEvent {
  final String query;

  const SearchBooks(this.query);
}

class LoadMoreBooks extends OpenLibEvent {}
