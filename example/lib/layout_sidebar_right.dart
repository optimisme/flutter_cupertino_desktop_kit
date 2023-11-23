import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';
import 'package:provider/provider.dart';

class LayoutSidebarRight extends StatefulWidget {
  const LayoutSidebarRight({super.key});

  @override
  State<LayoutSidebarRight> createState() => LayoutButtonsState();
}

class LayoutButtonsState extends State<LayoutSidebarRight> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final themeManager = Provider.of<DSKThemeManager>(context);

    return Container(
        color: DSKColors.backgroundSecondary1,
        child: ListView(children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Sidebar Right")])
        ]));
  }
}
