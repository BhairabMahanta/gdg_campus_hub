import '../models/event_model.dart';

// Mock in-memory data source — replace with API/Firestore later
class EventsLocalDataSource {
  Future<List<EventModel>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network
    return [
      EventModel(
        id: '1',
        title: 'Flutter Workshop — State Management',
        description: 'Learn Riverpod from scratch with a live coding session.',
        date: DateTime(2026, 7, 10),
        location: 'Room 201, CS Block',
        category: 'Workshop',
      ),
      EventModel(
        id: '2',
        title: 'GDG Info Session',
        description: 'Meet the team, see what GDG does, and how to join.',
        date: DateTime(2026, 7, 15),
        location: 'Seminar Hall',
        category: 'GDG',
      ),
      EventModel(
        id: '3',
        title: 'Hackathon Prep Bootcamp',
        description: '3-hour sprint: idea → design → prototype.',
        date: DateTime(2026, 7, 20),
        location: 'Lab 3, CS Block',
        category: 'Hackathon',
      ),
    ];
  }
}