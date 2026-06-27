# Architecture Guide — GDG Campus Hub

This document explains every folder in the project, why it exists, what goes inside it,
and how everything connects. Read this before touching any code.

---

## The Big Picture

This project uses **Feature-First Clean Architecture**. Before explaining folders, here is
the core idea in one paragraph:

Most Flutter apps start by dumping everything into one or two files — widgets, API calls,
business logic, all tangled together. Clean architecture separates those concerns into
**three distinct layers** so that changing one thing (e.g. switching from mock data to a
real API) does not break everything else. Feature-first means each major area of the app
(events, auth, profile) gets its own self-contained mini-version of those three layers,
so contributors can work on one feature without understanding the whole codebase.

---

## Full Folder Map

```
campus_hub/
├── android/                  ← Auto-generated. Don't touch unless doing native Android work.
├── ios/                      ← Auto-generated. Don't touch unless doing native iOS work.
├── web/                      ← Auto-generated. Flutter web support files.
├── test/                     ← Unit and widget tests go here. Currently empty.
├── pubspec.yaml              ← Project manifest: dependencies, assets, fonts. MAINTAINER ONLY.
├── pubspec.lock              ← Auto-generated lock file. Never edit manually.
│
├── .github/                  ← GitHub-specific config. MAINTAINER ONLY.
│   ├── CODEOWNERS            ← Defines who must review changes to critical files.
│   ├── pull_request_template.md  ← Pre-fills the PR form for contributors.
│   └── ISSUE_TEMPLATE/
│       ├── feature_request.yml
│       ├── bug_report.yml
│       └── docs_improvement.yml
│
├── README.md                 ← Project overview and getting started guide.
├── ARCHITECTURE.md           ← This file.
├── CONTRIBUTING.md           ← How to contribute, branch rules, PR checklist.
├── SECURITY.md               ← Security guidelines for contributors.
│
└── lib/                      ← All Dart/Flutter source code lives here.
    ├── main.dart             ← Entry point. Sets up ProviderScope. Nothing else.
    ├── app.dart              ← MaterialApp.router: wires theme, router, Riverpod.
    │
    ├── core/                 ← Shared infrastructure. Used by ALL features.
    │   ├── routing/
    │   │   └── app_router.dart       ← All GoRouter route definitions.
    │   ├── theme/
    │   │   └── app_theme.dart        ← Light and dark ThemeData.
    │   ├── error/
    │   │   └── failures.dart         ← Shared error/failure types (ServerFailure, etc).
    │   └── utils/
    │       └── constants.dart        ← Global constants: API base URL, app name, etc.
    │
    └── features/             ← One folder per major feature of the app.
        ├── events/           ← PRIMARY feature. Start here as a contributor.
        │   ├── presentation/
        │   │   ├── pages/
        │   │   │   └── events_list_page.dart
        │   │   ├── widgets/
        │   │   │   └── event_card.dart
        │   │   └── controllers/
        │   │       └── events_controller.dart
        │   ├── domain/
        │   │   ├── entities/
        │   │   │   └── event.dart
        │   │   ├── usecases/
        │   │   │   └── get_events.dart
        │   │   └── repositories/
        │   │       └── events_repository.dart
        │   └── data/
        │       ├── datasources/
        │       │   └── events_local_datasource.dart
        │       ├── models/
        │       │   └── event_model.dart
        │       └── repositories/
        │           └── events_repository_impl.dart
        │
        ├── auth/             ← Authentication feature. Stubs only for now.
        │   └── presentation/
        │       └── pages/
        │           └── login_page.dart
        │
        └── profile/          ← User profile feature. Stubs only for now.
            └── presentation/
                └── pages/
                    └── profile_page.dart
```

---

## Why Three Layers Per Feature?

Every feature (events, auth, profile) has the same three sub-folders:
**presentation**, **domain**, and **data**. This is not arbitrary — each layer has a
strict rule about what it can and cannot import.

```
┌─────────────────────────────┐
│        presentation         │  ← Talks to: domain only
│  (UI, widgets, controllers) │
└──────────────┬──────────────┘
               │ calls use cases
┌──────────────▼──────────────┐
│           domain            │  ← Talks to: nobody (pure Dart)
│  (entities, usecases, repo  │
│       interfaces)           │
└──────────────┬──────────────┘
               │ implemented by
┌──────────────▼──────────────┐
│            data             │  ← Talks to: domain (implements interfaces)
│  (API, local storage, DTOs, │
│   repo implementations)     │
└─────────────────────────────┘
```

