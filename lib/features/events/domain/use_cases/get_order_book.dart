import 'package:asar/core/error/failure.dart';
import 'package:asar/core/usecase/usecase.dart';
import 'package:asar/features/events/domain/entities/order_book.dart';
import 'package:asar/features/events/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetOrderBookUseCase implements UseCase<OrderBook, String>{
  final EventRepository eventRepository;

  GetOrderBookUseCase({required this.eventRepository});
  @override
  Future<Either<Failure, OrderBook>> call(String params) async {
    return await eventRepository.getOrderBook(eventId: params);
  }

}