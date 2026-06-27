## How to Contribute

1. Pick an issue labeled `good first issue` or `intermediate`
2. Comment on it to claim it
3. Fork → clone → create branch: `feature/your-issue-name` or `bugfix/...`
4. Run `flutter analyze` — no warnings allowed
5. Open a PR to `dev` (not main), fill the PR template, link your issue

## Branch naming
- `feature/events-list-ui`
- `bugfix/auth-token-refresh`
- `docs/improve-architecture-md`

## Flutter conventions
- snake_case for files, PascalCase for classes
- No business logic inside Widgets
- State lives in controllers (Riverpod Notifiers)