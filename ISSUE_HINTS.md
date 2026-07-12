This file exists so nobody gets stuck for an hour on something I could've pointed them toward in one sentence. These are hints, not solutions — you still have to write the code and understand why it works.

# New Feature Issues — Campus Learning + Event Hub Expansion

This app is not just an "events list" — it's three pillars: **Concept Explorer**, **Event Aggregator**, and **Study Rooms & Resources**. Right now the app launches directly into the events list with no home screen tying these together. That's the first thing we fix.

---

## Scope Boundary — What We ARE and ARE NOT Building Right Now

Read this before assigning or picking up any issue below, so nobody scope-creeps into something out of range for a first pass.

**We ARE building:**
- A home screen that clearly presents three sections: Events, Concepts, Study Rooms
- Static, hardcoded topic content for Concept Explorer (DSA/COA/OS/Networks) — no backend, no CMS
- Local flashcards and quizzes with hardcoded question sets — no scoring persistence yet
- Event filters (date, type, club) using the existing mock event data
- A basic subscription preference screen (branch/year) stored locally — no real push notifications yet
- A resource list page with hardcoded links (YouTube, notes, question papers) tagged by course + difficulty
- A study room view with a countdown timer and a static list of suggested questions

**We ARE NOT building (yet — future issues once this is solid):**
- Any real backend/API for events, concepts, or resources
- Real push notifications for subscriptions
- User accounts tied to real branch/year data (auth feature is still separate and stubbed)
- File upload/hosting for actual question paper PDFs — we link out to existing sources for now
- Any actual quiz score tracking across sessions (no local DB yet)

If your issue starts needing something from the "NOT building" list, stop, comment on the issue, and we'll scope a follow-up instead of bloating the PR.

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
ISSUE 11- issue 15 doesnt Exist on the repository!! If you've reached this place, congratulations! you can create this as your own issues and you will also learn how to create a gihub issue! and you can comment and tag me to assign you the issue!

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




## Section A — Foundation: Home Screen and Navigation

### Issue #16 — Add HomePage with bottom navigation between Events, Concepts, and Study Rooms
`good first issue` `core` `presentation`

**Description:**
The app currently launches directly into `EventsListPage` with no home screen. Create a new `HomePage` that becomes the initial route (`/`), containing a `BottomNavigationBar` (or `NavigationBar` for Material 3) with three tabs: Events, Concepts, Study Rooms. Each tab should show its respective page. Events tab shows the existing `EventsListPage`. Concepts and Study Rooms tabs can show a placeholder page for now (built out in later issues).

**Hint for contributor:**
- Use `IndexedStack` inside `HomePage` to preserve each tab's state when switching, instead of rebuilding the page every time.
- Update `app_router.dart` so `/` renders `HomePage`, and move the old events-list route to a nested path or keep it as the default tab inside `HomePage`.
- Keep this issue focused on navigation shell only — don't build out Concepts or Study Rooms content here, that's separate issues.

---

### Issue #17 — Restructure app_router.dart with nested route groups per section
`intermediate` `core` `advanced`

**Description:**
As we add Concepts and Study Rooms, routes will multiply. Refactor `app_router.dart` to group routes logically — e.g., all event routes under `/events/*`, all concept routes under `/concepts/*`. Use GoRouter's nested `routes` property inside a parent `GoRoute` instead of one long flat list.

**Hint for contributor:**
- Look at GoRouter's `routes: [...]` nesting — a parent route can have child routes that inherit its path prefix.
- This issue should be done AFTER Issue #16 lands, since it depends on the new HomePage route shape.
- Test that deep links still work — e.g., navigating directly to `/events/1` should still open that specific event detail page.

---

## Section B — Concept Explorer

### Issue #18 — Create Concept Explorer feature folder skeleton
`good first issue` `feature:concepts` `core`

**Description:**
Set up the folder structure for the new `concepts` feature following the same 3-layer pattern as `events`. Create empty/stub files: `domain/entities/concept_topic.dart`, `domain/repositories/concepts_repository.dart`, `data/datasources/concepts_local_datasource.dart`, `data/repositories/concepts_repository_impl.dart`, `presentation/pages/concepts_list_page.dart`. No real logic needed yet — just wire the skeleton so later issues have somewhere to add code.

**Hint for contributor:**
- Copy the shape of the `events` feature folder exactly — same layer names, same responsibilities per file.
- `ConceptTopic` entity needs at minimum: `id`, `title`, `subject` (DSA/COA/OS/Networks), `description`.
- This is a scaffolding issue — the goal is clean folders, not working features.

---

