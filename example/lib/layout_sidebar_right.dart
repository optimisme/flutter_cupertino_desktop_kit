import 'package:flutter/cupertino.dart';

class LayoutSidebarRight extends StatefulWidget {
  const LayoutSidebarRight({super.key});

  @override
  State<LayoutSidebarRight> createState() => LayoutButtonsState();
}

class LayoutButtonsState extends State<LayoutSidebarRight> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: const [
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("Sidebar Right")])
    ]);
  }
}
