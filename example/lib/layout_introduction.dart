import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutIntroduction extends StatefulWidget {
  const LayoutIntroduction({super.key});

  @override
  State<LayoutIntroduction> createState() => _LayoutIntroductionState();
}

class _LayoutIntroductionState extends State<LayoutIntroduction> {
  @override
  Widget build(BuildContext context) {
    return Container(
            color: DSKColors.background,
            child: ListView(children: [
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Text('Introduction:',
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w200))),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Text(
                      'This project defines Flutter Widgets for Desktop, with a macOS-style aesthetic, using Cupertino as a foundation.')),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Text(
                      'The goal is to be able to develop applications for all desktop systems, including the web, filling in the gaps in the Cupertino theme.')),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Text('The code for the project can be found at:')),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
                                      color: DSKColors.accent,
                                    )))
                          ]))),
              const SizedBox(height: 50),
            ]));
  }
}
