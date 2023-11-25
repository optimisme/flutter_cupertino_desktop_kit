import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_desktop_cupertino/cx_widgets.dart';

class LayoutIntroduction extends StatefulWidget {
  const LayoutIntroduction({super.key});

  @override
  State<LayoutIntroduction> createState() => _LayoutIntroductionState();
}

class _LayoutIntroductionState extends State<LayoutIntroduction> {
  @override
  Widget build(BuildContext context) {
    CXTheme theme = CXThemeNotifier.of(context)!.changeNotifier;

    return ListView(children: [
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text('Introduction:',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w200))),
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text(
              'This project, Flutter Cupertino Desktop (CX), defines Flutter widgets for Desktop, providing a macOS-style aesthetic, built upon the foundation of Cupertino widgets.')),
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text(
              'The goal is to be able to develop applications for all desktop systems, including the web, filling in the gaps in the Cupertino theme.')),
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text('The code for the project can be found at:')),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: GestureDetector(
              onTapUp: (details) {
                launchUrl(Uri.parse('https://github.com/optimisme'));
              },
              child: Row(
                  mainAxisSize: MainAxisSize.min, // Això és clau
                  children: [
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text('https://github.com/optimisme',
                            style: TextStyle(
                              color: theme.accent,
                            )))
                  ]))),
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text(
              'The CX prefix aims to be unique within the Flutter ecosystem, while also being concise and evocative of ideas of graphics, experience, and expansion. In doing so, it embodies the spirit of the project.')),
      const SizedBox(height: 50),
    ]);
  }
}
