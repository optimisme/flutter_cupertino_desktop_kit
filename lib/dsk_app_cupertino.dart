import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';

// Main application widget
class DSKCupertinoApp extends StatefulWidget {
  final String? defaultAppearance;
  final Widget child;
  const DSKCupertinoApp({Key? key, this.defaultAppearance, required this.child})
      : super(key: key);

  @override
  DSKCupertinoAppState createState() => DSKCupertinoAppState();
}

// Main application state
class DSKCupertinoAppState extends State<DSKCupertinoApp>
    with WidgetsBindingObserver {
  late final DSKThemeManager _themeManager = DSKThemeManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeManager.addListener(() {
      setState(() {});
    });
    if (widget.defaultAppearance != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _themeManager.setAppearanceConfig(context, widget.defaultAppearance!);
      });
    }
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
    var brightness = MediaQuery.of(context).platformBrightness;
    if (_themeManager.appearanceConfig == "system") {
      _themeManager.setAppearanceConfig(
          context, brightness == Brightness.light ? "light" : "dark");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: _themeManager.getThemeData(context),
      home: widget.child,
    );
  }
}
