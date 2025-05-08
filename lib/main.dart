import 'package:diplom/data/data_source/wiki/remote_data_source.dart';
import 'package:diplom/data/repo/wiki_impl/wiki_repo_impl.dart';
import 'package:diplom/domain/usecases/wiki/wiki_uses_case.dart';
import 'package:diplom/presentation/app.dart';
import 'package:diplom/presentation/bloc/wiki_bloc/wiki_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  final remoteDataSource = WikiRemoteDataSource();
  final repository = WikiRepositoryImpl(remoteDataSource);
  final getSummary = GetWikiSummary(repository);
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => WikiBloc(getSummary))],
      child: App(),
    ),
  );
}
