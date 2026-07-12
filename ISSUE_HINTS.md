# Issue Hints — GDG Campus Hub

This file exists so nobody gets stuck for an hour on something I could've pointed them toward in one sentence. These are hints, not solutions — you still have to write the code and understand why it works.

---

## Issue #1 — Create EventCard hover/tap highlight effect
`good first issue`

- Wrap the content inside `Card` with an `InkWell(onTap: () {})`.
- Add `clipBehavior: Clip.antiAlias` to the `Card` itself, or the ripple will spill outside the rounded corners.
- Later, this `onTap` should navigate to the event detail page — for now, an empty callback is fine.

---

## Issue #2 — Add category filter chips to EventsListPage
`good first issue`

- Add a `selectedCategory` and `filteredEvents` field to `EventsState`.
- Add a `filterByCategory(String category)` method to your Notifier that filters `state.events` and updates `filteredEvents`.
- Render a horizontal `ListView` of `FilterChip` widgets above your events list, with `selected: state.selectedCategory == category`.
- Remember: filtering should happen on the already-fetched `events` list in memory — don't re-fetch from the datasource every time someone taps a chip.

---

## Issue #3 — Add light/dark mode toggle to AppBar
`good first issue`

- Create a `StateProvider<ThemeMode>` in `core/theme/theme_controller.dart`, default `ThemeMode.light`.
- In `app.dart`, watch that provider and pass it into `MaterialApp.router(themeMode: ...)`.
- Add an `IconButton` in your AppBar that flips the value using `ref.read(themeModeProvider.notifier).state = ...`.
- Use `ref.watch` to know what icon to show, `ref.read` inside the `onPressed` to change it — mixing these up is the most common beginner mistake here.

---

## Issue #4 — Implement EventDetailPage with GoRouter navigation
`intermediate`

- Add a new route in `app_router.dart`: `GoRoute(path: '/events/:id', ...)`.
- Read the path parameter with `state.pathParameters['id']!` inside the route's builder.
- Don't re-fetch the event from network — find it inside the already-loaded `eventsControllerProvider` state using `.where((e) => e.id == id).firstOrNull`.
- For extra polish, wrap a shared element (like the category `Chip`) in a `Hero` widget with a matching `tag` on both `EventCard` and `EventDetailPage`.

---

## Issue #5 — Build LoginPage form with validation
`intermediate`

- Use a `GlobalKey<FormState>` on a `Form` widget wrapping your fields.
- Each `TextFormField` needs a `validator` returning `null` when valid, or an error string when invalid.
- Call `_formKey.currentState!.validate()` before submitting — it runs every validator and returns `false` if any fails.
- Use an `AsyncNotifier<void>` for the submit state so you get loading/error/data for free, instead of manual booleans.
- Dispose your `TextEditingController`s in `dispose()` — this is a very common memory leak beginners introduce.

---

## Issue #6 — Add EventsRepository interface method for search by keyword
`intermediate`

- Add `Future<List<Event>> searchEvents(String query);` to the abstract `EventsRepository` class first — the interface always changes before the implementation.
- Implement it in `EventsRepositoryImpl` by filtering the datasource's events using `.toLowerCase().contains(...)` across title, description, and location.
- Create a new `SearchEvents` use case in `domain/usecases/` — same pattern as `GetEvents`, just takes a `String query` parameter in its `call()` method.
- Don't call the repository directly from your controller — always go through the use case. That's the whole point of the domain layer.

---

## Issue #7 — Replace mock datasource with real Dio HTTP call
`intermediate`

- Create `EventsRemoteDataSource` in `data/datasources/`. Inject `Dio` through the constructor — never instantiate `Dio()` inside the class body, it makes testing impossible.
- Wrap your `dio.get(url)` call in try/catch, but catch `DioException` specifically, not a generic `Exception` — Dio gives you useful info like status codes in `DioException`.
- Map the JSON response (`response.data as List`) into `EventModel.fromJson(item)` for each entry.
- Update `EventsRepositoryImpl`'s constructor to accept either datasource so you can swap mock and real without touching `domain/` at all — that's the entire reason this layer separation exists.

---

## Issue #8 — Set up GetIt for dependency injection across features
`advanced`