Data flows **downward only**. `presentation` calls `domain`. `data` implements `domain`.
`domain` never imports from `presentation` or `data` — this is the most important rule.

The benefit: if you want to replace the mock data source with a real API, you only change
`data/`. The `domain/` and `presentation/` layers do not care and do not change.

---

## Layer 1 — `presentation/`

**Why is it called "presentation"?**
Because this layer is responsible for *presenting* information to the user and *handling*
user input. It is everything the user can see and interact with.

**What goes inside it:**

```
presentation/
├── pages/        ← Full screens. One file per screen.
├── widgets/      ← Reusable UI pieces used by pages. Smaller than a full screen.
└── controllers/  ← State management. Riverpod Notifiers or BLoC Cubits.
```

### `pages/`

A **page** is a full screen that maps to a GoRouter route. When you navigate somewhere
in the app, you land on a page. Pages are `ConsumerWidget` (Riverpod) or `StatelessWidget`.

Rules for pages:
- A page should be mostly layout and composition — arranging widgets on screen.
- A page reads state from a controller via `ref.watch(...)`.
- A page should NOT make direct API calls or contain business logic.
- One file = one screen.

### `widgets/`

A **widget** is a reusable UI component used by one or more pages. Examples: a card that
displays one event, a loading spinner, a category chip. If you find yourself copy-pasting
the same widget code across two pages, extract it into `widgets/`.

Rules for widgets:
- Widgets receive data via constructor parameters — they do not fetch their own data.
- Keep widgets small and focused on one responsibility.
- A widget should never directly call a use case or repository.

### `controllers/`

A **controller** (Riverpod `StateNotifier` or `Notifier`) is the bridge between the UI
and the domain layer. It holds and manages the state for a page or feature.

Rules for controllers:
- Controllers call use cases from `domain/usecases/`.
- Controllers expose state (loading, data, error) that pages read via `ref.watch(...)`.
- Controllers never import directly from `data/` — they only know about `domain/`.
- One controller per major page or feature section.

**Why three sub-folders instead of putting everything in one `presentation/` folder?**
Because as the app grows, a single folder with 20+ files becomes impossible to navigate.
Separating pages, widgets, and controllers means a new contributor can open `pages/` and
immediately see all the screens, without scrolling past dozens of unrelated widget files.

---

## Layer 2 — `domain/`

The domain layer is the heart of the feature. It contains the business rules and data
models in **pure Dart** — no Flutter imports, no HTTP clients, no databases.

```
domain/
├── entities/      ← The core data models of this feature.
├── usecases/      ← One file per operation the app can perform.
└── repositories/  ← Interfaces (abstract classes) that define what data operations exist.
```

### `entities/`

An **entity** is the core data model for a feature. For events, it is the `Event` class.
Entities are plain Dart classes — no JSON serialization, no database annotations, no
Flutter imports. They represent the concept in its purest form.

Example: `Event` has an `id`, `title`, `description`, `date`, `location`, and `category`.
That is all. How that event is fetched from an API or stored locally is not the entity's
concern.

### `usecases/`

A **use case** represents one specific thing the app can do. `GetEvents` fetches all
events. `SearchEvents` searches events by keyword. `GetEventById` fetches a single event.

Each use case is a small class with a single `call()` method. This makes it easy to test,
easy to read, and easy to swap out.

Why not just call the repository directly from the controller? You can, for simple cases.
But use cases let you add business logic (filtering, sorting, validation) in one place
without scattering it across controllers.

### `repositories/`

A **repository interface** (abstract class in Dart) defines *what operations are
possible* without saying *how* they are implemented. `EventsRepository` declares
`getEvents()`, `getEventById()`, and `getEventsByCategory()` as abstract methods.

The actual implementation lives in `data/repositories/`. This separation is the key to
testability — in tests you can swap in a fake implementation without touching any
production code.

**Why does `domain/` have no Flutter imports?**
Because it should be possible to take the domain layer and use it in a command-line Dart
app, a server-side Dart app, or a Flutter app — with zero changes. It is framework-agnostic
by design.

---

## Layer 3 — `data/`

The data layer is where the app actually talks to the outside world — APIs, local storage,
databases. It implements the interfaces defined in `domain/`.

```
data/
├── datasources/   ← Classes that fetch raw data (HTTP, local DB, mock).
├── models/        ← DTOs: data transfer objects with JSON serialization.
└── repositories/  ← Concrete implementations of the domain repository interfaces.
```

### `datasources/`

