import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutUtils extends StatefulWidget {
  const LayoutUtils({super.key});

  @override
  State<LayoutUtils> createState() => _LayoutUtilsState();
}

class _LayoutUtilsState extends State<LayoutUtils> {
  @override
  Widget build(BuildContext context) {

    DSKAppInheritedWidget.of(context)!.changeNotifier; // React to theme changes

    Widget line = Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: DSKColors.text,
            width: 1.0,
          ),
        ),
      ),
      child: Container(),
    );

    return Container(
        color: DSKColors.background,
        child: ListView(children: [
          const SizedBox(height: 8),
          const Padding(
              padding: EdgeInsets.all(8), child: Text('DSKUtilsDisclosure:')),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: DSKUtilDisclosure(
                  title:
                      const Text('Show/Hide', style: TextStyle(fontSize: 14)),
                  child: SizedBox(
                      width: 300,
                      height: 150,
                      child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: DSKColors.backgroundSecondary1,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Text('Expandible disclosure'))),
                  onChanged: (bool value) {
                    setState(() {});
                  }),
            ),
            line,
          ]),
          const SizedBox(height: 50),
        ]));
  }
}
