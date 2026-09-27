---
name: new-module
description: Scaffold a new lib/modules/* feature folder following this project's Feature-Based Architecture (AGENTS.md Rule 2). Use when the user asks to create/add/scaffold a new module, feature, screen, or page.
---

# New Module Scaffold

Given a module name (e.g. "login", "playlist_detail"), create it under `lib/modules/` following AGENTS.md.

## Steps

1. Normalize the name to `snake_case` for the folder/file and `PascalCase` for the class (e.g. `playlist_detail` → `PlaylistDetailPage`).
2. Create only:
   ```text
   lib/modules/<name>/<name>_page.dart
   ```
   Do **not** create `components/`, `constants/`, `converters/`, `providers/`, `services/`, `types/`, or `utils/` subfolders unless the user's request already implies one is needed immediately (per AGENTS.md Rule 2's note). Ask or infer from context before adding empty scaffolding.
3. `<name>_page.dart` should contain a minimal, working widget stub:
   - A `StatelessWidget` or `StatefulWidget` named `<PascalName>Page`.
   - A basic `Scaffold` with an `AppBar` title and empty body — nothing more.
4. If the user's request implies a service call (e.g. "login module that calls an API"), also create:
   ```text
   lib/modules/<name>/services/<name>_service.dart
   lib/modules/<name>/types/<name>_result.dart   (if the service returns a non-trivial result)
   ```
   The service must call `lib/core/api/*` — never call an HTTP client directly from the page (AGENTS.md Rule 11: UI → Service → API).
5. Apply project-wide rules to all generated code:
   - **Rule 5** — import order: Dart/Flutter SDK → external packages → `package:mp3_app/...` → relative imports, one blank line between each group.
   - **Rule 6** — no hardcoded hex colors; use `AppColors.*` from `lib/core/constants/design_tokens.dart` (create it with a couple of sane token stubs if it doesn't exist yet and the generated widget needs a color).
   - **Rule 7** — no comments in generated code.
   - **Rule 9** — any non-trivial logic goes in a `utils/` file, not inline in the page/service.
   - **Rule 10** — don't inline model/type classes in the page or service file; put them in `types/` (plain value objects) or `lib/core/models/` (serializable DTOs shared across modules).
6. Report back exactly which files were created and why any optional subfolders were included or skipped.
