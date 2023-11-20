import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_theme_manager.dart';
import 'layout.dart';

// Main application widget
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();

  static AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppState>();
  }
}

// Main application state
class AppState extends State<App> with WidgetsBindingObserver {
  String _appearanceBrightness = 'system';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    bool appHasFocus = state == AppLifecycleState.resumed;
    DSKThemeManager.setAppFocus(appHasFocus);
    setState(() {});
  }

  setActiveColor(String colorName) {
    DSKThemeManager.setAccentColour(colorName);
    setState(() {});
  }

  setAppearance(String type) {
    // light, dark, system
    _appearanceBrightness = type;
    setState(() {});
  }

  // Definir el contingut del widget 'App'
  @override
  Widget build(BuildContext context) {
    // Use 'Cupertino'
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: DSKThemeManager.getThemeData(context, _appearanceBrightness),
        // ignore: prefer_const_constructors
        home: Layout());
  }
}
