import 'package:asar/core/error/failure.dart';
import 'package:asar/features/events/domain/entities/event.dart';
import 'package:asar/features/events/domain/entities/order_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class EventRepository {
  Future<Either<Failure, List<Event>>> getAllEvents();

  Future<Either<Failure, OrderEntity>> createOrder({
    required String eventId,
    required String type,
    required int quantity,
    required double price,
    required String authToken,
  });
}
