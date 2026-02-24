import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// Legacy notifier bridge. New widgets should prefer ThemeExtension tokens.
class CDKThemeNotifier extends InheritedNotifier<CDKTheme> {
  const CDKThemeNotifier({
    super.key,
    required super.child,
    required CDKTheme changeNotifier,
  }) : super(notifier: changeNotifier);

  CDKTheme get changeNotifier => notifier!;

  static CDKThemeColorTokens colorTokensOf(BuildContext context) {
    final extension =
        material.Theme.of(context).extension<CDKThemeColorTokens>();
    if (extension != null) {
      return extension;
    }
    return of(context)?.changeNotifier.colorTokens ??
        const CDKThemeColorTokens(
          background: CupertinoColors.white,
          backgroundSecondary0: CupertinoColors.white,
          backgroundSecondary1: CupertinoColors.systemGrey5,
          backgroundSecondary2: Color.fromRGBO(245, 245, 245, 1),
          colorText: CupertinoColors.black,
          colorTextSecondary: CupertinoColors.white,
          accent50: Color.fromRGBO(131, 188, 252, 1.0),
          accent100: Color.fromRGBO(81, 162, 251, 1.0),
          accent200: Color.fromRGBO(56, 149, 250, 1.0),
          accent300: Color.fromRGBO(31, 135, 250, 1.0),
          accent: CupertinoColors.systemBlue,
          accent500: Color.fromRGBO(5, 110, 224, 1.0),
          accent600: Color.fromRGBO(5, 98, 199, 1.0),
        );
  }

  static CDKThemeRuntimeTokens runtimeTokensOf(BuildContext context) {
    final extension =
        material.Theme.of(context).extension<CDKThemeRuntimeTokens>();
    if (extension != null) {
      return extension;
    }
    return of(context)?.changeNotifier.runtimeTokens ??
        const CDKThemeRuntimeTokens(
          isLight: true,
          isAppFocused: true,
          appearanceConfig: CDKThemeAppearance.system,
          accentName: 'systemBlue',
        );
  }

  static CDKThemeRadiusTokens radiusTokensOf(BuildContext context) {
    return material.Theme.of(context).extension<CDKThemeRadiusTokens>() ??
        CDKTheme.radiusTokens;
  }

  static CDKThemeSpacingTokens spacingTokensOf(BuildContext context) {
    return material.Theme.of(context).extension<CDKThemeSpacingTokens>() ??
        CDKTheme.spacingTokens;
  }

  static CDKThemeElevationTokens elevationTokensOf(BuildContext context) {
    return material.Theme.of(context).extension<CDKThemeElevationTokens>() ??
        CDKTheme.elevationTokens;
  }

  static CDKThemeTypographyTokens typographyTokensOf(BuildContext context) {
    return material.Theme.of(context).extension<CDKThemeTypographyTokens>() ??
        CDKTheme.typographyTokens;
  }

  static CDKThemeNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CDKThemeNotifier>();
  }
}
