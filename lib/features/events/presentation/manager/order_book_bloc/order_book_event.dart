part of 'order_book_bloc.dart';

@immutable
sealed class OrderBookEvent extends Equatable{}

final class FetchOrderBookEvent extends OrderBookEvent {
  final String eventId;

  FetchOrderBookEvent({required this.eventId});
  @override
  List<Object?> get props => [];
}
