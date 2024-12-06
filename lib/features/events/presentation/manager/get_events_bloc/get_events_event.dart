part of 'get_events_bloc.dart';

@immutable
sealed class GetEventsEvent extends Equatable {}

final class FetchEventsEvent extends GetEventsEvent {
  @override
  List<Object?> get props => [];
}
