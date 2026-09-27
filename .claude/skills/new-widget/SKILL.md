---
name: new-widget
description: Scaffold a new custom widget under lib/widgets/ui/ or lib/widgets/shared/ following this project's flat widget structure (AGENTS.md Rule 1). Use when the user asks to create/add a new button, dropdown, input, or any reusable widget.
---

# New Widget Scaffold

Given a widget name (e.g. "button", "app_video"), decide which of the two flat categories it belongs to, then scaffold it.

## Steps

1. Decide the category (ask the user only if genuinely ambiguous):
   - **`lib/widgets/ui/<name>/`** — a custom basic widget wrapping a Flutter built-in (button, text field, dropdown, radio button, checkbox, etc.). One widget = one Flutter primitive it wraps/styles.
   - **`lib/widgets/shared/<name>/`** — a custom widget reused across multiple app modules that isn't a thin wrapper over a single Flutter primitive (app image, app video, app avatar, empty state, etc.).
2. Create the folder with exactly this layout (match AGENTS.md Rule 1's example — flat, no nested categorization):
   ```text
   lib/widgets/<ui|shared>/<name>/
     <name>.dart
     types.dart   (only if the widget needs an enum/variant/size type — e.g. ButtonVariant)
   ```
3. `<name>.dart` should:
   - Export a single public widget class in `PascalCase` (e.g. `Button`, `AppVideo`).
   - Use named parameters with sensible defaults.
   - Pull all colors from `AppColors.*` in `lib/core/constants/design_tokens.dart` — never a hardcoded hex value (Rule 6).
   - Contain **no comments** (Rule 7).
4. If the widget needs an internal variant/size/type enum, put it in `types.dart` next to it, not inlined in `<name>.dart` (Rule 10 — types belong in a dedicated file, even at widget scope).
5. **Never** add an API/network call inside `lib/widgets/shared/*` or `lib/widgets/ui/*` — these are dumb/presentational widgets (Rule 3 applies to shared components generally; treat both `ui/` and `shared/` the same way). If the request implies fetching data, stop and tell the user that belongs in a module's service layer instead, and offer to scaffold that with `/new-module`.
6. Apply import order (Rule 5) to the generated file.
7. Report the exact files created and which category you placed the widget in, with a one-line justification.
