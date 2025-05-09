import 'package:diplom/data/data_source/open_lib/remote_lib_data_source.dart';
import 'package:diplom/data/data_source/wiki/remote_data_source.dart';
import 'package:diplom/data/repo/open_lib/open_lib_repo_impl.dart';
import 'package:diplom/data/repo/wiki_impl/wiki_repo_impl.dart';
import 'package:diplom/domain/usecases/open_lib_use_cases/open_lib_user_cases.dart';
import 'package:diplom/domain/usecases/wiki/wiki_uses_case.dart';
import 'package:diplom/presentation/app.dart';
import 'package:diplom/presentation/bloc/open_lib_bloc/open_lib_bloc.dart';
import 'package:diplom/presentation/bloc/wiki_bloc/wiki_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // wiki
  final remoteDataSource = WikiRemoteDataSource();
  final repository = WikiRepositoryImpl(remoteDataSource);
  final getSummary = GetWikiSummary(repository);

  // open lib
  final remoteLibDataSource = RemoteLibDataSource();
  final reposiitory = OpenLibRepoImpl(remoteLibDataSource);
  final getBookUsesCase = GetBooksUseCase(reposiitory);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WikiBloc(getSummary)),
        BlocProvider(create: (context) => OpenLibBloc(getBookUsesCase)),
      ],
      child: App(),
    ),
  );
}
