import 'package:example/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutIntroduction extends StatefulWidget {
  final Function? toogleLeftSidebar;
  const LayoutIntroduction({super.key, this.toogleLeftSidebar});

  @override
  State<LayoutIntroduction> createState() => _LayoutIntroductionState();
}

class _LayoutIntroductionState extends State<LayoutIntroduction> {
  @override
  Widget build(BuildContext context) {
    String selectedRadio = DSKThemeManager.appearanceConfig;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: DSKColors.backgroundSecondary0.withOpacity(0.5),
          middle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                DSKButtonIcon(
                    icon: CupertinoIcons.sidebar_left,
                    onPressed: () {
                      widget.toogleLeftSidebar!();
                    }),
                const Text(""),
                const SizedBox(width: 24, height: 8),
              ]),
        ),
        child: Container(
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
              Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 8),
                  child: Row(
                      mainAxisSize: MainAxisSize.min, // Això és clau
                      children: [
                        const Text("Theme color: ",
                            style: TextStyle(fontSize: 14)),
                        DSKButtonsColors(
                          colors: DSKColors.systemColors,
                          selectedColor: DSKThemeManager.themeColor,
                          onColorChanged: (String colorName) {
                            App.of(context)?.setActiveColor(colorName);
                          },
                        )
                      ])),
              Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DSKButtonRadio(
                          label: "Light theme",
                          isSelected: selectedRadio == "light",
                          onSelected: (bool? isSelected) {
                            setState(() {
                              selectedRadio = "light";
                              App.of(context)?.setAppearance("light");
                            });
                          },
                        ),
                      ])),
              Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DSKButtonRadio(
                          label: "Dark theme",
                          isSelected: selectedRadio == "dark",
                          onSelected: (bool? isSelected) {
                            setState(() {
                              selectedRadio = "dark";
                              App.of(context)?.setAppearance("dark");
                            });
                          },
                        ),
                      ])),
              Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DSKButtonRadio(
                          label: "System theme",
                          isSelected: selectedRadio == "system",
                          onSelected: (bool? isSelected) {
                            setState(() {
                              selectedRadio = "system";
                              App.of(context)?.setAppearance("system");
                            });
                          },
                        ),
                      ])),
              const SizedBox(height: 50),
            ])));
  }
}
