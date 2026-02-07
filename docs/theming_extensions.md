# Theming Extension Points

`CDKApp` publishes immutable tokens through `ThemeExtension`:

- `CDKThemeColorTokens`: semantic colors used by widgets.
- `CDKThemeRuntimeTokens`: runtime state (`isLight`, `isAppFocused`, appearance, accent name).
- `CDKThemeRadiusTokens`: shared corner radii.
- `CDKThemeSpacingTokens`: shared spacing scale.
- `CDKThemeElevationTokens`: shared shadow/focus-ring magnitudes.

## Reading Tokens

```dart
final colors = Theme.of(context).extension<CDKThemeColorTokens>()!;
final runtime = Theme.of(context).extension<CDKThemeRuntimeTokens>()!;
```

## Compatibility

`CDKThemeNotifier` remains available for backward compatibility, but new widgets should read `ThemeExtension` tokens first.
