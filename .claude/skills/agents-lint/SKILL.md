---
name: agents-lint
description: Check given files, a diff, or the whole lib/ tree against every rule in this project's AGENTS.md (widget structure, feature architecture, no API calls in shared components, constants/enums for domain text, import order, design tokens, no comments, core import boundaries, utils separation, centralized types/models, UI-Service-API layering). Use when the user asks to review, lint, audit, or check code against AGENTS.md / project rules, or before committing new modules/widgets.
---

# AGENTS.md Compliance Check

Read `AGENTS.md` at the repo root first — it is the source of truth; if it has changed since this skill was written, follow the file, not this description.

## Scope

- If the user names specific files/folders, check only those.
- If the user says "the diff" or "staged changes", run `git diff` (or `git diff --staged`) and check only changed files.
- If the user gives no scope, check every file under `lib/`.

## Checklist (map every finding to a rule number)

1. **Rule 1** — Is every custom widget under `lib/widgets/ui/<name>/` or `lib/widgets/shared/<name>/`, flat (no extra nesting), and in the right bucket (thin Flutter-primitive wrapper → `ui/`; cross-module reusable widget → `shared/`)?
2. **Rule 2** — Does each `lib/modules/*` folder only contain `components/`, `constants/`, `converters/`, `providers/`, `services/`, `types/`, `utils/`, and `{module_name}_page.dart`? Flag empty/unused subfolders and flag business logic sitting loose outside these.
3. **Rule 3** — Does anything under `lib/widgets/shared/` (or `lib/shared/components` if that path is used) make an HTTP/API call, import an API client, or hold network state? Flag it.
4. **Rule 4** — Are domain/system texts (API status strings, business status values, table columns, system messages) hardcoded as string literals instead of constants/enums? Simple UI copy is fine as-is — don't flag that.
5. **Rule 5** — In every touched file, is import order SDK → external packages → `package:mp3_app/...` → relative, with exactly one blank line between groups?
6. **Rule 6** — Any hex color literal (`Color(0xFF...)`, `#RRGGBB` strings, etc.) inside a widget instead of `AppColors.*` from `lib/core/constants/design_tokens.dart`?
7. **Rule 7** — Any `//` or `/* */` comments in source files? Flag every occurrence (doc comments on public APIs count too unless the user says otherwise).
8. **Rule 8** — Inside `lib/core/**`, any `package:mp3_app/core/...` import instead of a relative import? Any `lib/core/**` file importing something from `lib/modules/**`?
9. **Rule 9** — Any non-trivial data transformation/business logic written inline inside a converter, service, or widget instead of a `utils/` function?
10. **Rule 10** — Any `class`/`enum`/`typedef` declared inline inside a service, widget, or converter file instead of living in `types/` (plain value objects) or `models/` (serializable DTOs, with `lib/core/models/` for cross-module ones)?
11. **Rule 11** — Does any `*_page.dart` (UI layer) import or call `lib/core/api/**` directly instead of going through a `services/` layer? Does any service file build widgets or touch `BuildContext`?

## Output

Report findings grouped by rule number, each with:
- File path and line number
- One-sentence description of the violation
- The concrete fix (what to move/rename/extract)

If nothing violates a rule, omit that rule from the output — don't list "Rule X: OK" for every rule. If the user asked you to also fix violations (not just report them), apply the fixes after reporting, respecting all other AGENTS.md rules in the fix itself.
