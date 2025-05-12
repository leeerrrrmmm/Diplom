part of 'data_muse_bloc.dart';

sealed class DataMuseState extends Equatable {
  const DataMuseState();

  @override
  List<Object> get props => [];
}

final class DataMuseInitial extends DataMuseState {}

final class DataMuseLoading extends DataMuseState {}

final class DataMuseRhymeLoading extends DataMuseState {}

final class DataMuseSynonymLoading extends DataMuseState {}

final class DataMuseAntonymLoading extends DataMuseState {}

class DataMuseLoaded extends DataMuseState {
  final List<DataMuseEntity> words;

  const DataMuseLoaded({required this.words});
}

class DataMuseRhymeLoaded extends DataMuseState {
  final List<DataMuseEntity> rhymeWords;

  const DataMuseRhymeLoaded({required this.rhymeWords});
}

class DataMuseSynonymLoaded extends DataMuseState {
  final List<DataMuseEntity> synonyms;

  const DataMuseSynonymLoaded({required this.synonyms});
}

class DataMuseSAntonymLoaded extends DataMuseState {
  final List<DataMuseEntity> antonyms;

  const DataMuseSAntonymLoaded({required this.antonyms});
}

final class DataMuseError extends DataMuseState {
  final String errorText;

  const DataMuseError({required this.errorText});
}