### Issue #19 — Build Topic List page (DSA / COA / OS / Networks)
`good first issue` `feature:concepts` `presentation`

**Description:**
Build `ConceptsListPage` showing a grid or list of subject cards: Data Structures & Algorithms, Computer Organization & Architecture, Operating Systems, Computer Networks. Tapping a subject navigates to a list of topics within that subject (e.g., tapping DSA shows "Sorting Algorithms," "Trees," "Graphs").

**Hint for contributor:**
- Use a hardcoded `List<Map>` or a small local JSON file for now — no need for a real datasource call yet if Issue #18 isn't merged.
- A `GridView.count` with 2 columns works well for subject cards on mobile.
- Each subject card should show an icon (use Material icons — no need for custom illustrations yet).

---

### Issue #20 — Build Topic Detail page with static explanation content
`intermediate` `feature:concepts` `presentation`

**Description:**
Build `TopicDetailPage` that displays the actual explanation content for a single topic (e.g., "Binary Search Trees"). Content should include a title, a paragraph explanation, and a placeholder section for a visual diagram (built in later issues).

**Hint for contributor:**
- Structure content as a simple Dart class/list of "sections" (heading + body text) so it's easy to extend later without rewriting the whole page.
- Use `SingleChildScrollView` since topic content will likely be long.
- Don't hardcode content directly into the widget tree — keep content data separate from the widget that renders it, even without a real datasource yet.

---

### Issue #21 — Build a memory hierarchy visual diagram widget
`intermediate` `feature:concepts` `presentation`

**Description:**
For the Computer Organization & Architecture topic pages, build a visual widget showing the memory hierarchy pyramid (Registers → Cache → RAM → SSD/HDD) with relative size/speed labels. This should be a reusable widget any COA topic page can embed.

**Hint for contributor:**
- Start simple: stacked `Container`s of decreasing width representing each memory tier, labeled with `Text` — you don't need `CustomPainter` for a first version.
- Use `Column` with different-width `Container`s (via `FractionallySizedBox`) to create the pyramid shape without custom painting.
- Add a short caption under each tier explaining speed vs size trade-off — that's the actual teaching value here.

---

### Issue #22 — Build a process scheduling timeline (Gantt-style) widget
`advanced` `feature:concepts` `presentation`

**Description:**
For Operating Systems topics on CPU scheduling (FCFS, SJF, Round Robin), build a widget that renders a horizontal Gantt-chart-style timeline showing which process runs during which time slice.

**Hint for contributor:**
- Model input as a simple list of `{processName, startTime, duration}` and render each as a colored `Container` inside a `Row`, sized proportionally using `Expanded` with `flex`.
- This is genuinely one of the harder visual widgets in the app — it's fine to start with just one scheduling algorithm (FCFS) hardcoded, and expand later.
- Consider using `CustomPaint` only once the basic `Row`-based version works and you want pixel-perfect timing labels.

---

### Issue #23 — Build a flip-animation Flashcard widget
`intermediate` `feature:concepts` `presentation`

**Description:**
Build a `Flashcard` widget showing a question on the front and answer on the back, with a flip animation triggered by tapping the card. Should be reusable across any topic's flashcard set.

**Hint for contributor:**
- Use `AnimatedSwitcher` with a custom `transitionBuilder` for a simple flip-like effect, or `Transform` with a `Matrix4` rotation on the Y-axis for a true 3D flip.
- Keep flashcard data as a simple list of `{question, answer}` pairs per topic — no persistence needed yet.
- Add a counter showing "Card 3 of 10" so users know their progress through a deck.

---

### Issue #24 — Build a Quiz page with instant scoring
`intermediate` `feature:concepts` `presentation`

**Description:**
Build a `QuizPage` that shows one multiple-choice question at a time for a topic, tracks the user's score as they answer, and shows a results summary at the end.

**Hint for contributor:**
- Use a simple `StateNotifier` (same pattern as `EventsNotifier`) to track current question index and running score — this is a great use case for practicing Riverpod state beyond just the events feature.
- Model each question as `{questionText, List<options>, correctOptionIndex}`.
- Disable answer buttons after the user picks one, and visually highlight correct/incorrect before moving to the next question — instant feedback matters more than a fancy UI here.

---

## Section C — Event Aggregator Enhancements

### Issue #25 — Add date range filter to Events list
`intermediate` `feature:events` `presentation`

**Description:**
Add the ability to filter events by date range (e.g., "This Week," "This Month," "All"). This is separate from the existing category filter chips — both filters should work together.

