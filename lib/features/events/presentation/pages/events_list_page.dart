import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/events_controller.dart';
import '../widgets/event_card.dart';

class EventsListPage extends ConsumerWidget {
  const EventsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(eventsControllerProvider.notifier).loadEvents(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state.events.isEmpty) {
            return const Center(child: Text('No events yet. Check back soon!'));
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(eventsControllerProvider.notifier).loadEvents(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.events.length,
              itemBuilder: (context, index) =>
                  EventCard(event: state.events[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/login'),
        child: const Icon(Icons.login),
      ),
    );
  }
}