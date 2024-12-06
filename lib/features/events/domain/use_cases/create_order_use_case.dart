import 'package:asar/core/error/failure.dart';
import 'package:asar/core/usecase/usecase.dart';
import 'package:asar/features/events/domain/entities/order_entity.dart';
import 'package:asar/features/events/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateOrderUseCase implements UseCase<OrderEntity, CreateOrderParams> {
  final EventRepository eventRepository;

  CreateOrderUseCase(this.eventRepository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    return await eventRepository.createOrder(
      eventId: params.eventId,
      type: params.type,
      quantity: params.quantity,
      price: params.price,
      authToken: params.authToken,
    );
  }
}

class CreateOrderParams {
  final String authToken;
  final String eventId;
  final String type;
  final int quantity;
  final double price;

  CreateOrderParams({
    required this.authToken,
    required this.eventId,
    required this.type,
    required this.quantity,
    required this.price,
  });
}
