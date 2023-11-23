import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';
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
  GlobalKey<DSKAppSidebarsState> keyAppStructure = GlobalKey();
  String _section = "Introduction";
  List<String> options = [
    "Introduction",
    "Buttons",
    "Progress",
    "Fields",
    "Pickers",
    "Dialogs",
    "Utils",
  ];

  void toggleLeftSidebar() {
    final DSKAppSidebarsState? state = keyAppStructure.currentState;
    if (state != null) {
      state.setSidebarLeftVisibility(!state.isSidebarLeftVisible);
    }
  }

  void toggleRightSidebar() {
    final DSKAppSidebarsState? state = keyAppStructure.currentState;
    if (state != null) {
      state.setSidebarRightVisibility(!state.isSidebarRightVisible);
    }
  }

  void _changeSection(int index, String name) {
    setState(() {
      _section = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    DSKThemeManager themeManager = DSKThemeManager();

    Widget centralWidget;
    switch (_section) {
      case "Introduction":
        // ignore: prefer_const_constructors
        centralWidget = LayoutIntroduction();
        break;
      case "Buttons":
        // ignore: prefer_const_constructors
        centralWidget = LayoutButtons();
        break;
      case "Progress":
        // ignore: prefer_const_constructors
        centralWidget = LayoutProgress();
        break;
      case "Fields":
        // ignore: prefer_const_constructors
        centralWidget = LayoutFields();
        break;
      case "Pickers":
        // ignore: prefer_const_constructors
        centralWidget = LayoutPickers();
        break;
      case "Dialogs":
        // ignore: prefer_const_constructors
        centralWidget = LayoutDialogs();
        break;
      case "Utils":
        // ignore: prefer_const_constructors
        centralWidget = LayoutUtils();
        break;
      default:
        centralWidget = Container(); // Un contenidor buit com a cas per defecte
    }

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
                      toggleLeftSidebar();
                    }),
                Text(_section),
                DSKButtonIcon(
                    icon: CupertinoIcons.sidebar_left,
                    onPressed: () {
                      toggleRightSidebar();
                    }),
              ]),
        ),
        child: DSKAppSidebars(
          key: keyAppStructure,
          sidebarLeftIsResizable: true,
          sidebarLeftDefaultsVisible: true,
          sidebarRightDefaultsVisible: false,
          sidebarLeft:
              LayoutSidebarLeft(options: options, onSelect: _changeSection),
          sidebarRight: const LayoutSidebarRight(),
          central: centralWidget,
        ));
  }
}
