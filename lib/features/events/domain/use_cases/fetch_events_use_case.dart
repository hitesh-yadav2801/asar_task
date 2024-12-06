import 'package:asar/core/error/failure.dart';
import 'package:asar/core/usecase/usecase.dart';
import 'package:asar/features/events/domain/entities/event.dart';
import 'package:asar/features/events/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchEventsUseCase implements UseCase<List<Event>, NoParams> {
  final EventRepository eventRepository;

  FetchEventsUseCase({required this.eventRepository});

  @override
  Future<Either<Failure, List<Event>>> call(NoParams params)async {
    return await eventRepository.getAllEvents();
  }
}
