import 'package:diplom/data/data_source/data_muse_data_source/data_muse_data_source.dart';
import 'package:diplom/data/data_source/open_lib/remote_lib_data_source.dart';
import 'package:diplom/data/data_source/wiki/remote_data_source.dart';
import 'package:diplom/data/data_source/youtube/youtube_data_source.dart';
import 'package:diplom/data/repo/data_muse/data_muse_repo_impl.dart';
import 'package:diplom/data/repo/lang_repo/locale_repo_impl.dart';
import 'package:diplom/data/repo/open_lib/open_lib_repo_impl.dart';
import 'package:diplom/data/repo/wiki_impl/wiki_repo_impl.dart';
import 'package:diplom/data/repo/youtube/youtube_impl.dart';
import 'package:diplom/domain/usecases/app_lang/get_saved_locale.dart';
import 'package:diplom/domain/usecases/app_lang/set_locale.dart';
import 'package:diplom/domain/usecases/data_muse/data_muse_use_cases.dart';
import 'package:diplom/domain/usecases/open_lib_use_cases/open_lib_user_cases.dart';
import 'package:diplom/domain/usecases/wiki/wiki_uses_case.dart';
import 'package:diplom/domain/usecases/youtube/youtube_use_cases.dart';
import 'package:diplom/presentation/app.dart';
import 'package:diplom/presentation/service/bloc/data_muse_bloc/data_muse_bloc.dart';
import 'package:diplom/presentation/service/bloc/open_lib_bloc/open_lib_bloc.dart';
import 'package:diplom/presentation/service/bloc/wiki_bloc/wiki_bloc.dart';
import 'package:diplom/presentation/service/bloc/youtube_bloc/youtube_bloc.dart';
import 'package:diplom/presentation/service/common/lang/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  // wiki
  final remoteDataSource = WikiRemoteDataSource();
  final repository = WikiRepositoryImpl(remoteDataSource);
  final getSummary = GetWikiSummary(repository);

  // open lib
  final remoteLibDataSource = RemoteLibDataSource();
  final reposiitory = OpenLibRepoImpl(remoteLibDataSource);
  final getBookUsesCase = GetBooksUseCase(reposiitory);

  //data muse
  final remoteDataMuseSource = DataMuseDataSource();
  final repo = DataMuseRepoImpl(remoteDataMuseSource);
  final getWords = DataMuseUseCases(repo);

  //youtube api
  final remoteYoutubeSource = YoutubeDataSource();
  final youtubeRepo = YoutubeRepositoryImpl(remoteYoutubeSource);
  final getRes = YoutubeUseCases(youtubeRepo);

  //lang
  final langRepo = LocaleRepoImpl();
  final getSavedLocale = GetSavedLocale(langRepo);
  final setLocale = SetLocale(langRepo);

  runApp(
    MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => LocaleProvider(
                getSavedLocale: getSavedLocale,
                setLocaleUseCase: setLocale,
              ),
        ),
        BlocProvider(create: (context) => WikiBloc(getSummary)),
        BlocProvider(create: (context) => OpenLibBloc(getBookUsesCase)),
        BlocProvider(create: (context) => DataMuseBloc(getWords)),
        BlocProvider(create: (context) => YoutubeBloc(getRes)),
      ],
      child: App(),
    ),
  );
}
