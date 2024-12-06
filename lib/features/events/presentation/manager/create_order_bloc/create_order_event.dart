part of 'create_order_bloc.dart';

@immutable
sealed class CreateOrderEvent extends Equatable{}

class CreateOrderEventStarted extends CreateOrderEvent{
  final String authToken;
  final String eventId;
  final String type;
  final int quantity;
  final double price;
  CreateOrderEventStarted({
    required this.authToken,
    required this.eventId,
    required this.type,
    required this.quantity,
    required this.price
  });

  @override
  List<Object?> get props => [authToken, eventId, price, type, quantity];
}