- Create `lib/core/di/service_locator.dart` with a single `GetIt` instance, usually named `sl` (service locator).
- Register `EventsLocalDataSource` and `EventsRepositoryImpl` as `registerLazySingleton` — they should only be created once and reused.
- Register `GetEvents` and `SearchEvents` as `registerFactory` — a fresh instance per use makes sense for use cases since they hold no state.
- Call `setupServiceLocator()` once, in `main.dart`, before `runApp()` — if you forget this, every `sl<Something>()` call will throw at runtime.
- Update `eventsControllerProvider` to pull dependencies via `sl<EventsRepository>()` instead of constructing `EventsRepositoryImpl()` directly.

---

## Issue #9 — Add architecture diagram to ARCHITECTURE.md
`good first issue`

- Use a Mermaid `flowchart TD` block — GitHub renders these natively in markdown, no image needed.
- Show the flow: page to controller to usecase to repository interface to repository impl to datasource, and back up.
- Use different node colors per layer (presentation, domain, data) so it's visually obvious which files belong together.
- This issue is a great one to pair with reading the "Data Flow" section already in `ARCHITECTURE.md` — the diagram should visually match that written walkthrough exactly.

---

## Issue #10 — Implement flutter_secure_storage for JWT token persistence
`intermediate`

- Create `AuthLocalDataSource` in `features/auth/data/datasources/` using `const storage = FlutterSecureStorage();` — the const constructor is safe to reuse.
- Store the token under a clear key like `'jwt_token'`, with `write`, `read`, and `delete` methods.
- Never use `SharedPreferences` for tokens — on Android it writes to a plaintext XML file that any rooted device or malicious app with storage permission can read.
- Call your `write` method right after a successful login, and your `delete` method on logout — think through the whole lifecycle, not just the write.

---

## Issue #11 — Add a search bar to EventsListPage
`good first issue`

- Add a `TextField` above the filter chips row. Use `onChanged` to call a new `searchEvents(String query)` method on your Notifier.
- Add a `searchQuery` field to `EventsState`. Your filter logic needs to apply BOTH the selected category AND the search query at the same time.
- When the search box is cleared, revert to showing the category-filtered list, not the full unfiltered list.

---

## Issue #12 — Build ProfilePage UI
`good first issue`

- Use `CircleAvatar` with `Icon(Icons.person)` as a placeholder profile picture, no real data needed yet.
- Use `ListTile` widgets to display name, email, and role — this is a pure UI task, no state management required.
- Add a "Logout" button using `FilledButton.tonal` at the bottom, navigating to `/login` with `context.go('/login')`.

---

## Issue #13 — Add shimmer loading placeholder to EventCard
`intermediate`

- Add the `shimmer` package to `pubspec.yaml`.
- Wrap a grey `Container` shaped like your `EventCard` in `Shimmer.fromColors(baseColor: ..., highlightColor: ...)`.
- Extract this into a new widget, `EventCardSkeleton`, in `presentation/widgets/` — keep it visually similar in height/shape to the real card.
- When `state.isLoading` is true, render a `ListView` of three `EventCardSkeleton`s instead of a spinning `CircularProgressIndicator`.

---

## Issue #14 — Implement AuthRepository interface end-to-end
`advanced`

- Create `domain/entities/user.dart` — pure Dart, just `id`, `name`, `email`, no JSON logic.
- Create `domain/repositories/auth_repository.dart` as an abstract class with `login(email, password)` and `logout()` method signatures.
- Create `data/repositories/auth_repository_impl.dart` that returns a mock `User` after a `Future.delayed`, simulating network latency.
- Wire this into your `LoginNotifier` in `login_page.dart` so a successful login actually returns a real `User` object, not just `void`.

---

## Issue #15 — Add pull-to-refresh snackbar feedback
`good first issue`

- Inside `RefreshIndicator.onRefresh`, `await notifier.loadEvents()` and then check `state.error`.
- Show `ScaffoldMessenger.of(context).showSnackBar(...)` — "Events updated!" on success, "Failed to refresh" on error.
- `onRefresh` must return a `Future` and complete it properly, or the pull-to-refresh spinner will spin forever instead of snapping back.
