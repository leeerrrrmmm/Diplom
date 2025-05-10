import 'package:diplom/domain/entity/youtube/youtube_entity.dart';
import 'package:diplom/domain/usecases/youtube/youtube_use_cases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'youtube_event.dart';
part 'youtube_state.dart';

class YoutubeBloc extends Bloc<YoutubeEvent, YoutubeState> {
  final YoutubeUseCases youtubeUseCases;
  final int limit = 20;

  YoutubeBloc(this.youtubeUseCases) : super(YoutubeState.initial()) {
    on<LoadInitialResults>(_onLoadInitialResults);
    on<SearchResults>(_onSearchResults);
    on<LoadMoreResults>(_onLoadMoreResults);
  }

  Future<void> _onLoadInitialResults(
    LoadInitialResults event,
    Emitter<YoutubeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final (results, nextPageToken) = await youtubeUseCases(
        query: "dart", // default query
        maxResults: limit,
      );
      emit(
        state.copyWith(
          results: results,
          isLoading: false,
          query: "dart",
          hasReachedEnd: false,
          nextPageToken: nextPageToken,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onSearchResults(
    SearchResults event,
    Emitter<YoutubeState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        query: event.query,
        results: [],
        hasReachedEnd: false,
      ),
    );

    try {
      final (results, nextPageToken) = await youtubeUseCases(
        query: event.query,
        maxResults: limit,
      );

      emit(
        state.copyWith(
          results: results,
          isLoading: false,
          nextPageToken: nextPageToken,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadMoreResults(
    LoadMoreResults event,
    Emitter<YoutubeState> emit,
  ) async {
    if (state.hasReachedEnd || state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    try {
      final (newResults, nextToken) = await youtubeUseCases(
        query: state.query,
        maxResults: limit,
        pageToken: state.nextPageToken,
      );

      if (newResults.isEmpty || nextToken == null) {
        emit(state.copyWith(isLoading: false, hasReachedEnd: true));
      } else {
        emit(
          state.copyWith(
            results: [...state.results, ...newResults],
            nextPageToken: nextToken,
            isLoading: false,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
