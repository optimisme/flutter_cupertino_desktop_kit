import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';

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
///   defaultAppearance: "light",
///   defaultColor: "systemBlue",
///   child: YourMainWidget(),
/// )
/// ```
///
/// This class also observes changes in the app lifecycle state and platform brightness,
/// updating the theme and colors as needed. It ensures that the appearance and colors
/// remain consistent and responsive to system settings and user interactions.
class CDKApp extends StatefulWidget {
  final String defaultAppearance;
  final String defaultColor;
  final Widget child;
  const CDKApp(
      {super.key,
      this.defaultAppearance = "system",
      this.defaultColor = "systemBlue",
      required this.child});

  @override
  CDKAppState createState() => CDKAppState();
}

// Main application state
class CDKAppState extends State<CDKApp> with WidgetsBindingObserver {
  late final CDKTheme _themeManager = CDKTheme();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeManager.addListener(() {
      setState(() {});
    });
    CDKUtilShaderGrid.initShaders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
    if (_themeManager.appearanceConfig == "system") {
      _themeManager.setAppearanceConfig(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CDKThemeNotifier(
        changeNotifier: _themeManager,
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: _themeManager.getThemeData(
              context, widget.defaultAppearance, widget.defaultColor),
          home: widget.child,
        ));
  }
}
