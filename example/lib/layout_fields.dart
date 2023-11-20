import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutFields extends StatefulWidget {
  final Function? toogleLeftSidebar;
  const LayoutFields({super.key, this.toogleLeftSidebar});

  @override
  State<LayoutFields> createState() => _LayoutFieldsState();
}

class _LayoutFieldsState extends State<LayoutFields> {
  @override
  Widget build(BuildContext context) {
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
                const Text("Fields"),
                const SizedBox(width: 24, height: 8),
              ]),
        ),
        child: Container(
            color: DSKColors.background,
            child: ListView(children: [
              const SizedBox(height: 8),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKFieldText:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        width: 100,
                        child: DSKFieldText(
                          textSize: 12,
                          isRounded: false,
                          onChanged: (value) {
                            // ignore: avoid_print
                            print("Value changed: $value");
                          },
                          onSubmitted: (value) {
                            // ignore: avoid_print
                            print("Value submitted: $value");
                          },
                          focusNode: FocusNode(),
                        ))),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKFieldNumeric:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        width: 100,
                        child: DSKFieldNumeric(
                          textSize: 12,
                          defaultValue: 5.0,

                          increment: 0.15,
                          onChanged: (double value) {
                            // ignore: avoid_print
                            print("Numeric A: $value");
                          },
                        ))),
              ]),
              const SizedBox(height: 50),
            ])));
  }
}
