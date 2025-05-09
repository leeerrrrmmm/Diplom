part of 'open_lib_bloc.dart';

class OpenLibState {
  final List<OpenLibEntity> books;
  final bool hasReachedEnd;
  final bool isLoading;
  final String currentQuery;
  final int currentPage;

  OpenLibState({
    required this.books,
    required this.hasReachedEnd,
    required this.isLoading,
    required this.currentQuery,
    required this.currentPage,
  });

  OpenLibState copyWith({
    List<OpenLibEntity>? books,
    bool? hasReachedEnd,
    bool? isLoading,
    String? currentQuery,
    int? currentPage,
  }) {
    return OpenLibState(
      books: books ?? this.books,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoading: isLoading ?? this.isLoading,
      currentQuery: currentQuery ?? this.currentQuery,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  factory OpenLibState.initial() => OpenLibState(
    books: [],
    hasReachedEnd: false,
    isLoading: false,
    currentQuery: "flutter", // По умолчанию запрос на "flutter"
    currentPage: 1, // Стартовая страница
  );
}