**Hint for contributor:**
- Add a `selectedDateRange` field to `EventsState`, similar to how `selectedCategory` already works.
- Compute date boundaries using `DateTime.now()` and simple `.isBefore()`/`.isAfter()` comparisons — no date-picker package needed for preset ranges.
- Combine both filters in one method so category AND date range apply simultaneously, not as two separate passes that overwrite each other.

---

### Issue #26 — Add club/society filter to Events list
`good first issue` `feature:events` `presentation`

**Description:**
Currently events are only categorized as Workshop/GDG/Hackathon. Add a `club` field to the `Event` entity (e.g., "GDG," "IEEE," "Coding Club") and a filter chip row so users can filter events by which club/society is hosting them.

**Hint for contributor:**
- Add `club` to `Event` entity, `EventModel`, and the mock data in `EventsLocalDataSource` first — the interface change always comes before the UI.
- This filter should sit alongside the existing category chips, not replace them — consider a second row or a dropdown so the UI doesn't get too crowded.
- Update the mock event data with realistic club names so the filter has something meaningful to show.

---

### Issue #27 — Build branch/year subscription preferences screen
`advanced` `feature:events` `presentation` `data`

**Description:**
Build a settings-style page where a user selects their branch (CS, ECE, Mech, etc.) and year (1st-4th), stored locally on the device. Once set, the Events list should only show events tagged as relevant to that branch/year (or events tagged "All").

**Hint for contributor:**
- Use `shared_preferences` (not secure storage — this isn't sensitive data) to persist the branch/year choice locally.
- Add a `targetBranch` and `targetYear` field to the `Event` entity, defaulting to "All" for events relevant to everyone.
- This is a good one to pair with a use case: create a `FilterEventsByPreference` use case in `domain/usecases/` rather than filtering directly in the controller.

---

## Section D — Study Rooms & Resources

### Issue #28 — Create Study Rooms & Resources feature folder skeleton
`good first issue` `feature:resources` `core`

**Description:**
Set up the folder structure for a new `resources` feature, same 3-layer pattern as `events` and `concepts`. Create stub files for a `Resource` entity (title, type — video/notes/paper, course, difficulty, url) and the matching repository/datasource stubs.

**Hint for contributor:**
- `Resource` entity fields: `id`, `title`, `type` (enum: video, notes, questionPaper), `course`, `difficulty` (enum: beginner, intermediate, advanced), `url`.
- Follow the exact same folder shape as Issue #18 did for concepts — consistency across features matters more than any small variation.

---

### Issue #29 — Build Resource List page tagged by course and difficulty
`intermediate` `feature:resources` `presentation`

**Description:**
Build a page listing curated resources (YouTube playlists, notes, problem sets) with filter chips for course and difficulty level, similar in spirit to the Events filter chips.

**Hint for contributor:**
- Reuse the exact filter chip pattern from Issue #2/#26 in the events feature — same `FilterChip` + Notifier approach, just filtering `Resource` instead of `Event`.
- Tapping a video-type resource should open the URL externally — use the `url_launcher` package rather than trying to embed a video player.
- Mock at least 10-15 realistic resources across different courses so the filtering actually looks meaningful when demoed.

---

### Issue #30 — Build a Study Room view with topic picker, timer, and suggested questions
`advanced` `feature:resources` `presentation`

**Description:**
Build a "Study Room" page: user picks a topic, starts a countdown/focus timer (like a simple Pomodoro), and sees a static list of suggested practice questions for that topic while the timer runs.

**Hint for contributor:**
- Use Dart's `Timer.periodic` combined with a Riverpod `StateNotifier` to manage countdown state — don't manage timers directly inside widget `setState`, they won't survive widget rebuilds cleanly.
- Suggested questions can be hardcoded per topic for now, tied to the same topic IDs used in Concept Explorer if that feature has landed — check with a maintainer before assuming that dependency.
- Add a simple "session complete" state when the timer hits zero, with a satisfying visual/sound cue — small UX detail, big feel difference.

---

### Issue #31 — Build a Question Papers listing page
`intermediate` `feature:resources` `presentation` `data`

**Description:**
Build a page listing previous exam question papers, tagged by course and year, linking out to existing hosted PDFs (Google Drive links, department site links, etc. — we are not hosting files ourselves yet).

**Hint for contributor:**
- Treat question papers as just another `Resource` type (`type: questionPaper`) rather than building a whole separate model — reuse Issue #28's entity if it's landed.
- Group the list visually by course first, then by year within each course, using `ListView` with section headers rather than one long flat list.
- Since this app is BTech-focused right now but designed to extend to other branches later, keep the `course` field as a free string rather than a hardcoded enum — that keeps the door open without needing a rewrite later.
