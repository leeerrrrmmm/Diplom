import 'dart:developer';

import 'package:diplom/domain/entity/wiki/wiki_entity.dart';
import 'package:diplom/domain/usecases/wiki/wiki_uses_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'wiki_event.dart';
part 'wiki_state.dart';

class WikiBloc extends Bloc<WikiEvent, WikiState> {
  final GetWikiSummary getWikiSummary;

  WikiBloc(this.getWikiSummary) : super(WikiInitial()) {
    on<FetchWiki>((event, emit) async {
      emit(WikiLoading());
      try {
        final summary = await getWikiSummary.call(event.term);
        emit(WikiLoaded(summary));
      } catch (e) {
        log('BLOC MODULE: fetch summary wiki error: $e');
        throw Exception('Error: Bloc summary wiki error: $e');
      }
    });
  }
}
