# API Review Checklist

Run this checklist before each release.

## Public API Surface

- Review `/Users/albertpalaciosjimenez/Documents/GitHub/flutter_cupertino_desktop_kit/lib/flutter_cupertino_desktop_kit.dart` for newly exported symbols.
- Confirm every exported symbol is intentionally supported for semver.
- Confirm no implementation-only `Painter`/`Clipper`/helper symbols are exported.

## Breaking-Change Audit

- Compare exported symbols with the previous release.
- Classify each removal or rename as a breaking change.
- Add migration notes for every breaking change in `CHANGELOG.md`.

## Naming Contract

- Public symbol names must start with `CDK`.
- Use `Controller` for instance lifecycle/state objects.
- Use `Manager` only for static/global orchestration APIs.

## Dialog Invariants

- `Escape` closes only the top-most dismissible dialog.
- Outside-click behavior matches dialog policy (popover/arrowed default dismiss, modal default non-dismiss).
- Opening and closing dialogs restores focus predictably.
