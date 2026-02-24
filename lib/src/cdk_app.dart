import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_util_shader_grid.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// `CDKApp` serves as the entry point for a customized Flutter application,
/// managing the theme and color of the app.
///
/// The initialization of appearance (`defaultAppearance`) and color (`defaultColor`)
/// can be set at creation, but these values can dynamically change and are not
/// preserved across redraws. This allows for greater flexibility and adaptability
/// of the app's theme according to user preferences and system conditions.
///
/// ```dart
/// CDKApp(
///   defaultAppearance: CDKThemeAppearance.light,
///   defaultColor: "systemBlue",
///   child: YourMainWidget(),
/// )
/// ```
///
/// This class also observes changes in the app lifecycle state and platform brightness,
/// updating the theme and colors as needed. It ensures that the appearance and colors
/// remain consistent and responsive to system settings and user interactions.
class CDKApp extends StatefulWidget {
  final CDKThemeAppearance defaultAppearance;
  final String defaultColor;
  final Widget child;
  const CDKApp(
      {super.key,
      this.defaultAppearance = CDKThemeAppearance.system,
      this.defaultColor = "systemBlue",
      required this.child});

  @override
  State<CDKApp> createState() => _CDKAppState();
}

// Main application state
class _CDKAppState extends State<CDKApp> with WidgetsBindingObserver {
  late final CDKTheme _themeManager = CDKTheme();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    CDKUtilShaderGrid.initShaders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _themeManager.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    bool appHasFocus = (state == AppLifecycleState.resumed);
    _themeManager.setAppFocus(appHasFocus);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (_themeManager.appearanceConfig == CDKThemeAppearance.system) {
      _themeManager.setAppearanceConfig();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeManager,
      builder: (context, _) {
        final List<material.ThemeExtension<dynamic>> extensions = [
          _themeManager.colorTokens,
          _themeManager.runtimeTokens,
          CDKTheme.radiusTokens,
          CDKTheme.spacingTokens,
          CDKTheme.elevationTokens,
          CDKTheme.typographyTokens,
        ];

        return CDKThemeNotifier(
            changeNotifier: _themeManager,
            child: CupertinoApp(
              debugShowCheckedModeBanner: false,
              theme: _themeManager.getThemeData(
                  widget.defaultAppearance, widget.defaultColor),
              builder: (context, child) {
                final baseTheme = material.Theme.of(context);
                final baseExtensions =
                    baseTheme.extensions.values.toList(growable: true);
                baseExtensions.addAll(extensions);

                return material.Theme(
                  data: baseTheme.copyWith(
                    extensions: baseExtensions,
                  ),
                  child: FocusTraversalGroup(
                    policy: ReadingOrderTraversalPolicy(),
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },
              home: widget.child,
            ));
      },
    );
  }
}
