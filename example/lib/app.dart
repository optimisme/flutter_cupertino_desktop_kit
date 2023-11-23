import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';
import 'layout.dart';

// Main application widget
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

// Main application state
class AppState extends State<App> with WidgetsBindingObserver {
  late final DSKThemeManager _themeManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeManager = DSKThemeManager();
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DSKThemeManager>(
      create: (context) => _themeManager,
      child: Consumer<DSKThemeManager>(
        builder: (context, themeManager, child) {
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            theme: themeManager.getThemeData(context),
            home: Layout(),
          );
        },
      ),
    );
  }
}
