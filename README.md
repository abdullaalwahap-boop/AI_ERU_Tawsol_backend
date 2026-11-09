# AI Connect — Flutter Frontend

A mobile application for WE Applied Technology School - Suez (مدرسة WE للتكنولوجيا التطبيقية بالسويس) that connects students, teachers, and administrators through announcements, real-time chat, smart attendance, and course management.ime chat, and course management.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [State Management](#state-management)
- [Navigation](#navigation)
- [Real-time Communication](#real-time-communication)
- [Localization](#localization)
- [Testing](#testing)
- [Getting Started](#getting-started)
- [Dependencies](#dependencies)

---

## Features

| Feature | Description |
|---|---|
| **Authentication** | Login, Forget Password (OTP flow), Reset Password, Change Password |
| **Announcements** | Real-time feed with filtering, role-based tabs (student / doctor / admin), WebSocket live updates |
| **Private Chat** | Real-time 1-to-1 messaging with text, voice, image, and file support |
| **Courses** | Course list and details with content tabs for students and doctors |
| **Quiz** | AI-generated quiz from course content |
| **Profile** | View and manage personal info, change password, settings |
| **Home** | Role-based navigation — student/doctor get bottom nav, admin gets full-screen feed |
| **Settings** | Theme toggle (light/dark) and language switch (Arabic/English) |
| **Onboarding** | First-launch walkthrough, skipped on subsequent launches |

### Role-based Access

| Role | Bottom Nav | FAB | Announcement Tabs |
|---|---|---|---|
| Student | Yes | No | All announcements |
| Doctor | Yes | Yes (post announcement) | Mine + Admin |
| Admin | No (full-screen) | Yes | All + manage |

---

## Architecture

The project follows **Clean Architecture** with a **Feature-first** folder structure.

```
lib/
├── core/                  # Shared infrastructure
│   ├── errors/            # NetworkException, failure types
│   ├── events/            # AnnouncementChangeNotifier (cross-feature events)
│   ├── localization/      # AppLocalizations (ARB-generated)
│   ├── network/           # Dio client, API constants, interceptors
│   ├── services/          # GetIt locator, SecureStorage, LocalStorage
│   ├── session/           # SessionCubit — global auth state
│   ├── settings/          # SettingsCubit — theme + language
│   ├── theme/             # AppTheme, AppColors, AppTextStyles
│   └── utils/             # AppRouter (GoRouter)
│
└── features/
    ├── announcement/
    ├── authentication/
    ├── chat/
    ├── course/
    ├── home/
    ├── onboarding/
    ├── profile/
    ├── quiz/
    └── splash/
```

Each feature follows the same internal structure:

```
feature/
├── data/
│   ├── models/     # Data classes (fromJson / toJson / copyWith)
│   ├── repos/      # Abstract repository interfaces
│   ├── services/   # WebSocket services, platform services
│   └── sources/    # Remote data sources (Dio calls)
└── presentation/
    ├── manager/    # Cubits + States
    └── view/
        ├── widgets/
        └── feature_view.dart
```

---

## Project Structure

```
frontend/
├── lib/
│   ├── core/
│   └── features/
├── test/
│   ├── core/          # Unit tests for core layer
│   ├── features/      # Unit + widget tests per feature
│   └── helpers/       # Shared test utilities
├── assets/
│   └── images/png/
├── l10n/              # ARB localization files
└── pubspec.yaml
```

---

## State Management

The app uses **flutter_bloc** (Cubit variant) throughout.

| Cubit | Scope | Responsibility |
|---|---|---|
| `SessionCubit` | Global (root) | Authenticated user identity (role + userId) |
| `SettingsCubit` | Global (root) | Theme mode + locale |
| `LoginCubit` | Local | Login form state |
| `ForgetPasswordCubit` | Local | OTP request state |
| `AnnounCubit` | Per-screen | Announcement list + filters |
| `ChatCubit` | Per-screen | Conversation list |
| `PrivateChatCubit` | Per-screen | Messages in a conversation |
| `CoursesCubit` | Per-screen | Course list |
| `CourseDetailsCubit` | Per-screen | Course content tabs |
| `ProfileCubit` | Per-screen | User profile data |
| `QuizCubit` | Per-screen | Quiz flow |

Global cubits are provided at the root via `MultiBlocProvider` and registered in **GetIt** so services can access them without the BuildContext.

---

## Navigation

Uses **GoRouter** with named routes defined in `AppRouter`.

| Constant | Path | View |
|---|---|---|
| `/` | Splash | `SplashView` |
| `kLoginView` | `/loginView` | `LoginView` |
| `kHomeView` | `/homeView` | `HomeView` |
| `kForgetPasswordView` | `/forgetPasswordView` | `ForgetPasswordView` |
| `kOtpView` | `/otpView` | `OtpView` |
| `kResetPasswordView` | `/resetPasswordView` | `ResetPasswordView` |
| `kAddAnnouncementView` | `/addAnnouncementView` | `AddAnnounView` |
| `kCourseDetailsView` | `/courseDetailsView` | `CourseDetailsView` |
| `kProfileView` | `/profileView` | `ProfileView` |
| `kQuizView` | `/quizView` | `QuizView` |

**Splash navigation logic:**

```
App Start → SplashView (2600ms)
    ├── hasToken && isLoggedIn  →  restoreSession  →  HomeView
    ├── hasSeenOnboarding       →  LoginView
    └── first launch            →  OnBoardingView
```

---

## Real-time Communication

Two persistent WebSocket connections are maintained as GetIt singletons:

### ChatWebSocketService

- Connects to `ws(s)://host/chat/ws/{userId}?token={jwt}`
- Handles incoming events: `message`, `sent`, `typing`, `seen`, `delivered`, `message_edited`, `message_deleted`
- Shared between `ChatCubit` (conversation list) and `PrivateChatCubit` (message view)

### AnnouncementWsService

- Connects to `ws(s)://host/announcements/ws/{userId}?token={jwt}`
- Emits announcement IDs when new announcements are posted
- Triggers silent refresh in `AnnounCubit`
- Auto-reconnects on disconnect (5-second backoff)

Cross-feature announcement events (edit, delete, mark-read) use `AnnouncementChangeNotifier` — a `ChangeNotifier` singleton that notifies the active `AnnounCubit` without coupling features directly.

---

## Localization

The app supports **Arabic** and **English** using Flutter's `intl` / ARB system.

- ARB files live in `l10n/`
- Generated code is accessed via `AppLocalizations.of(context)`
- Language is persisted in `SharedPreferences` via `SettingsCubit`
- Switching language rebuilds the root `MaterialApp` instantly

---

## Testing

**411 tests — all passing.**

### Test breakdown

| Layer | Files | Tests |
|---|---|---|
| Core unit tests | 5 | ~59 |
| Feature unit tests | 19 | ~302 |
| Feature widget tests | 7 | ~42 |
| Placeholder | 1 | 1 |
| **Total** | **31** | **411** |

### Unit tests cover

- All Cubits: happy path, error handling, state transitions, edge cases
- Data models: `fromJson`, `toJson`, `copyWith`, equality
- Validators: email, password rules
- Utilities: link detection, time formatting
- Core: `SessionCubit`, `SettingsCubit`, `AppRole`, `NetworkException`, `AuthFlowService`

### Widget tests cover

| Widget | States tested |
|---|---|
| `LoginForm` | Fields render, validation, loading spinner, button disabled, submit calls cubit |
| `ForgetPasswordForm` | Field, submit, loading, disabled, calls cubit |
| `AnnounViewBody` | Loading skeleton, error, loaded list, empty, doctor tab bar |
| `ChatViewBody` | Loading, error, conversation list, FAB |
| `PrivateChatBody` | Loading, message list, input bar, text field, empty |
| `CourseViewBody` | Loading skeleton, error, course cards, empty, initial |
| `ProfileViewBody` | Initial, loading, error, retry button, loaded name |
| `HomeViewBody` | Student BNB, doctor BNB, doctor FAB, admin no-BNB, tab index |

### Test helpers

| File | Purpose |
|---|---|
| `test/helpers/test_app_wrapper.dart` | `testWrap()` wraps any widget in `MaterialApp` with localizations |
| `test/helpers/getit_test_setup.dart` | `setupTestGetIt()` / `tearDownTestGetIt()` — registers fakes for widgets that use GetIt in `initState` |

### Running tests

```bash
# All tests
flutter test test/

# By feature
flutter test test/features/authentication/
flutter test test/features/announcement/
flutter test test/features/chat/
flutter test test/features/course/
flutter test test/features/profile/
flutter test test/features/home/
flutter test test/features/quiz/

# Core layer only
flutter test test/core/
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Android Studio / Xcode for emulator or physical device
- A running backend (Django + WebSocket server)

### Setup

```bash
# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run on device/emulator
flutter run
```

### Firebase

The app uses Firebase Authentication. Add your `google-services.json` (Android) to `android/app/` before building.

---

## Dependencies

### Core

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management (Cubit) |
| `get_it` | Service locator / dependency injection |
| `go_router` | Declarative navigation |
| `dio` | HTTP client |
| `firebase_core` / `firebase_auth` | Authentication |
| `flutter_secure_storage` | JWT token storage |
| `shared_preferences` | Local settings (theme, language, onboarding flag) |
| `dartz` | Functional error handling (`Either`) |
| `equatable` | Value equality for state classes |

### Real-time & Media

| Package | Purpose |
|---|---|
| `record` | Voice message recording |
| `just_audio` | Voice message playback |
| `audio_session` | Audio focus management |
| `image_picker` / `file_picker` | Media selection |
| `gal` | Save media to gallery |
| `mobile_scanner` | QR code scanning |
| `permission_handler` | Runtime permissions (microphone, storage) |
| `path_provider` | Local file paths for recordings |

### UI

| Package | Purpose |
|---|---|
| `google_fonts` | Plus Jakarta Sans typeface |
| `flutter_svg` | SVG assets |
| `smooth_page_indicator` | Onboarding page dots |
| `emoji_picker_flutter` | Chat emoji picker |
| `flutter_linkify` | Clickable links in chat messages |
| `any_link_preview` | Link preview cards |
| `open_filex` | Open downloaded files |
| `url_launcher` | Open URLs in browser |

### Testing

| Package | Purpose |
|---|---|
| `flutter_test` | Widget testing framework (SDK) |
| `bloc_test` | Cubit state emission testing |
| `mocktail` | Mock / stub generation |
