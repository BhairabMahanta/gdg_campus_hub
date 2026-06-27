# Architecture

This project uses **Feature-First Clean Architecture**. Each feature (events, auth, profile) is
self-contained and split into three layers: `presentation`, `domain`, and `data`.

## Folder Map
lib/
main.dart ← app entry point, sets up ProviderScope
app.dart ← MaterialApp.router, theme, GoRouter config

core/
routing/app_router.dart ← all GoRouter routes live here
theme/app_theme.dart ← light/dark ThemeData
error/failures.dart ← shared error/failure types
utils/constants.dart ← global constants (API URL, etc.)

features/
events/ ← PRIMARY teaching feature (start here)
presentation/
pages/events_list_page.dart ← main UI screen (START HERE)
widgets/event_card.dart ← reusable UI pieces
controllers/events_controller.dart ← Riverpod state notifier
domain/
entities/event.dart ← pure Dart model, no Flutter
usecases/get_events.dart ← business logic
repositories/events_repository.dart ← interface (abstract class)
data/
datasources/events_local_datasource.dart ← mock data (swap for API)
models/event_model.dart ← JSON serialization
repositories/events_repository_impl.dart ← implements interface

auth/ ← FUTURE WORK (stubs only)
presentation/pages/login_page.dart
profile/ ← FUTURE WORK (stubs only)
presentation/pages/profile_page.dart

text

## Layer Rules

| Layer | What goes here | Flutter imports? |
|---|---|---|
| `presentation` | Widgets, pages, Riverpod controllers | Yes |
| `domain` | Entities, use cases, repository interfaces | No — pure Dart only |
| `data` | API clients, local storage, DTOs, repo implementations | Yes |

**Key rule:** `domain` must never import from `data` or `presentation`.
Data flows one way: `data` → `domain` → `presentation`.

## Where to Start (By Experience Level)

### 🟢 New to Flutter
- Open `lib/features/events/presentation/pages/events_list_page.dart`
- Open `lib/features/events/presentation/widgets/event_card.dart`
- Look for `good first issue` GitHub issues
- Don't touch `domain/` or `data/` yet

### 🟡 Comfortable with Flutter
- Look at `presentation/controllers/events_controller.dart` to understand Riverpod
- Implement a filter by category feature end-to-end (controller → UI)
- Look for `intermediate` GitHub issues

### 🔴 Into architecture & patterns
- Explore `domain/` and `data/` for events
- Help implement `auth/` and `profile/` domain + data layers
- Improve dependency injection with `get_it`
CONTRIBUTING.md
text
# Contributing to GDG Campus Hub

Welcome! You're here to learn Flutter — this repo is structured to make that easy.

## Before You Start

1. Install Flutter SDK and run `flutter doctor` (should be mostly green)
2. Fork this repo → clone your fork → open in VS Code or Android Studio
3. Run `flutter pub get` then `flutter run` to verify it works

## Picking an Issue

- Browse [Issues](../../issues)
- Look for `good first issue` if this is your first contribution
- Comment on an issue to claim it — don't open a PR without claiming first
- Each issue says **which folder to work in** and **what Flutter skill you'll practice**

## Folder Rules (read this)

| Folder | Who should touch it |
|---|---|
| `lib/core/` | Maintainers / advanced contributors only |
| `features/*/presentation/pages` and `widgets/` | Beginners welcome |
| `features/*/presentation/controllers/` | Intermediate |
| `features/*/domain/` | Intermediate/advanced |
| `features/*/data/` | Intermediate/advanced |

If you're new: **only work inside `presentation/pages/` and `presentation/widgets/`** for your first PR.

## Branch Naming
feature/events-filter-by-category
bugfix/events-loading-spinner
docs/improve-architecture-md

text

## Workflow

```bash
git checkout dev
git pull origin dev
git checkout -b feature/your-issue-name
# make your changes
flutter analyze          # must pass with zero issues
git add .
git commit -m "feat: short description of what you did"
git push origin feature/your-issue-name
# open PR → target branch: dev
```

## PR Rules

- PRs must target `dev`, never `main`
- Fill the PR template (summary, linked issue, checklist)
- `flutter analyze` must pass — no warnings
- No API keys, `.env` files, or credentials in the PR
- At least one maintainer review required before merge

## Commit Messages

Use conventional commits:
- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation only
- `refactor:` code change that doesn't add a feature or fix a bug
- `style:` formatting
- `chore:` tooling, config