part of 'get_events_bloc.dart';

@immutable
sealed class GetEventsState extends Equatable {}

final class GetEventsInitialState extends GetEventsState {
  @override
  List<Object> get props => [];
}

final class GetEventsLoadingState extends GetEventsState {
  @override
  List<Object> get props => [];
}

final class GetEventsLoadedState extends GetEventsState {
  final List<Event> events;

  GetEventsLoadedState({required this.events});

  @override
  List<Object> get props => [events];
}

final class GetEventsErrorState extends GetEventsState {
  final String message;

  GetEventsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
