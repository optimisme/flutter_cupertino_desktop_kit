import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// A class representing the theme configuration for a Flutter application.
///
/// The `CDKTheme` class manages runtime theme state (appearance, accent, focus)
/// and derives immutable token sets published through `ThemeExtension`.
///
/// Static colors are predefined and constant, while runtime colors are derived
/// according to the application's theme and focus state.
///
/// ```dart
/// CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;
/// Color backgroundColor = theme.isLight ? CDKTheme.white : CDKTheme.black;
/// ```
///
/// ![CDKTheme Example](URL_of_the_image)
///
/// This class also provides a set of predefined static colors for convenience.
enum CDKThemeAppearance {
  system,
  light,
  dark,
}

@immutable
class CDKThemeColorTokens extends material.ThemeExtension<CDKThemeColorTokens> {
  const CDKThemeColorTokens({
    required this.background,
    required this.backgroundSecondary0,
    required this.backgroundSecondary1,
    required this.backgroundSecondary2,
    required this.colorText,
    required this.colorTextSecondary,
    required this.accent50,
    required this.accent100,
    required this.accent200,
    required this.accent300,
    required this.accent,
    required this.accent500,
    required this.accent600,
  });

  final Color background;
  final Color backgroundSecondary0;
  final Color backgroundSecondary1;
  final Color backgroundSecondary2;
  final Color colorText;
  final Color colorTextSecondary;
  final Color accent50;
  final Color accent100;
  final Color accent200;
  final Color accent300;
  final Color accent;
  final Color accent500;
  final Color accent600;

  @override
  CDKThemeColorTokens copyWith({
    Color? background,
    Color? backgroundSecondary0,
    Color? backgroundSecondary1,
    Color? backgroundSecondary2,
    Color? colorText,
    Color? colorTextSecondary,
    Color? accent50,
    Color? accent100,
    Color? accent200,
    Color? accent300,
    Color? accent,
    Color? accent500,
    Color? accent600,
  }) {
    return CDKThemeColorTokens(
      background: background ?? this.background,
      backgroundSecondary0: backgroundSecondary0 ?? this.backgroundSecondary0,
      backgroundSecondary1: backgroundSecondary1 ?? this.backgroundSecondary1,
      backgroundSecondary2: backgroundSecondary2 ?? this.backgroundSecondary2,
      colorText: colorText ?? this.colorText,
      colorTextSecondary: colorTextSecondary ?? this.colorTextSecondary,
      accent50: accent50 ?? this.accent50,
      accent100: accent100 ?? this.accent100,
      accent200: accent200 ?? this.accent200,
      accent300: accent300 ?? this.accent300,
      accent: accent ?? this.accent,
      accent500: accent500 ?? this.accent500,
      accent600: accent600 ?? this.accent600,
    );
  }

  @override
  CDKThemeColorTokens lerp(
      covariant material.ThemeExtension<CDKThemeColorTokens>? other, double t) {
    if (other is! CDKThemeColorTokens) {
      return this;
    }

    return CDKThemeColorTokens(
      background: Color.lerp(background, other.background, t) ?? background,
      backgroundSecondary0:
          Color.lerp(backgroundSecondary0, other.backgroundSecondary0, t) ??
              backgroundSecondary0,
      backgroundSecondary1:
          Color.lerp(backgroundSecondary1, other.backgroundSecondary1, t) ??
              backgroundSecondary1,
      backgroundSecondary2:
          Color.lerp(backgroundSecondary2, other.backgroundSecondary2, t) ??
              backgroundSecondary2,
      colorText: Color.lerp(colorText, other.colorText, t) ?? colorText,
      colorTextSecondary:
          Color.lerp(colorTextSecondary, other.colorTextSecondary, t) ??
              colorTextSecondary,
      accent50: Color.lerp(accent50, other.accent50, t) ?? accent50,
      accent100: Color.lerp(accent100, other.accent100, t) ?? accent100,
      accent200: Color.lerp(accent200, other.accent200, t) ?? accent200,
      accent300: Color.lerp(accent300, other.accent300, t) ?? accent300,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accent500: Color.lerp(accent500, other.accent500, t) ?? accent500,
      accent600: Color.lerp(accent600, other.accent600, t) ?? accent600,
    );
  }
}

