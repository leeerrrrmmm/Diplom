import 'dart:developer';

import 'package:diplom/domain/usecases/data_muse/data_muse_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diplom/domain/entity/data_muse/data_muse_entity.dart';
import 'package:equatable/equatable.dart';

part 'data_muse_event.dart';
part 'data_muse_state.dart';

class DataMuseBloc extends Bloc<DataMuseEvent, DataMuseState> {
  final DataMuseUseCases getUseCases;

  DataMuseBloc(this.getUseCases) : super(DataMuseInitial()) {
    on<SearchWords>((event, emit) async {
      emit(DataMuseLoading());

      try {
        final res = await getUseCases.call(event.query);
        emit(DataMuseLoaded(words: res));
      } catch (e) {
        log("BLOC MODULE ERROR: $e");
        emit(DataMuseError(errorText: 'Ошибка при поиске слов: $e'));
      }
    });

    on<SearchRhymeWords>((event, emit) async {
      emit(DataMuseRhymeLoading());

      try {
        final res = await getUseCases.callRhyme(event.rhymeQuery);
        emit(DataMuseRhymeLoaded(rhymeWords: res));
      } catch (e) {
        log("BLOC MODULE RHYME ERROR: $e");
        emit(DataMuseError(errorText: 'Ошибка при поиске рифм: $e'));
      }
    });

    on<SearchSynonymWords>((event, emit) async {
      emit(DataMuseSynonymLoading());

      try {
        final res = await getUseCases.fethSynonymWords(event.synonymQuery);
        emit(DataMuseSynonymLoaded(synonyms: res));
      } catch (e) {
        log("BLOC MODULE SYNONYM ERROR: $e");
        emit(DataMuseError(errorText: 'Ошибка при поиске synonym: $e'));
      }
    });

    on<SearchAntonymWords>((event, emit) async {
      emit(DataMuseAntonymLoading());

      try {
        final res = await getUseCases.fetchAntonymWords(event.antonymQuery);
        emit(DataMuseSAntonymLoaded(antonyms: res));
      } catch (e) {
        log("BLOC MODULE ANTONYM ERROR: $e");
        emit(DataMuseError(errorText: 'Ошибка при поиске antonym: $e'));
      }
    });
  }
}
