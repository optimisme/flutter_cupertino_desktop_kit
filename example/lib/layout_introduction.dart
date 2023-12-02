import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';

class LayoutIntroduction extends StatefulWidget {
  const LayoutIntroduction({super.key});

  @override
  State<LayoutIntroduction> createState() => _LayoutIntroductionState();
}

class _LayoutIntroductionState extends State<LayoutIntroduction> {
  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return ListView(children: [
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text('Introduction:',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w200))),
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text(
              'This project, Flutter Cupertino Desktop Kit (CDK), defines Flutter widgets for Desktop, providing a macOS-style aesthetic, built upon the foundation of Cupertino widgets.')),
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
                launchUrl(Uri.parse(
                    'https://github.com/optimisme/flutter_cupertino_desktop'));
              },
              child: Row(
                  mainAxisSize: MainAxisSize.min, // Això és clau
                  children: [
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text('CDK GitHub source code',
                            style: TextStyle(
                              color: theme.accent,
                            )))
                  ]))),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: GestureDetector(
              onTapUp: (details) {
                launchUrl(Uri.parse(
                    'https://optimisme.github.io/flutter_cupertino_desktop_kit/gh-pages/doc/'));
              },
              child: Row(
                  mainAxisSize: MainAxisSize.min, // Això és clau
                  children: [
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text('CDK GitHub documentation',
                            style: TextStyle(
                              color: theme.accent,
                            )))
                  ]))),
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text(
              'The CDK prefix strives to be distinctive within the Flutter ecosystem, while remaining concise and suggestive of Flutter Desktop and macOS AppKit. In doing so, it captures the essence of the project.')),
      const SizedBox(height: 50),
    ]);
  }
}
