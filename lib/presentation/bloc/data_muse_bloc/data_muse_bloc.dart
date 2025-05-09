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
        final res = await getUseCases(event.query);
        emit(DataMuseLoaded(words: res));
      } catch (e) {
        log("BLOC MODULE ERROR: $e");
      }
    });
  }
}
