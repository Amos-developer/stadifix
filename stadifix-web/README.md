# stadifix_web

A new Flutter project.

## Registration

Configure the API server origin when running the app:

```sh
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

For an Android emulator, use `http://10.0.2.2:8080`; use your server's HTTPS origin for production. The client appends `/api/v1/auth/register`.

Registration sends `fullName`, `email`, `password`, and `role` (`CUSTOMER` or `PROVIDER`). Passwords require 12–72 characters and at most 72 UTF-8 bytes. Phone numbers are not part of the API contract. Successful registration creates an account; it does not establish an authenticated session.

Cross-origin browser requests require CORS configuration on the API or a same-origin proxy. Social sign-up is disabled until supported by the backend. Sign-in and published terms are not implemented yet; terms consent is currently a client-side form requirement only.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