@immutable
class CDKThemeRadiusTokens
    extends material.ThemeExtension<CDKThemeRadiusTokens> {
  const CDKThemeRadiusTokens({
    this.small = 4.0,
    this.medium = 6.0,
    this.large = 8.0,
    this.rounded = 25.0,
  });

  final double small;
  final double medium;
  final double large;
  final double rounded;

  @override
  CDKThemeRadiusTokens copyWith({
    double? small,
    double? medium,
    double? large,
    double? rounded,
  }) {
    return CDKThemeRadiusTokens(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      rounded: rounded ?? this.rounded,
    );
  }

  @override
  CDKThemeRadiusTokens lerp(
      covariant material.ThemeExtension<CDKThemeRadiusTokens>? other,
      double t) {
    if (other is! CDKThemeRadiusTokens) {
      return this;
    }
    return CDKThemeRadiusTokens(
      small: ui.lerpDouble(small, other.small, t) ?? small,
      medium: ui.lerpDouble(medium, other.medium, t) ?? medium,
      large: ui.lerpDouble(large, other.large, t) ?? large,
      rounded: ui.lerpDouble(rounded, other.rounded, t) ?? rounded,
    );
  }
}

@immutable
class CDKThemeSpacingTokens
    extends material.ThemeExtension<CDKThemeSpacingTokens> {
  const CDKThemeSpacingTokens({
    this.xs = 2.0,
    this.sm = 4.0,
    this.md = 8.0,
    this.lg = 10.0,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;

  @override
  CDKThemeSpacingTokens copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
  }) {
    return CDKThemeSpacingTokens(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
    );
  }

  @override
  CDKThemeSpacingTokens lerp(
      covariant material.ThemeExtension<CDKThemeSpacingTokens>? other,
      double t) {
    if (other is! CDKThemeSpacingTokens) {
      return this;
    }
    return CDKThemeSpacingTokens(
      xs: ui.lerpDouble(xs, other.xs, t) ?? xs,
      sm: ui.lerpDouble(sm, other.sm, t) ?? sm,
      md: ui.lerpDouble(md, other.md, t) ?? md,
      lg: ui.lerpDouble(lg, other.lg, t) ?? lg,
    );
  }
}

@immutable
class CDKThemeElevationTokens
    extends material.ThemeExtension<CDKThemeElevationTokens> {
  const CDKThemeElevationTokens({
    this.softShadowBlur = 1.0,
    this.softShadowYOffset = 1.0,
    this.focusRingSpread = 1.0,
    this.focusRingBlur = 0.5,
  });

  final double softShadowBlur;
  final double softShadowYOffset;
  final double focusRingSpread;
  final double focusRingBlur;

  @override
  CDKThemeElevationTokens copyWith({
    double? softShadowBlur,
    double? softShadowYOffset,
    double? focusRingSpread,
    double? focusRingBlur,
  }) {
    return CDKThemeElevationTokens(
      softShadowBlur: softShadowBlur ?? this.softShadowBlur,
      softShadowYOffset: softShadowYOffset ?? this.softShadowYOffset,
      focusRingSpread: focusRingSpread ?? this.focusRingSpread,
      focusRingBlur: focusRingBlur ?? this.focusRingBlur,
    );
  }

  @override
  CDKThemeElevationTokens lerp(
      covariant material.ThemeExtension<CDKThemeElevationTokens>? other,
      double t) {
    if (other is! CDKThemeElevationTokens) {
      return this;
    }
    return CDKThemeElevationTokens(
      softShadowBlur: ui.lerpDouble(softShadowBlur, other.softShadowBlur, t) ??
          softShadowBlur,
      softShadowYOffset:
          ui.lerpDouble(softShadowYOffset, other.softShadowYOffset, t) ??
              softShadowYOffset,
      focusRingSpread:
          ui.lerpDouble(focusRingSpread, other.focusRingSpread, t) ??
              focusRingSpread,
      focusRingBlur:
          ui.lerpDouble(focusRingBlur, other.focusRingBlur, t) ?? focusRingBlur,
    );
  }
}

