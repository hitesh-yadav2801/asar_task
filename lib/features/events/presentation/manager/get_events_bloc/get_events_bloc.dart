import 'package:asar/core/usecase/usecase.dart';
import 'package:asar/features/events/data/models/event_model.dart';
import 'package:asar/features/events/domain/entities/event.dart';
import 'package:asar/features/events/domain/use_cases/fetch_events_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_events_event.dart';

part 'get_events_state.dart';

class GetEventsBloc extends Bloc<GetEventsEvent, GetEventsState> {
  final FetchEventsUseCase _fetchEventsUseCase;

  GetEventsBloc({
    required FetchEventsUseCase fetchEventsUseCase,
  })  : _fetchEventsUseCase = fetchEventsUseCase,
        super(GetEventsInitialState()) {
    on<GetEventsEvent>((event, emit) {
      emit(GetEventsLoadingState());
    });
    on<FetchEventsEvent>(_onFetchEvents);
  }

  void _onFetchEvents(FetchEventsEvent event, Emitter<GetEventsState> emit) async {
    final result = await _fetchEventsUseCase.call(NoParams());

    result.fold(
      (failure) => emit(GetEventsErrorState(message: failure.message)),
      (events) => emit(GetEventsLoadedState(events: events)),
    );
  }
}
