import '../entities/event.dart';

abstract class EventsRepository {
  Future<List<Event>> getEvents();
  Future<Event> getEventById(String id);
  Future<List<Event>> getEventsByCategory(String category);
}