@immutable
class CDKThemeRuntimeTokens
    extends material.ThemeExtension<CDKThemeRuntimeTokens> {
  const CDKThemeRuntimeTokens({
    required this.isLight,
    required this.isAppFocused,
    required this.appearanceConfig,
    required this.accentName,
  });

  final bool isLight;
  final bool isAppFocused;
  final CDKThemeAppearance appearanceConfig;
  final String accentName;

  @override
  CDKThemeRuntimeTokens copyWith({
    bool? isLight,
    bool? isAppFocused,
    CDKThemeAppearance? appearanceConfig,
    String? accentName,
  }) {
    return CDKThemeRuntimeTokens(
      isLight: isLight ?? this.isLight,
      isAppFocused: isAppFocused ?? this.isAppFocused,
      appearanceConfig: appearanceConfig ?? this.appearanceConfig,
      accentName: accentName ?? this.accentName,
    );
  }

  @override
  CDKThemeRuntimeTokens lerp(
      covariant material.ThemeExtension<CDKThemeRuntimeTokens>? other,
      double t) {
    if (other is! CDKThemeRuntimeTokens) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}

class CDKTheme extends ChangeNotifier {
  // Appearance
  bool isLight = true;
  bool isAppFocused = true;
  CDKThemeAppearance appearanceConfig = CDKThemeAppearance.system;
  bool _isAppearanceConfigured = false;
  String colorConfig = "";

  // Abaliable theme colors
  static const Map<String, Color> systemColors = {
    "systemBlue": CupertinoColors.systemBlue,
    "systemPurple": CupertinoColors.systemPurple,
    "systemPink": CupertinoColors.systemPink,
    "systemRed": CupertinoColors.systemRed,
    "systemOrange": CupertinoColors.systemOrange,
    "systemYellow": CupertinoColors.systemYellow,
    "systemGreen": CupertinoColors.systemGreen,
    "systemGray": CupertinoColors.systemGrey,
  };

  // Constant predefined colors
  static const Color transparent = Color.fromRGBO(0, 0, 0, 0.0);
  static const Color white = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color black = Color.fromRGBO(0, 0, 0, 1.0);
  static const Color red = Color.fromRGBO(255, 0, 0, 1.0);
  static const Color green = Color.fromRGBO(0, 255, 0, 1.0);
  static const Color yellow = Color.fromRGBO(255, 255, 0, 1.0);
  static const Color cyan = Color.fromRGBO(0, 255, 255, 1.0);
  static const Color blue = Color.fromRGBO(0, 0, 255, 1.0);
  static const Color magenta = Color.fromRGBO(255, 0, 255, 1.0);

  static const Color grey50 = Color.fromRGBO(230, 230, 230, 1.0);
  static const Color grey60 = Color.fromRGBO(222, 222, 222, 1.0);
  static const Color grey70 = Color.fromRGBO(214, 214, 214, 1.0);
  static const Color grey80 = Color.fromRGBO(204, 204, 204, 1.0);
  static const Color grey90 = Color.fromRGBO(195, 195, 195, 1.0);
  static const Color grey100 = Color.fromRGBO(186, 186, 189, 1.0);
  static const Color grey200 = Color.fromRGBO(172, 172, 175, 1.0);
  static const Color grey300 = Color.fromRGBO(157, 157, 161, 1.0);
  static const Color grey = CupertinoColors.systemGrey;
  static const Color grey500 = Color.fromRGBO(127, 127, 133, 1.0);
  static const Color grey600 = Color.fromRGBO(112, 112, 112, 1.0);
  static const Color grey700 = Color.fromRGBO(99, 99, 103, 1.0);
  static const Color grey800 = Color.fromRGBO(85, 85, 85, 1.0);

  // Default colors for bacground and text (modified by dark/light mode)
  Color background = CupertinoColors.white;
  Color backgroundSecondary0 = CupertinoColors.white;
  Color backgroundSecondary1 = CupertinoColors.systemGrey5;
  Color backgroundSecondary2 = const Color.fromRGBO(245, 245, 245, 1);
  Color colorText = CupertinoColors.black;
  Color colorTextSecondary = CupertinoColors.white;

  // Modified programatically
  Color accent50 = const Color.fromRGBO(131, 188, 252, 1.0);
  Color accent100 = const Color.fromRGBO(81, 162, 251, 1.0);
  Color accent200 = const Color.fromRGBO(56, 149, 250, 1.0);
  Color accent300 = const Color.fromRGBO(31, 135, 250, 1.0);
  Color accent = CupertinoColors.systemBlue;
  Color accent500 = const Color.fromRGBO(5, 110, 224, 1.0);
  Color accent600 = const Color.fromRGBO(5, 98, 199, 1.0);

  static const CDKThemeRadiusTokens radiusTokens = CDKThemeRadiusTokens();
  static const CDKThemeSpacingTokens spacingTokens = CDKThemeSpacingTokens();
  static const CDKThemeElevationTokens elevationTokens =
      CDKThemeElevationTokens();

  CDKThemeColorTokens get colorTokens => CDKThemeColorTokens(
        background: background,
        backgroundSecondary0: backgroundSecondary0,
        backgroundSecondary1: backgroundSecondary1,
        backgroundSecondary2: backgroundSecondary2,
        colorText: colorText,
        colorTextSecondary: colorTextSecondary,
        accent50: accent50,
        accent100: accent100,
        accent200: accent200,
        accent300: accent300,
        accent: accent,
        accent500: accent500,
        accent600: accent600,
      );

  CDKThemeRuntimeTokens get runtimeTokens => CDKThemeRuntimeTokens(
        isLight: isLight,
        isAppFocused: isAppFocused,
        appearanceConfig: appearanceConfig,
        accentName: colorConfig,
      );

  CupertinoThemeData getThemeData(
      CDKThemeAppearance initialAppearance, String initialColor) {
    if (!_isAppearanceConfigured) {
      appearanceConfig = initialAppearance;
    }

    if (colorConfig == "") {
      colorConfig = initialColor;
    }

    // Set accent color
    initColors(colorConfig);
    CupertinoThemeData baseTheme = CupertinoThemeData(
        primaryColor: systemColors[colorConfig] ?? systemColors["systemBlue"]);

    final appearance =
        setAppearanceConfig(type: appearanceConfig, notify: false);

    // Set light/dark appearance colors and return theme
    if (appearance == CDKThemeAppearance.light) {
      return baseTheme.copyWith(
          brightness: Brightness.light, scaffoldBackgroundColor: background);
    } else {
      return baseTheme.copyWith(
          brightness: Brightness.dark, scaffoldBackgroundColor: background);
    }
  }

  void setAppFocus(bool value) {
    isAppFocused = value;
    notifyListeners();
  }

  CDKThemeAppearance setAppearanceConfig(
      {CDKThemeAppearance type = CDKThemeAppearance.system,
      bool notify = true}) {
    appearanceConfig = type;
    _isAppearanceConfigured = true;

    final appearance = appearanceConfig == CDKThemeAppearance.system
        ? _resolveSystemAppearance()
        : appearanceConfig;

    _setAppearance(appearance, notify: notify);

    return appearance;
  }

  CDKThemeAppearance _resolveSystemAppearance() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.light
        ? CDKThemeAppearance.light
        : CDKThemeAppearance.dark;
  }

  void _setAppearance(CDKThemeAppearance type, {bool notify = true}) {
    // only light or dark (no system)
    final appearance = type;

    // Set accent color
    initColors(colorConfig);

    // Set light/dark appearance colors and return theme
    if (appearance == CDKThemeAppearance.light) {
      isLight = true;
      background = CupertinoColors.white;
      backgroundSecondary0 = CupertinoColors.white;
      backgroundSecondary1 = CupertinoColors.systemGrey5;
      backgroundSecondary2 = const Color.fromRGBO(245, 245, 245, 1);
      colorText = CupertinoColors.black;
      colorTextSecondary = CupertinoColors.white;
    } else {
      isLight = false;
      background = const Color.fromARGB(255, 32, 32, 32);
      backgroundSecondary0 = const Color.fromRGBO(95, 95, 95, 1);
      backgroundSecondary1 = const Color.fromRGBO(55, 55, 55, 1);
      backgroundSecondary2 = const Color.fromRGBO(36, 36, 36, 1);
      colorText = CupertinoColors.white;
      colorTextSecondary = CupertinoColors.black;
    }

    if (notify) {
      notifyListeners();
    }
  }

  void setAccentColour(String name) {
    Color? color = systemColors[name];
    colorConfig = name;

    if (color == null) {
      color = systemColors["systemBlue"];
      colorConfig = "systemBlue";
    }

    initColors(colorConfig);
    notifyListeners();
  }

  void initColors(String themeColor) {
    final baseColor = systemColors[themeColor] ?? systemColors["systemBlue"]!;
    final color = adjustColor(baseColor, 0.95, 1);
    accent50 = adjustColor(color, 1, 1.5);
    accent100 = adjustColor(color, 1, 1.3);
    accent200 = adjustColor(color, 1, 1.2);
    accent300 = adjustColor(color, 1, 1.1);
    accent = color;
    accent500 = adjustColor(color, 1, 0.9);
    accent600 = adjustColor(color, 1, 0.8);
  }

  static Color adjustColor(
      Color color, double saturationFactor, double brightnessFactor) {
    HSLColor hsl = HSLColor.fromColor(color);
    HSLColor adjusted = HSLColor.fromAHSL(
      hsl.alpha,
      hsl.hue,
      (hsl.saturation * saturationFactor).clamp(0.0, 1.0),
      (hsl.lightness * brightnessFactor).clamp(0.0, 1.0),
    );
    return adjusted.toColor();
  }

  Color getSidebarColorText(bool isSelected, bool isAccent) {
    return isLight
        ? (isSelected
            ? (isAppFocused
                ? isAccent
                    ? CDKTheme.white
                    : CDKTheme.black
                : CDKTheme.grey)
            : (isAppFocused ? CDKTheme.black : CDKTheme.grey))
        : (isAppFocused ? CDKTheme.white : CDKTheme.grey);
  }

  Color getSidebarColorBackground(bool isSelected, bool isAccent) {
    return isLight
        ? (isSelected
            ? (isAppFocused
                ? isAccent
                    ? accent
                    : CDKTheme.grey80
                : CDKTheme.grey80)
            : CDKTheme.transparent)
        : (isSelected
            ? (isAppFocused
                ? isAccent
                    ? accent
                    : CDKTheme.grey700
                : CDKTheme.grey800)
            : CDKTheme.transparent);
  }
}
