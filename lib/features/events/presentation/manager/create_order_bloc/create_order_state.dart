part of 'create_order_bloc.dart';

@immutable
sealed class CreateOrderState extends Equatable {}

final class CreateOrderInitial extends CreateOrderState {
  @override
  List<Object?> get props => [];
}

final class OrderPlacingState extends CreateOrderState {
  @override
  List<Object?> get props => [];
}

final class OrderPlacedSuccessState extends CreateOrderState {
  final OrderEntity order;

  OrderPlacedSuccessState({required this.order});

  @override
  List<Object?> get props => [order];
}

final class OrderPlacedErrorState extends CreateOrderState {
  final String message;

  OrderPlacedErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
