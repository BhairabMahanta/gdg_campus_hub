import '../../domain/entities/event.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_local_datasource.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsLocalDataSource _dataSource;

  EventsRepositoryImpl({EventsLocalDataSource? dataSource})
      : _dataSource = dataSource ?? EventsLocalDataSource();

  @override
  Future<List<Event>> getEvents() async {
    return _dataSource.getEvents();
  }

  @override
  Future<Event> getEventById(String id) async {
    final events = await _dataSource.getEvents();
    return events.firstWhere((e) => e.id == id);
  }

  @override
  Future<List<Event>> getEventsByCategory(String category) async {
    final events = await _dataSource.getEvents();
    return events.where((e) => e.category == category).toList();
  }
}