part of 'wiki_bloc.dart';

sealed class WikiState extends Equatable {
  const WikiState();

  @override
  List<Object> get props => [];
}

final class WikiInitial extends WikiState {}

final class WikiLoading extends WikiState {}

class WikiLoaded extends WikiState {
  final WikiSummary summary;
  const WikiLoaded(this.summary);
}

class WikiError extends WikiState {
  final String errorMsg;
  const WikiError({required this.errorMsg});
}
