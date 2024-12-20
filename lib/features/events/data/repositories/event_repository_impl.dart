import 'package:asar/core/constants/constants.dart';
import 'package:asar/core/error/exception.dart';
import 'package:asar/core/error/failure.dart';
import 'package:asar/core/network/connection_checker.dart';
import 'package:asar/features/events/data/data_sources/event_data_source.dart';
import 'package:asar/features/events/data/models/order_model.dart';
import 'package:asar/features/events/domain/entities/event.dart';
import 'package:asar/features/events/domain/entities/order_book.dart';
import 'package:asar/features/events/domain/entities/order_entity.dart';
import 'package:asar/features/events/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDataSource eventDataSource;
  final ConnectionChecker connectionChecker;

  EventRepositoryImpl({required this.eventDataSource, required this.connectionChecker});

  @override
  Future<Either<Failure, List<Event>>> getAllEvents() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final events = await eventDataSource.getAllEvents();
      if (events == null) {
        return left(Failure('No events found'));
      }
      return right(events);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required String eventId,
    required String type,
    required int quantity,
    required double price,
    required String authToken,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final orderModel = OrderModel(
        eventId: eventId,
        type: type,
        quantity: quantity,
        price: price,
      );

      final placedOrderMode = await eventDataSource.createOrder(orderModel: orderModel, authToken: authToken);
      return right(placedOrderMode as OrderEntity);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, OrderBook>> getOrderBook({required String eventId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final orderBook = await eventDataSource.getOrderBook(eventId: eventId);
      return right(orderBook);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
