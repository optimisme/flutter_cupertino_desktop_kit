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

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  bool isSwitched = false;
  int selectedRadio = 1;
  bool isSidebarLeftVisible = true;
  GlobalKey<DSKAppSidebarsState> keyAppStructure = GlobalKey();
  String _section = "Introduction";
  List<String> options = [
    "Introduction",
    "Buttons",
    "Progress",
    "Fields",
    "Pickers",
    "Dialogs"
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
    Widget centralWidget;

    switch (_section) {
      case "Introduction":
        centralWidget =
            LayoutIntroduction(toogleLeftSidebar: toggleLeftSidebar);
        break;
      case "Buttons":
        centralWidget = LayoutButtons(toogleLeftSidebar: toggleLeftSidebar);
        break;
      case "Dialogs":
        centralWidget = LayoutDialogs(
            toogleLeftSidebar: toggleLeftSidebar,
            toogleRightSidebar: toggleRightSidebar);
        break;
      case "Fields":
        centralWidget = LayoutFields(toogleLeftSidebar: toggleLeftSidebar);
        break;
      case "Pickers":
        centralWidget = LayoutPickers(toogleLeftSidebar: toggleLeftSidebar);
        break;
      case "Progress":
        centralWidget = LayoutProgress(toogleLeftSidebar: toggleLeftSidebar);
        break;
      default:
        centralWidget = Container(); // Un contenidor buit com a cas per defecte
    }

    return CupertinoPageScaffold(
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
