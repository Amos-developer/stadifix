# stadifix_web

A new Flutter project.

## Registration

Configure the API server origin when running the app:

```sh
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

For an Android emulator, use `http://10.0.2.2:8080`; use your server's HTTPS origin for production. The client appends `/api/v1/auth/register`.

Registration sends `fullName`, `email`, `password`, and `role` (`CUSTOMER` or `PROVIDER`). Passwords require 12–72 characters and at most 72 UTF-8 bytes. Phone numbers are not part of the API contract. Successful registration creates an account; it does not establish an authenticated session.

Cross-origin browser requests require CORS configuration on the API or a same-origin proxy. Social sign-up is disabled until supported by the backend. Published terms are not implemented yet; terms consent is currently a client-side form requirement only.

## Homepage preview

Run `flutter run -d chrome --route=/home` to preview the homepage directly, or tap Sign In on the login screen without entering credentials. It includes service search, category filters, local favorites, sample professional details, a location selector, and bottom navigation. All professionals and reviews are demo data. Booking, messages, notifications, and account data are not connected to the API.

## Provider lists

The Bookings navigation tab opens My Bookings with Upcoming/Past lists and demo statuses. New confirmation previews are saved in memory for the current session. Reschedule and Cancel update only this local list; View Details shows the saved summary. Initial bookings are sample data, and all changes reset when the app restarts.

Provider cards on Home and the provider list open a full profile with experience, service options, pricing, favorites, and a share-details dialog. Book Now opens the booking form with the selected professional and service. Message opens a local preview only. Profile verification and work statistics are explicitly sample data.

The booking form offers the next seven dates, sample time slots, optional service notes, and a one-hour price estimate. Confirm Booking opens the confirmation preview, carrying the selected provider, service, date, time, city, and notes. View Booking shows the complete local details; the share action copies a preview summary. No appointment is submitted and no payment is taken. Availability is not connected to the backend.

Tap a homepage category or the professionals' See All action to browse providers. Search, top-rated and saved filters, and recommended/price/distance sorting work with local sample data. Favorites persist between Home and the provider list during the current app session. Prices, distances, and reviews are samples; booking and backend discovery are not connected.

## Login screen preview

The login screen is accessible from Splash and registration. It displays the backend's `email` and `password` fields with password visibility controls. For the current preview, Sign In bypasses validation and opens Home without credentials. It makes no API requests, stores no credentials, and does not create a session. Password recovery and social sign-in are not connected yet.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
