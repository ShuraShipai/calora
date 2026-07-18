# Calora

Calora is a Flutter nutrition and wellness app for setting health goals,
logging food, tracking water and weight, reviewing daily progress, and
maintaining useful reminder routines.

The app uses Firebase Authentication for accounts, Cloud Firestore for
user-scoped data, Provider for dependency injection and UI state, and a
feature-first Flutter architecture. Its Material 3 interface follows the
companion `calora-design` HTML prototype, with locally bundled Inter and
Fraunces fonts.

## Features

- Email/password sign-up, login, password reset, sign-out, and secure account
  deletion.
- Guided onboarding for personal details, activity, wellness intent, units,
  and health goals.
- Home dashboard with calorie, macro, water, weight, meal, and daily-goal
  progress.
- Food diary for breakfast, lunch, dinner, and snacks.
- Manual food logging, custom foods, copied meals, barcode scanning, Open Food
  Facts lookup, and optional USDA FoodData Central nutrition lookup.
- Water quick-add, custom entries, history, and configurable hydration goals.
- Weight logging, historical entries, target-weight summaries, and trends.
- Progress insights for calories, macros, water, and weight.
- Health-goal editing for calories, macros, water, target weight, and weekly
  weight change.
- Local meal, water, weight, and diary reminders with device permission
  handling and schedule synchronisation.
- Metric and imperial units, light and dark themes, CSV export, privacy,
  help, and profile settings.

## Tech Stack

| Area | Technology |
| --- | --- |
| App | Flutter and Dart |
| State and dependency injection | `provider` |
| Authentication | Firebase Authentication |
| User data | Cloud Firestore |
| Account deletion | Firebase Cloud Functions |
| Notifications | `flutter_local_notifications`, `timezone`, `flutter_timezone` |
| Food data | Open Food Facts and USDA FoodData Central |
| Scanning | `mobile_scanner` |
| Networking | Dio and `connectivity_plus` |
| Export sharing | `share_plus` |
| UI | Material 3, `flutter_screenutil`, Inter, Fraunces |

## State Management

Calora uses Provider for both dependency injection and UI-facing state.

- `appProviders` is the composition root for services and providers.
- `Provider<T>` registers stateless integrations such as Firebase, networking,
  notifications, and food-lookup services.
- `ChangeNotifierProvider<T>` registers mutable application state.
- `ChangeNotifierProxyProvider` binds user-scoped providers to the active
  authenticated profile.
- Widgets use `context.watch<T>()` to render state and `context.read<T>()`
  for actions.

Key providers:

- `AuthProvider`: authentication state, profile loading, onboarding, profile
  updates, sign-out, and account deletion.
- `ThemeProvider`: persisted light, dark, or system theme selection.
- `HomeProvider`: daily home-summary subscription for the active user.
- `DiaryProvider`: diary entries, nutrition totals, and entry mutations.
- `ProgressProvider`: water and weight history plus progress mutations.
- `ReminderProvider`: reminder settings, permission requests, persistence, and
  device schedule synchronisation.
- `DataExportProvider`: CSV export state and errors.
- `BarcodeLookupProvider`, `ScannerProvider`, and
  `UsdaNutritionLookupProvider`: scanner and nutrition-lookup workflows.

## Architecture

Calora follows a feature-first structure:

- `lib/main.dart` delegates startup to `bootstrap()`.
- `lib/app` owns app composition, routes, global providers, theme preferences,
  and the bottom navigation shell.
- `lib/core` owns feature-neutral theme tokens, models, networking, formatters,
  and reusable widgets.
- `lib/features/<feature>` owns feature-specific presentation, providers,
  models, and services.
- Services isolate Firebase, notifications, networking, and device SDKs.
- Providers coordinate asynchronous workflows and expose renderable state.
- Screens and widgets remain presentation-focused.
- Named routes are centralised in `AppRoutes` and built by `AppRouter`.

Dependency direction is intentionally one-way: `app` can compose features,
features can import `core`, and `core` never imports feature modules.

## Firebase And Data Layer

Firebase is initialised during bootstrap with
`DefaultFirebaseOptions.currentPlatform`. The checked-in
`lib/firebase_options.dart` contains the FlutterFire configuration for Android,
iOS, macOS, web, and Windows.

All product data is scoped beneath the signed-in user:

```text
users/{uid}
  diaryEntries/{entryId}
  waterEntries/{entryId}
  weightEntries/{entryId}
  settings/reminders
  dailySummaries/{yyyy-mm-dd}
```

The user document itself stores profile and onboarding information. Firestore
rules restrict reads and writes to the authenticated owner of each `users/{uid}`
tree.

Account deletion is deliberately server-side. The callable function under
`functions/src/index.ts` recursively deletes the user’s Firestore tree and
deletes the matching Firebase Authentication user. The Firebase project must
have Cloud Functions enabled and deployed before this workflow can operate.

## Detailed Folder Structure

```text
lib/
  main.dart
  firebase_options.dart

  app/
    bootstrap.dart                 # Firebase and root provider startup
    calora_app.dart                # Root MaterialApp and theme wiring
    providers/                     # Global provider composition and theme state
    router/                        # Route constants and route builders
    services/                      # App-level persistence helpers
    widgets/                       # Main bottom navigation

  core/
    formatters/                    # Unit and measurement formatting
    models/                        # Shared profile and goal models
    network/                       # Dio client and connectivity boundary
    theme/                         # Colours, typography, spacing, radii, shadows
    widgets/                       # Feature-neutral UI primitives

  features/
    auth/                          # Authentication, profile persistence, deletion
    diary/                         # Food diary and nutrition totals
    food/                          # Add, copy, and custom-food flows
    home/                          # Home dashboard and daily summaries
    onboarding/                    # First-run health-profile setup
    profile/                       # Goals, reminders, export, privacy, support
    progress/                      # Water, weight, history, and insights
    scanner/                       # Barcode scan and food-nutrition lookup

functions/
  src/index.ts                     # Callable account-deletion function

test/                              # Unit and widget coverage
docs/screenshots/                  # Optional public README screenshots
```

