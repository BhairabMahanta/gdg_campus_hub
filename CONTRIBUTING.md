# Contributing to GDG Campus Hub

Welcome. This repository is designed as a **Flutter learning project first** and an app second.
That means contributions should help people understand Flutter structure, state management,
routing, architecture, and collaboration workflow — not just add random features.

---

## Before You Start

Before writing any code:

1. Read `README.md` for project setup.
2. Read `ARCHITECTURE.md` to understand where code belongs.
3. Check open issues and pick one that matches your skill level.
4. Comment on the issue before starting, so work is not duplicated.

---

## Branch Strategy

This project uses **three levels of branches**:

```text
main        → stable/public branch
dev         → active development branch
feature/*   → temporary work branches
```

### What each branch means

#### `main`
- This is the **stable public branch**.
- Only reviewed, cleaned, and ready code should reach `main`.
- Contributors should **not** open pull requests directly to `main`.
- `main` is protected for safety.

#### `dev`
- This is the **working branch** of the project.
- Most pull requests should target `dev`.
- New features, fixes, and docs updates are merged here first.
- Once `dev` is stable, maintainers create a pull request from `dev` to `main`.

#### `feature/*`
- These are temporary branches created for one task at a time.
- Every contributor, including maintainers, should work in a feature branch.
- Examples:
  - `feature/events-filter-chip`
  - `feature/login-form-ui`
  - `docs/improve-architecture-guide`
  - `bugfix/router-path-fix`

---

## Contribution Flow

### For contributors

Use this workflow:

```text
fork repo → clone fork → checkout dev → create feature branch → code → push → PR to dev
```

### For maintainers

Use this workflow:

```text
feature/* → PR to dev → review/merge → later PR from dev → main
```

### Why this process exists

This process protects the public branch from accidental mistakes.
It also allows multiple contributors to work at the same time without constantly breaking
what is shown publicly in `main`.

---

## Step-by-Step Git Workflow

### 1. Get the latest code

```bash
git checkout dev
git pull origin dev
```

### 2. Create your branch

```bash
git checkout -b feature/short-description
```

Examples:

```bash
git checkout -b feature/events-category-filter
git checkout -b bugfix/login-validation
git checkout -b docs/update-contributing-guide
```

### 3. Make your changes

Keep your changes focused on one task only.
Do not mix unrelated fixes into one pull request.

### 4. Run checks before committing

```bash
flutter analyze
flutter test
```

If no tests exist yet, `flutter test` may do very little, and that is okay.
But `flutter analyze` must pass.

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

- **Base branch:** `dev`
- **Compare branch:** your feature branch

Do **not** target `main` unless a maintainer explicitly tells you to.

---

## Pull Request Rules

Every pull request should:

- target `dev`, not `main`
- solve one clearly scoped issue
- follow the project folder structure
- include a clear PR title and summary
- pass `flutter analyze`
- avoid committing secrets, tokens, or `.env` files

If your pull request changes multiple layers (`presentation`, `domain`, `data`), explain why.

---

## Maintainer Release Flow

Maintainers should periodically move stable work from `dev` into `main`.

That flow is:

```text
dev → PR to main → review → merge
```

Use this when:
- a feature is complete
- major bugs are fixed
- docs are clean
- the branch is safe for public viewing

This keeps `main` polished and `dev` flexible.

---

## Protected Branches and Why They Exist

This repository uses branch protection rules.
That means:

- direct pushes to important branches may be blocked
- pull requests may be required before merging
- reviews may be required
- maintainers may still choose to follow the same workflow for consistency

These rules are not there to make development annoying.
They exist to prevent accidental merges, broken code, and unsafe changes.

---

## Folder Rules

Read `ARCHITECTURE.md` for the full explanation. Quick guide:

| Folder | What belongs here | Who should touch it |
|---|---|---|
| `lib/core/` | Shared infrastructure like routing, theme, constants | Maintainers / advanced contributors |
| `features/*/presentation/pages/` | Full app screens | Beginners welcome |
| `features/*/presentation/widgets/` | Reusable UI components | Beginners welcome |
| `features/*/presentation/controllers/` | Riverpod/BLoC state management | Intermediate |
| `features/*/domain/` | Entities, use cases, repository interfaces | Intermediate / advanced |
| `features/*/data/` | API/local storage/models/repository implementations | Intermediate / advanced |
| `.github/` | Templates and repo automation config | Maintainers only |

### First-time contributor rule

If this is your first contribution, stay inside one of these folders:

- `lib/features/events/presentation/pages/`
- `lib/features/events/presentation/widgets/`
- `docs/` files like `README.md`, `ARCHITECTURE.md`, `CONTRIBUTING.md`

Avoid `core/`, `domain/`, and `data/` until you understand the architecture.

---

## Commit Message Style

Use conventional commit prefixes:

- `feat:` for a new feature
- `fix:` for a bug fix
- `docs:` for documentation only
- `refactor:` for code cleanup without behavior change
- `chore:` for config/tooling/setup work
- `style:` for formatting or UI polish without logic change

Examples:

```text
feat: add event category filter
fix: correct login form validation message
docs: expand architecture guide for new contributors
chore: add issue templates and codeowners
```

---

## What Not To Do

Please do **not**:

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

1. Read `ARCHITECTURE.md` again.
2. Check whether the issue mentions `presentation`, `domain`, or `data`.
3. Ask in the issue comments before making the change.

It is always better to ask than to place code in the wrong layer.
