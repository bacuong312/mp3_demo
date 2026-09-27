# AGENTS.md

## Purpose

This file defines mandatory implementation rules for this project.
Do not change these rules unless the user explicitly asks to update them.

## Rules

### Rule 1 - Flat Widget Structure

Keep widgets in a flat widget-folder structure under two categories:

- **`lib/widgets/ui/`** — Custom basic widgets that wrap Flutter built-ins (button, text field, dropdown, radio button, etc.)
- **`lib/widgets/shared/`** — Custom widgets used across multiple app modules (app image, app video, etc.)

#### Rule 1 Example

```text
lib/widgets/ui/
  button/
    button.dart
    types.dart
  dropdown/
    dropdown.dart
    types.dart

lib/widgets/shared/
  app_image/
    app_image.dart
  app_video/
    app_video.dart
```

### Rule 2 - Feature-Based Architecture for Modules

Apply **Feature-Based Architecture** for `lib/modules`.

#### Rule 2 Example

```text
lib/modules/*/
  ├── components/
  ├── constants/
  ├── converters/
  ├── providers/
  ├── services/
  ├── types/
  ├── utils/
  └── {module_name}_page.dart
```

Note: Sub-directories (e.g., `constants/`, `providers/`) should only be created when they are actually used by the module.

### Rule 3 - No API Calls in Shared Components

Never make API calls in `lib/widgets/shared` because all components there are dumb/presentational widgets.

### Rule 4 - Domain/System Texts Must Be Constants or Enums

Only domain/system texts must be declared as constants or enums (for example: table columns, API status values, business status values, system messages).
Simple UI labels can be hard-coded in widgets.

### Rule 5 - Import Order

Import order must follow this sequence:

1. Dart/Flutter SDK imports
2. External package imports
3. Project imports (package:mp3_app/)
4. Relative imports (`./` or `../`)

Each import group (1, 2, 3, 4) must be separated by one blank line.

### Rule 6 - Use Global Design Tokens for Styles

Never hard-code HEX color values in widgets.
Use global color tokens from the design system defined in `lib/core/constants/design_tokens.dart` (e.g., `AppColors.primary`, `AppColors.textSecondary`).

### Rule 7 - No Comments in Code

Do not add comments to the source code (neither single-line `//` nor multi-line `/* */`).
The code should be self-documenting through clear naming and modular structure.

### Rule 8 - Core Layer Import Boundaries

Inside `lib/core`, use relative imports for other `core` files. Do not use `package:mp3_app/core/*` from within `core`.
Also, `core` must not depend on types defined in `lib/modules`; shared API DTO types belong to `lib/core/types`.

### Rule 9 - Logic Helper Separation

All logic processing helpers and utility functions must be placed in a `utils` folder or file. They should not be declared within converters, services, or widgets.

### Rule 10 - Centralized Type and Model Declarations

Type and model declarations must not be inlined in service, widget, or converter files. Use the appropriate folder:

- **`types/`** — enums, typedefs, simple value objects (no JSON serialization)
- **`models/`** — data models with `fromJson`/`toJson` serialization, API DTOs

Shared models used across modules go in `lib/core/models/`. Module-specific types go in `lib/modules/*/types/`.

#### Rule 10 Example

```dart
// Bad in sign_in_service.dart
class SignInResult {
  final AuthUser user;
  final String accessToken;
}

// Good — simple value object
// lib/modules/sign_in/types/sign_in_result.dart
class SignInResult {
  final AuthUser user;
  final String accessToken;
}

// Good — serializable model
// lib/core/models/user.dart
class User {
  final String? id;
  factory User.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

### Rule 11 - Separated Layers

The architecture follows a three-layer pattern: **UI → Service → API**. Each layer has a single responsibility:

- **API layer** (`lib/core/api/`): Only handles HTTP requests and responses. No business logic, no state management, no storage operations.
- **Service layer** (`lib/modules/*/services/`): Contains business logic, calls API, processes responses, manages storage (e.g. saving tokens). Returns simple result objects to the UI.
- **UI layer** (`lib/modules/*/*_page.dart`): Only handles rendering and user interaction. Calls the service, then reacts to the result (show message, navigate, etc.).

UI must never call API directly. UI calls Service, Service calls API.

#### Rule 11 Example

```text
lib/core/api/
  base_api_client.dart   (abstract base class — shared GET/POST/PUT/DELETE)
  auth_api.dart
  types/
    api_response.dart
  clients/
    vdb_api_client.dart  (extends BaseApiClient, vdiarybook headers + JWT)
    notice_api_client.dart (extends BaseApiClient, notice API headers)

lib/modules/login/
  services/
    login_service.dart   (calls AuthApi, saves token, returns LoginResult)
  types/
    login_result.dart
  login_page.dart        (calls LoginService, shows UI feedback)
```

### Rule 12 - State Management with Riverpod

Use **Riverpod** for state management across the app. Do not use ad-hoc `setState`-only state for anything beyond purely local, presentational widget state (e.g. a text field's focus animation), the `provider` package, `Bloc`, `GetX`, or other state management libraries.

- Providers live in `lib/modules/*/providers/` for module-scoped state, and `lib/core/providers/` for app-wide/global state.
- Prefer `Notifier`/`AsyncNotifier` over plain `StateProvider` for anything beyond trivial primitive state.
- UI widgets read state via `ConsumerWidget`/`ConsumerStatefulWidget` and `ref.watch`; they must not hold business logic themselves (Rule 11 — UI stays presentation-only).
- A provider calls the module's `services/` layer for business logic/API calls; the UI calls the provider, never the service directly, when a provider already wraps that service for shared state.

#### Rule 12 Example

```text
lib/modules/karaoke/
  providers/
    playback_provider.dart   (NotifierProvider wrapping AudioPlayerService)
  services/
    audio_player_service.dart
  karaoke_page.dart           (ConsumerWidget, watches playbackProvider)
```