Within a feature, `presentation` owns screens and widgets, `providers` own
UI-facing state, `models` own immutable data, and `services` own external
boundaries.

## Screens And Navigation

Routes are defined in `lib/app/router/app_routes.dart`.

Primary routes include:

- `/` splash
- `/login`, `/sign-up`, and `/forgot-password`
- `/onboarding`
- `/home`, `/diary`, `/food/add`, `/food/copy-meal`, and `/food/custom`
- `/scanner` and `/scanner/results`
- `/progress`, `/progress/water`, and `/progress/weight`
- `/profile`, `/profile/goals`, `/profile/reminders`, `/profile/units`, and
  `/profile/personal-details`
- `/profile/privacy` and `/profile/help-support`

The signed-in main navigation exposes Home, Diary, Scan, Progress, and Profile.

## Getting Started

### Prerequisites

- Flutter SDK compatible with Dart `^3.12.2`
- Android Studio / Android SDK for Android development
- Xcode for iOS and macOS development
- A Firebase project configured with the matching platform applications
- A USDA FoodData Central API key only when USDA lookup is needed

### Install

```sh
flutter pub get
```

### Run

```sh
flutter run
```

### USDA Nutrition Lookup

USDA lookup is optional. Supply the API key at build or run time:

```sh
flutter run --dart-define=USDA_API_KEY=your_api_key
```

The app remains usable without the key; USDA lookup is simply unavailable.

## Cloud Functions

Install and deploy the account-deletion function from the `functions` folder:

```sh
npm install
npm run build
firebase deploy --only functions:deleteAccount --project calora-shurashipai
```

Cloud Functions v2 requires a Firebase project with the required billing and
Google Cloud APIs enabled. Never commit service-account files, API keys, or
other private credentials.

## Notifications

Calora requests notification permission only when an enabled reminder needs
it. Reminder settings are persisted in Firestore; the actual pending local
notifications are created and replaced on the user’s device.

For iOS, test on a physical device and confirm that alerts, badges, and sounds
are permitted in **Settings → Notifications → Calora**. Battery saving, Focus,
and operating-system notification settings can suppress normal notification
alerts and sounds.

## Testing

The project includes unit, provider, service, and widget tests for auth,
onboarding, diary totals, progress, reminders, data export, scanner lookup,
formatting, themes, and routes.

Run all checks:

```sh
dart format lib test
flutter analyze
flutter test
```

Run a focused test while iterating:

```sh
flutter test test/reminder_provider_test.dart
```

## App screens

### Welcome, sign in, and onboarding

<table>
  <tr>
    <td><img src="docs/screenshots/01-welcome.png" alt="Calora welcome screen" width="210"></td>
    <td><img src="docs/screenshots/02-login.png" alt="Calora log in screen" width="210"></td>
    <td><img src="docs/screenshots/03-onboarding-details.png" alt="Calora onboarding personal details" width="210"></td>
    <td><img src="docs/screenshots/04-onboarding-activity.png" alt="Calora onboarding activity level" width="210"></td>
    <td><img src="docs/screenshots/05-onboarding-goals.png" alt="Calora onboarding goals and units" width="210"></td>
  </tr>
</table>

### Daily tracking and diary

<table>
  <tr>
    <td><img src="docs/screenshots/06-home-dashboard.png" alt="Calora home dashboard" width="210"></td>
    <td><img src="docs/screenshots/07-home-meals.png" alt="Calora home meal summary" width="210"></td>
    <td><img src="docs/screenshots/08-diary.png" alt="Calora diary" width="210"></td>
    <td><img src="docs/screenshots/09-food-details.png" alt="Calora food details sheet" width="210"></td>
  </tr>
</table>

### Scan and log food

<table>
  <tr>
    <td><img src="docs/screenshots/10-barcode-scanner.png" alt="Calora barcode scanner" width="210"></td>
    <td><img src="docs/screenshots/11-scan-result.png" alt="Calora scan result" width="210"></td>
    <td><img src="docs/screenshots/12-copy-meal.png" alt="Calora copy previous meal" width="210"></td>
    <td><img src="docs/screenshots/13-custom-food.png" alt="Calora custom food form" width="210"></td>
  </tr>
</table>

### Progress and preferences

<table>
  <tr>
    <td><img src="docs/screenshots/14-progress.png" alt="Calora progress dashboard" width="210"></td>
    <td><img src="docs/screenshots/15-profile.png" alt="Calora profile" width="210"></td>
    <td><img src="docs/screenshots/16-reminders.png" alt="Calora reminders" width="210"></td>
  </tr>
  <tr>
    <td><img src="docs/screenshots/17-units.png" alt="Calora units settings" width="210"></td>
    <td><img src="docs/screenshots/18-home-dark.png" alt="Calora dark theme home dashboard" width="210"></td>
    <td><img src="docs/screenshots/19-log-out-confirmation.png" alt="Calora log out confirmation" width="210"></td>
  </tr>
</table>

## Contributing

Keep changes feature-owned, use the existing Calora tokens and shared widgets,
and add focused tests for new state or service behaviour. Do not construct SDK
services in widgets; place external calls in feature services and coordinate
them through providers.

## License

This repository is private (`publish_to: none`). Confirm the intended licence
before redistributing any part of the project.
