part of 'data_muse_bloc.dart';

sealed class DataMuseState extends Equatable {
  const DataMuseState();

  @override
  List<Object> get props => [];
}

final class DataMuseInitial extends DataMuseState {}

final class DataMuseLoading extends DataMuseState {}

class DataMuseLoaded extends DataMuseState {
  final List<DataMuseEntity> words;

  const DataMuseLoaded({required this.words});
}

final class DataMuseError extends DataMuseState {
  final String errorText;

  const DataMuseError({required this.errorText});
}
