import 'package:flutter/cupertino.dart';
import 'cx_theme.dart';
import 'cx_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// Main application widget
class CXApp extends StatefulWidget {
  final String defaultAppearance;
  final String defaultColor;
  final Widget child;
  const CXApp(
      {Key? key,
      this.defaultAppearance = "system",
      this.defaultColor = "systemBlue",
      required this.child})
      : super(key: key);

  @override
  CXAppState createState() => CXAppState();
}

// Main application state
class CXAppState extends State<CXApp> with WidgetsBindingObserver {
  late final CXTheme _themeManager = CXTheme();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeManager.addListener(() {
      setState(() {});
    });
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
    return CXThemeNotifier(
        changeNotifier: _themeManager,
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: _themeManager.getThemeData(
              context, widget.defaultAppearance, widget.defaultColor),
          home: widget.child,
        ));
  }
}
