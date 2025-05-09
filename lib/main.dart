import 'package:diplom/data/data_source/data_muse_data_source/data_muse_data_source.dart';
import 'package:diplom/data/data_source/open_lib/remote_lib_data_source.dart';
import 'package:diplom/data/data_source/wiki/remote_data_source.dart';
import 'package:diplom/data/repo/data_muse/data_muse_repo_impl.dart';
import 'package:diplom/data/repo/open_lib/open_lib_repo_impl.dart';
import 'package:diplom/data/repo/wiki_impl/wiki_repo_impl.dart';
import 'package:diplom/domain/usecases/data_muse/data_muse_use_cases.dart';
import 'package:diplom/domain/usecases/open_lib_use_cases/open_lib_user_cases.dart';
import 'package:diplom/domain/usecases/wiki/wiki_uses_case.dart';
import 'package:diplom/presentation/app.dart';
import 'package:diplom/presentation/bloc/data_muse_bloc/data_muse_bloc.dart';
import 'package:diplom/presentation/bloc/open_lib_bloc/open_lib_bloc.dart';
import 'package:diplom/presentation/bloc/wiki_bloc/wiki_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // wiki
  final remoteDataSource = WikiRemoteDataSource();
  final repository = WikiRepositoryImpl(remoteDataSource);
  final getSummary = GetWikiSummary(repository);

  // TODO: WIKI API Возможности (MediaWiki API / REST API)

  // 1. Поиск статей по ключевому слову
  // Пример: https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=Flutter&format=json

  // 2. Получение краткой информации (summary) о статье
  // Пример: https://en.wikipedia.org/api/rest_v1/page/summary/Flutter

  // 3. Получение полного содержимого статьи
  // Пример: https://en.wikipedia.org/w/api.php?action=parse&page=Flutter&format=json

  // 4. Получение категорий статьи
  // Пример: https://en.wikipedia.org/w/api.php?action=query&prop=categories&titles=Flutter&format=json

  // 5. Получение внутренних ссылок (на какие статьи ссылается)
  // Пример: https://en.wikipedia.org/w/api.php?action=query&prop=links&titles=Flutter&format=json

  // 6. Получение изображений статьи
  // Пример: https://en.wikipedia.org/w/api.php?action=query&prop=images&titles=Flutter&format=json

  // 7. Автозаполнение и предложения по запросу
  // Пример: https://en.wikipedia.org/w/api.php?action=opensearch&search=Flutt&limit=5&format=json

  // 8. Переводы статьи на другие языки
  // Пример: https://en.wikipedia.org/w/api.php?action=query&prop=langlinks&titles=Flutter&format=json

  // open lib
  final remoteLibDataSource = RemoteLibDataSource();
  final reposiitory = OpenLibRepoImpl(remoteLibDataSource);
  final getBookUsesCase = GetBooksUseCase(reposiitory);

  //todo 📚 Open Library API — TODO с примерами
  // ✅ 1. Создание приложения с рекомендованными книгами
  // 📌 Цель: Показ популярных/интересных книг пользователю.

  // 📎 Пример запроса:
  // https://openlibrary.org/subjects/fantasy.json?limit=10
  // (можно заменить fantasy на другие категории: science_fiction, romance, mystery, history, и т.д.)

  // ✅ 2. Просмотр биографии автора и всех его книг
  // 📌 Цель: Пользователь кликает на автора и видит все его книги + описание.

  // 📎 Шаг 1: Получить автора по ID:
  // https://openlibrary.org/authors/OL23919A.json

  // 📎 Шаг 2: Получить список его работ:
  // https://openlibrary.org/authors/OL23919A/works.json

  // ✅ 3. Отображение обложек и описаний для UX
  // 📌 Цель: Показать визуально привлекательный список книг.

  // 📎 Пример обложки:
  // https://covers.openlibrary.org/b/id/240727-L.jpg
  // (варианты размеров: S, M, L)

  // 📎 Пример описания книги:
  // https://openlibrary.org/works/OL45883W.json → поле description

  // ✅ 4. Сортировка и фильтрация по темам, дате, языку
  // 📌 Цель: Пользователь выбирает фильтры в UI.

  // 📎 Пример фильтрации по теме и языку:
  // https://openlibrary.org/subjects/science_fiction.json?language=eng&limit=10

  // 📎 Пример поиска с фильтром по дате:
  // https://openlibrary.org/search.json?q=flutter&published_in=2020-2024

  //data muse
  final remoteDataMuseSource = DataMuseDataSource();
  final repo = DataMuseRepoImpl(remoteDataMuseSource);
  final getWords = DataMuseUseCases(repo);

  /// TODO: Интеграция с DataMuse API 🔍
  ///
  /// Возможности:
  ///
  /// ✅ Поиск похожих слов (синонимы)
  ///    - Пример: https://api.datamuse.com/words?ml=smart → clever, intelligent, bright...
  ///
  /// ✅ Поиск рифм
  ///    - Пример: https://api.datamuse.com/words?rel_rhy=blue → true, do, shoe, you...
  ///
  /// ✅ Ассоциативные слова (часто встречающиеся рядом)
  ///    - Пример: https://api.datamuse.com/words?rel_trg=fire → smoke, burn, heat, flames...
  ///
  /// ✅ Поиск по шаблону (начинается, заканчивается, содержит и т.д.)
  ///    - Пример: https://api.datamuse.com/words?sp=a*e → ace, age, alive, aside...
  ///
  /// ✅ Комбинирование параметров
  ///    - Пример: https://api.datamuse.com/words?ml=fast&rel_syn=quick
  ///
  /// План:
  /// 1. Создать модель слов WordModel.
  /// 2. Реализовать DataSource с методами по параметрам API.
  /// 3. Реализовать Repository.
  /// 4. Написать UseCase (например, GetSynonymsUseCase, GetRhymesUseCase).
  /// 5. Реализовать BLoC/State.
  /// 6. Добавить UI с полем ввода и отображением результатов.
  ///
  /// Документация: https://www.datamuse.com/api/

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WikiBloc(getSummary)),
        BlocProvider(create: (context) => OpenLibBloc(getBookUsesCase)),
        BlocProvider(create: (context) => DataMuseBloc(getWords)),
      ],
      child: App(),
    ),
  );
}
