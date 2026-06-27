import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event.dart';
import '../../domain/usecases/get_events.dart';
import '../../data/repositories/events_repository_impl.dart';

// State
class EventsState {
  final List<Event> events;
  final bool isLoading;
  final String? error;

  const EventsState({
    this.events = const [],
    this.isLoading = false,
    this.error,
  });

  EventsState copyWith({
    List<Event>? events,
    bool? isLoading,
    String? error,
  }) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class EventsNotifier extends StateNotifier<EventsState> {
  final GetEvents _getEvents;

  EventsNotifier(this._getEvents) : super(const EventsState()) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final events = await _getEvents();
      state = state.copyWith(events: events, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Provider
final eventsControllerProvider =
    StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  final repo = EventsRepositoryImpl();
  final useCase = GetEvents(repo);
  return EventsNotifier(useCase);
});