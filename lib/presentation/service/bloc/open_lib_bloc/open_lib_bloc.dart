import 'dart:developer';

import 'package:diplom/domain/entity/lib/open_lib.dart';
import 'package:diplom/domain/usecases/open_lib_use_cases/open_lib_user_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'open_lib_event.dart';
part 'open_lib_state.dart';

class OpenLibBloc extends Bloc<OpenLibEvent, OpenLibState> {
  final GetBooksUseCase getBooksUseCase;
  final int limit = 14;

  OpenLibBloc(this.getBooksUseCase) : super(OpenLibState.initial()) {
    on<LoadInitialBooks>(_onLoadInitialBooks);
    on<SearchBooks>(_onSearchBooks);
    on<LoadMoreBooks>(_onLoadMoreBooks);
    on<FetchBookDetailEvent>(_onFetchCurrentBook);
  }

  Future<void> _onLoadInitialBooks(
    LoadInitialBooks event,
    Emitter<OpenLibState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final books = await getBooksUseCase(state.currentQuery, 1, limit);
      emit(state.copyWith(books: books, isLoading: false, currentPage: 1));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onSearchBooks(
    SearchBooks event,
    Emitter<OpenLibState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, currentQuery: event.query));
    try {
      final books = await getBooksUseCase(event.query, 1, limit);
      emit(state.copyWith(books: books, isLoading: false, currentPage: 1));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadMoreBooks(
    LoadMoreBooks event,
    Emitter<OpenLibState> emit,
  ) async {
    if (state.hasReachedEnd || state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    try {
      final nextPage = state.currentPage + 1;
      final books = await getBooksUseCase(state.currentQuery, nextPage, limit);
      if (books.isEmpty) {
        emit(state.copyWith(isLoading: false, hasReachedEnd: true));
      } else {
        emit(
          state.copyWith(
            books: [...state.books, ...books],
            currentPage: nextPage,
            isLoading: false,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onFetchCurrentBook(
    FetchBookDetailEvent event,
    Emitter<OpenLibState> emit,
  ) async {
    emit(state.copyWith(isBookLoading: true));

    try {
      final bookKey = event.bookKey;

      final book = await getBooksUseCase.fetchCurrentBook(bookKey);

      emit(state.copyWith(selectedBook: book, isBookLoading: false));
    } catch (e) {
      log('Error fetching current book: $e');
      emit(
        state.copyWith(
          isBookLoading: false, // Останавливаем индикатор загрузки
          selectedBook: null, // Сбрасываем выбранную книгу
        ),
      );
    }
  }
}
