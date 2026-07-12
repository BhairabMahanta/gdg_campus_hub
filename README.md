# 🏛️ GDG Campus Hub

> An open-source Flutter project — learn Flutter and real app architecture by contributing to an actual app.

[![Issues](https://img.shields.io/github/issues/BhairabMahanta/gdg_campus_hub)](https://github.com/BhairabMahanta/gdg_campus_hub/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](./CONTRIBUTING.md)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)](https://flutter.dev)

---

## Why This Project Exists

Hey — I built this the way I wish someone had built something for me when I was learning Flutter.

Most tutorials teach you syntax. They don't teach you the *feel* of a real codebase — where things live, why they live there, and what happens when you poke one part of it. That feel only comes from working inside a real, structured app. That is exactly what this repo is for.

You are not here to memorize widgets. You are here to build the instinct of: "I need to change X, so I know Y will be affected, and Z will stay untouched." That instinct is what separates someone who can copy a tutorial from someone who can actually ship an app.

---

## What You Will Learn

| Skill | Where in the project |
|---|---|
| Widget composition & layout | `presentation/widgets/` |
| State management with Riverpod | `presentation/controllers/` |
| Page navigation with GoRouter | `core/routing/app_router.dart` |
| Clean Architecture (3-layer pattern) | All of `features/` |
| Dependency injection with GetIt | `core/di/` |
| Secure storage for auth tokens | `features/auth/data/` |
| HTTP calls with Dio | `features/events/data/datasources/` |

---

## Architecture at a Glance

Every feature in this app is split into three layers. Read [ARCHITECTURE.md](./ARCHITECTURE.md) fully before writing any code — it explains not just what each folder is, but the intuition for why it's shaped this way.

```
presentation/ -> What the user sees. Widgets, pages, state controllers.
domain/       -> The rules. Entities, use cases, repository interfaces. Pure Dart.
data/         -> The work. API calls, local storage, repository implementations.
```

---

## Getting Started

```bash
git clone https://github.com/BhairabMahanta/gdg_campus_hub.git
cd gdg_campus_hub
flutter pub get
flutter run
```

Supports: Android, iOS, Web. Run `flutter doctor` first if this is your first Flutter project.

---

## Tech Stack

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management |
| `go_router` | Navigation / deep linking |
| `dio` | HTTP client |
| `flutter_secure_storage` | JWT token storage |
| `get_it` | Dependency injection |
| `freezed` | Immutable data classes |

---

## Pick an Issue

Every issue is labeled by difficulty so you know what you are getting into before you start:

- `good first issue` — you only need basic Flutter widget knowledge
- `intermediate` — requires understanding state management or one architecture layer
- `advanced` — touches multiple layers or introduces a new pattern

[Browse open issues](https://github.com/BhairabMahanta/gdg_campus_hub/issues)

First time contributing? Start with Issue #1, and read [CONTRIBUTING.md](./CONTRIBUTING.md) before touching code.

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for the branch strategy, git workflow, PR rules, and a full walkthrough of your first contribution.

## Security

See [SECURITY.md](./SECURITY.md). Never commit API keys, tokens, or `.env` files.
