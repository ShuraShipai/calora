# Calora

Flutter foundation for the Calora nutrition and wellness application. The
sibling `calora-design` HTML prototype is the source of truth for all screens,
copy, navigation, and visual tokens.

## Structure

```text
lib/
  app/                 bootstrap, root widget, global providers, routing
  core/theme/          design tokens and Material 3 light/dark themes
  core/widgets/        reusable design-system widgets
  features/<feature>/  feature-owned presentation, providers, models, services
```

Feature code should keep UI in `presentation`, state in `providers`, immutable
data objects in `models`, and external or persistence concerns in `services`.
Create those folders inside a feature only when implementation begins; shared
code belongs in `core` only when it is genuinely used across features.

## Foundation scope

- Provider is installed and the root `MultiProvider` is ready for feature
  providers.
- Firebase Core is configured for Android, iOS, macOS, web, and Windows through
  project `calora-shurashipai` and initializes before the application starts.
- Every screen in `calora-design` has a named route and presentation entry
  class.
- Material 3 light and dark themes expose the prototype's palette, typography,
  spacing, radii, shadows, elevations, durations, sizes, strokes, and opacity
  values.
- Inter and Fraunces are bundled locally under `assets/fonts` with their OFL
  licenses.
- Screen entry classes intentionally contain no feature behavior. Firebase
  Auth, Firestore, Storage, Analytics, and backend business logic are not
  implemented yet.

## Commands

```sh
flutter pub get
flutter analyze
flutter test
```
