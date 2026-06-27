# Security Guidelines

This is a teaching project. Security principles are implemented as examples for contributors to learn from.

## Secrets — Never Commit These

- API keys, tokens, passwords
- `google-services.json` or `GoogleService-Info.plist` (Firebase credentials)
- Any `.env` file

These are all in `.gitignore`. If you accidentally commit a secret, rotate it immediately.

## Auth & Token Storage

- Use `flutter_secure_storage` for storing JWT tokens on-device — never `SharedPreferences`
- Access tokens should be short-lived; refresh tokens long-lived
- Never log tokens or sensitive data with `print()`

## Input Validation

- Validate all form fields before sending to any API
- Sanitize strings: don't pass raw user input into queries or URLs
- Use typed models (like `EventModel.fromJson`) — don't work with raw `Map<String, dynamic>` in UI

## API Security (when backend is added)

- All API calls over HTTPS only
- Attach JWT in `Authorization: Bearer <token>` header via Dio interceptor
- Handle 401 responses: clear token, redirect to login

## Reporting Issues

Found a security issue? Open a GitHub issue with the `security` label or contact a maintainer directly.