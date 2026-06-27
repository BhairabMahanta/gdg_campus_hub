import '../entities/event.dart';
import '../repositories/events_repository.dart';

class GetEvents {
  final EventsRepository repository;

  GetEvents(this.repository);

  Future<List<Event>> call() async {
    return repository.getEvents();
  }
}