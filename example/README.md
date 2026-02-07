# CDK Example App

This example demonstrates `flutter_cupertino_desktop_kit` widget families and desktop interaction behaviors.

## Feature Map

- App shell and sidebars: `CDKApp`, `CDKAppSidebars`
- Buttons: action/normal/destructive/icon/toggle/select/radio/checkbox
- Dialogs: popover, arrowed popover, modal, draggable
- Fields: text, numeric, color hex, slider-backed numeric
- Pickers: segmented/bar/checklist/color/hsv/theme colors/sliders
- Progress indicators: bar and circular (determinate + indeterminate)

## Run Scenarios

1. `flutter pub get`
2. `flutter run -d macos` (or `linux`, `windows`, `chrome`)

## Recommended Manual Checks

1. Open dialogs and verify `Escape` closes the top-most dismissible dialog.
2. Verify outside-click behavior differs for popovers vs modals.
3. Tab through interactive controls and confirm traversal order is stable.
4. Toggle system appearance and accent from app controls and verify token-driven styling updates.
