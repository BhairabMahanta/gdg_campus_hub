# Contributing to GDG Campus Hub

Welcome. I built this repository as a Flutter learning project first, and an app second. That means every contribution should help you (or someone else) understand Flutter structure, state management, routing, architecture, and real team workflow — not just add a random feature and move on.

I want you to leave this project a better Flutter developer than when you found it. Here's how.

---

## Before You Start Anything

1. Read `README.md` for project setup.
2. Read `ARCHITECTURE.md` to understand where code belongs — this is not optional, most beginner mistakes come from skipping this.
3. Check open issues and pick one that matches your skill level.
4. Comment on the issue before starting, so two people don't accidentally build the same thing.

---

## Branch Strategy

This project uses three levels of branches:

```
main        -> stable/public branch
dev         -> active development branch
feature/*   -> temporary work branches
```

### main

This is the stable public branch. Only reviewed, cleaned, ready code reaches here. Contributors should never open pull requests directly to `main` — it is protected for safety.

### dev

This is the working branch. Most pull requests target `dev`. New features, fixes, and doc updates get merged here first. Once `dev` is stable, I create a PR from `dev` into `main`.

### feature/*

Temporary branches for one task at a time. Every contributor, including me, works in a feature branch. Examples:

```
feature/events-filter-chip
feature/login-form-ui
docs/improve-architecture-guide
bugfix/router-path-fix
```

### Why this process exists

This protects the public branch from accidental mistakes, and lets multiple people work at once without constantly breaking what's shown publicly on `main`.

---

## Contribution Flow

### For contributors

```
fork repo -> clone fork -> checkout dev -> create feature branch -> code -> push -> PR to dev
```

### For maintainers

```
feature/* -> PR to dev -> review/merge -> later PR from dev -> main
```

---

## Your First PR — Complete Walkthrough

I'm walking you through Issue #1 (EventCard tap highlight) start to finish. Do this exactly, once, so the workflow becomes muscle memory.

### Step 1 — Fork and clone

Click Fork on GitHub, then:

```bash
git clone https://github.com/YOUR_USERNAME/gdg_campus_hub.git
cd gdg_campus_hub
git remote add upstream https://github.com/BhairabMahanta/gdg_campus_hub.git
```

### Step 2 — Get the latest dev branch

```bash
git checkout dev
git pull upstream dev
```

### Step 3 — Create your feature branch

```bash
git checkout -b feature/eventcard-tap-highlight
```

### Step 4 — Make the change

Open `lib/features/events/presentation/widgets/event_card.dart`.
Add `clipBehavior: Clip.antiAlias` to the `Card` widget.
Wrap the inner `Padding` with an `InkWell(onTap: () {})`.

### Step 5 — Check your work

```bash
flutter analyze
flutter run
```

Tap a card. You should see a ripple effect.

### Step 6 — Commit

```bash
git add lib/features/events/presentation/widgets/event_card.dart
git commit -m "feat: add InkWell tap highlight to EventCard"
```

### Step 7 — Push and open a PR

```bash
git push -u origin feature/eventcard-tap-highlight
```

Go to GitHub, your fork, Compare & pull request. Set the base branch to `dev`, not `main`. Write one sentence about what changed and why.

That's it. Wait for review, respond to feedback, and merge.

---

## Step-by-Step Git Workflow (General)

### 1. Get the latest code

```bash
git checkout dev
git pull origin dev
```

### 2. Create your branch

```bash
git checkout -b feature/short-description
```

### 3. Make your changes

Keep changes focused on one task. Don't mix unrelated fixes into one PR.

### 4. Run checks before committing

```bash
flutter analyze
flutter test
```

If no tests exist yet, `flutter test` may do very little — that's fine. `flutter analyze` must pass with zero errors.

### 5. Commit your work

```bash
git add -A
git commit -m "feat: add event category filter"
```

### 6. Push your branch

```bash
git push -u origin feature/short-description
```

### 7. Open a pull request

Base branch: `dev`. Compare branch: your feature branch. Never target `main` unless I explicitly tell you to.

---

## Pull Request Rules

Every pull request should:

- target `dev`, not `main`
- solve one clearly scoped issue
- follow the project folder structure
- include a clear PR title and summary
- pass `flutter analyze`
- avoid committing secrets, tokens, or `.env` files

If your PR changes multiple layers (`presentation`, `domain`, `data`), explain why in the description.

---

## Folder Rules — Quick Reference

Read `ARCHITECTURE.md` for the full reasoning behind these. Quick guide:

| Folder | What belongs here | Who should touch it |
|---|---|---|
| `lib/core/` | Shared infrastructure: routing, theme, DI, constants | Maintainers / advanced contributors |
| `features/*/presentation/pages/` | Full app screens | Beginners welcome |
| `features/*/presentation/widgets/` | Reusable UI components | Beginners welcome |
| `features/*/presentation/controllers/` | Riverpod state management | Intermediate |
| `features/*/domain/` | Entities, use cases, repository interfaces | Intermediate / advanced |
| `features/*/data/` | API/local storage/models/repository implementations | Intermediate / advanced |
| `.github/` | Templates and repo automation config | Maintainers only |

### First-time contributor rule

If this is your first contribution, stay inside one of these:

- `lib/features/events/presentation/pages/`
- `lib/features/events/presentation/widgets/`
- Docs: `README.md`, `ARCHITECTURE.md`, `CONTRIBUTING.md`

Avoid `core/`, `domain/`, and `data/` until you've read `ARCHITECTURE.md` and understand the layer rules.

---

## Commit Message Style

Use conventional commit prefixes:

- `feat:` a new feature
- `fix:` a bug fix
- `docs:` documentation only
- `refactor:` code cleanup with no behavior change
- `chore:` config/tooling/setup work
- `style:` formatting or UI polish with no logic change

Examples:

```
feat: add event category filter
fix: correct login form validation message
docs: expand architecture guide for new contributors
chore: add issue templates and codeowners
```

---

## What Not To Do

Please do not:

- open PRs directly to `main`
- mix unrelated changes in one PR
- move files around without understanding the architecture
- put API calls inside widgets
- put JSON parsing inside domain entities
- commit secrets, API keys, tokens, or credential files
- edit `pubspec.yaml` casually without a valid reason

---

## If You Are Unsure

If you are confused about where code belongs:

1. Read `ARCHITECTURE.md` again — specifically the blast radius table.
2. Check whether the issue mentions `presentation`, `domain`, or `data`.
3. Ask in the issue comments before making the change.

It is always better to ask than to place code in the wrong layer. I would rather answer ten questions than review a PR that needs to be rebuilt from scratch.
