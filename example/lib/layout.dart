import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/flutter_cupertino_desktop_kit.dart';
import 'layout_sidebar_left.dart';
import 'layout_sidebar_right.dart';
import 'layout_buttons.dart';
import 'layout_dialogs.dart';
import 'layout_fields.dart';
import 'layout_pickers.dart';
import 'layout_progress.dart';
import 'layout_introduction.dart';
import 'layout_utils.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  bool isSidebarLeftVisible = true;
  final CDKAppSidebarsController sidebarsController =
      CDKAppSidebarsController();
  String _section = "Introduction";
  List<List<dynamic>> options = [
    ["Introduction", const LayoutIntroduction()],
    ["Buttons", const LayoutButtons()],
    ["Progress", const LayoutProgress()],
    ["Fields", const LayoutFields()],
    ["Pickers", const LayoutPickers()],
    ["Dialogs", const LayoutDialogs()],
    ["Utils", const LayoutUtils()],
  ];

  void toggleLeftSidebar() {
    sidebarsController
        .setSidebarLeftVisibility(!sidebarsController.isSidebarLeftVisible);
  }

  void toggleRightSidebar() {
    sidebarsController
        .setSidebarRightVisibility(!sidebarsController.isSidebarRightVisible);
  }

  void _changeSection(int index, String name) {
    setState(() {
      _section = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    Widget centralWidget =
        options.firstWhere((element) => element[0] == _section)[1];

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: theme.backgroundSecondary0.withValues(alpha: 0.5),
          middle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CDKButtonIcon(
                    icon: CupertinoIcons.sidebar_left,
                    onPressed: () {
                      toggleLeftSidebar();
                    }),
                Text(_section),
                CDKButtonIcon(
                  icon: CupertinoIcons.sidebar_right,
                  onPressed: () {
                    toggleRightSidebar();
                  },
                ),
              ]),
        ),
        child: CDKAppSidebars(
          controller: sidebarsController,
          sidebarLeftIsResizable: true,
          sidebarLeftDefaultsVisible: true,
          sidebarRightDefaultsVisible: false,
          sidebarLeft: LayoutSidebarLeft(
              options: options.map((pair) => pair[0] as String).toList(),
              onSelect: _changeSection),
          sidebarRight: const LayoutSidebarRight(),
          central: centralWidget,
        ));
  }
}
