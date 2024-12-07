part of 'order_book_bloc.dart';

@immutable
sealed class OrderBookState extends Equatable {}

final class OrderBookInitial extends OrderBookState {
  @override
  List<Object?> get props => [];
}

final class OrderBookLoading extends OrderBookState {
  @override
  List<Object?> get props => [];
}

final class OrderBookLoaded extends OrderBookState {
  final OrderBook orderBook;

  OrderBookLoaded({required this.orderBook});

  @override
  List<Object?> get props => [orderBook];
}

final class OrderBookError extends OrderBookState {
  final String message;

  OrderBookError({required this.message});

  @override
  List<Object?> get props => [message];
}
