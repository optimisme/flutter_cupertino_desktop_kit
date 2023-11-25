import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/cx_widgets.dart';
import 'layout.dart';

// Main application widget
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

// Main application state
class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const CXApp(
      defaultAppearance: "system", // system, light, dark
      defaultColor:
          "systemBlue", // systemBlue, systemPurple, systemPink, systemRed, systemOrange, systemYellow, systemGreen, systemGray
      child: Layout(),
    );
  }
}