A **data source** is a class responsible for one specific source of data. Examples:
`EventsLocalDataSource` (returns mock/hardcoded data), `EventsRemoteDataSource` (calls
a REST API using Dio).

A repository can have multiple data sources — one local, one remote — and decide which
to use based on connectivity or caching rules.

### `models/`

A **model** (also called DTO — Data Transfer Object) extends an entity and adds JSON
serialization. `EventModel` extends `Event` and adds `fromJson()` and `toJson()` methods.

Why not add `fromJson` to the entity itself? Because the entity belongs to `domain/` which
must stay pure Dart and framework-agnostic. JSON parsing is a data concern, not a business
concern. Keeping them separate means if the API changes its field names, you only update
the model — not the entity or any business logic.

### `repositories/`

The **repository implementation** is the concrete class that implements the abstract
interface from `domain/repositories/`. `EventsRepositoryImpl` implements
`EventsRepository` by calling a data source and returning entities.

---

## Why Three Features (`events/`, `auth/`, `profile/`)?

Each major capability of the app gets its own feature folder. This means:

- A contributor working on events never needs to open the auth folder.
- Two contributors can work on different features simultaneously without merge conflicts.
- If a feature is removed from the app, its entire folder is deleted — no surgery required.

`auth/` and `profile/` currently contain only `presentation/pages/` stubs. Their
`domain/` and `data/` layers are intentionally left as issues for contributors to implement.

---

## `core/` — Shared Infrastructure

`core/` is not a feature — it is shared infrastructure used by all features.

| File | Purpose |
|---|---|
| `core/routing/app_router.dart` | All GoRouter routes. Adding a new screen = adding a route here. |
| `core/theme/app_theme.dart` | Light and dark `ThemeData`. Colors, fonts, component themes. |
| `core/error/failures.dart` | Shared `Failure` types returned from repositories. |
| `core/utils/constants.dart` | Global constants: API base URL, app name, timeout durations. |

Only maintainers and advanced contributors should modify `core/`. Changes here affect
every feature simultaneously.

---

## How Data Flows — A Complete Example

Here is what happens when `EventsListPage` loads and displays a list of events:

```
1. EventsListPage (presentation/pages/)
   └── reads state from eventsControllerProvider via ref.watch()

2. EventsNotifier (presentation/controllers/)
   └── on init, calls GetEvents use case

3. GetEvents (domain/usecases/)
   └── calls EventsRepository.getEvents()

4. EventsRepository (domain/repositories/)
   └── is an abstract interface — the notifier does not know what implements it

5. EventsRepositoryImpl (data/repositories/)
   └── implements EventsRepository
   └── calls EventsLocalDataSource.getEvents()

6. EventsLocalDataSource (data/datasources/)
   └── returns a List<EventModel>

7. EventsRepositoryImpl
   └── returns the list upward as List<Event> (entity, not model)

8. GetEvents returns List<Event> to EventsNotifier

9. EventsNotifier updates state to EventsState(events: [...], isLoading: false)

10. EventsListPage rebuilds via ref.watch() and renders EventCard widgets
```

Notice: `presentation` never sees `EventModel` or `EventsLocalDataSource`. It only knows
about `Event` (entity) and `GetEvents` (use case). The data layer is completely hidden.

---

## Where to Start (By Experience Level)

### New to Flutter — touch only these files first

- `lib/features/events/presentation/pages/events_list_page.dart`
- `lib/features/events/presentation/widgets/event_card.dart`
- Look for GitHub issues labelled `good first issue`

### Comfortable with Flutter — go one layer deeper

- `lib/features/events/presentation/controllers/events_controller.dart`
- `lib/features/events/domain/usecases/`
- Look for GitHub issues labelled `intermediate`

### Into architecture and patterns — go all the way

- `lib/features/events/data/` — swap mock for real API
- `lib/features/auth/` — implement full auth feature end-to-end
- `lib/core/` — improve DI, routing, error handling
- Look for GitHub issues labelled `advanced`

---

## Rules Summary

| Rule | Why it exists |
|---|---|
| `domain/` has zero Flutter imports | Keeps business logic framework-agnostic and testable |
| `presentation/` never imports from `data/` | Enforces one-way dependency flow |
| One page = one file in `pages/` | Easy to find, easy to navigate |
| Widgets receive data via constructor, not by fetching it themselves | Keeps widgets reusable and stateless |
| Controllers only call use cases, never data sources directly | Maintains layer separation |
| `core/` is maintainer-only | Prevents breaking changes across all features |
| Entity ≠ Model (no JSON in entities) | Separates business concepts from transport concerns |
