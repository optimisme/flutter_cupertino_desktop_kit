import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutButtons extends StatefulWidget {
  final Function? toogleLeftSidebar;
  const LayoutButtons({super.key, this.toogleLeftSidebar});

  @override
  State<LayoutButtons> createState() => _LayoutButtonsState();
}

class _LayoutButtonsState extends State<LayoutButtons> {
  bool isSwitched = false;
  int selectedRadio = 1;

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
                const Text("Buttons"),
                const SizedBox(width: 24, height: 8),
              ]),
        ),
        child: Container(
            color: DSKColors.background,
            child: ListView(children: [
              const SizedBox(height: 8),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKButton:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.action,
                      isLarge: true,
                      onPressed: () {},
                      child: const Text('Action large'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.action,
                      isLarge: false,
                      onPressed: () {},
                      child: const Text('Action'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.destructive,
                      isLarge: false,
                      onPressed: () {},
                      child: const Text('Destructive'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {},
                      child: const Text('Normal'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      onPressed: () {},
                      child: Icon(CupertinoIcons.add,
                          color: DSKColors.text, size: 14),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.action,
                      isLarge: false,
                      enabled: false,
                      onPressed: () {},
                      child: const Text('Action disabled'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.destructive,
                      isLarge: false,
                      enabled: false,
                      onPressed: () {},
                      child: const Text('Destructive disabled'),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButton(
                      style: DSKButtonStyle.normal,
                      isLarge: false,
                      enabled: false,
                      onPressed: () {},
                      child: const Text('Normal disabled'),
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKButtonHelp:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonHelp(size: 24, onPressed: () {})),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKButtonIcon:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonIcon(
                        size: 28, icon: CupertinoIcons.back, onPressed: () {})),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonIcon(
                        size: 28, isCircle: true, onPressed: () {})),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonIcon(
                        size: 28,
                        icon: CupertinoIcons.cloud_fill,
                        isCircle: true,
                        isSelected: true,
                        onPressed: () {})),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKButtonSwitch:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonSwitch(
                      value: isSwitched,
                      onChanged: (bool newValue) {
                        setState(() {
                          isSwitched = newValue;
                        });
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonSwitch(
                      value: isSwitched,
                      size: 12,
                      onChanged: (bool newValue) {
                        setState(() {
                          isSwitched = newValue;
                        });
                      },
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('DSKButtonCheckbox:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonCheckBox(
                      value: isSwitched,
                      onChanged: (bool? value) {
                        setState(() {
                          isSwitched = value!;
                        });
                      },
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('DSKButtonDisclosure:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonDisclosure(
                      value: isSwitched,
                      onChanged: (bool newValue) {
                        setState(() {
                          isSwitched = newValue;
                        });
                      },
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKButtonRadio:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonRadio(
                      label: "Me",
                      isSelected: selectedRadio == 1,
                      onSelected: (bool? isSelected) {
                        setState(() {
                          selectedRadio = 1;
                        });
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonRadio(
                      label: "You",
                      isSelected: selectedRadio == 2,
                      onSelected: (bool? isSelected) {
                        setState(() {
                          selectedRadio = 2;
                        });
                      },
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKButtonSelect:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonSelect(
                      options: const ['One', 'Two', 'Three'],
                      defaultIndex: 0,
                      onSelect: (int index, String value) {
                        // ignore: avoid_print
                        print("ButtonSelect: $index $value");
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonSelect(
                      options: const ['No', 'Yes', 'Maybe', 'Who knows?'],
                      defaultIndex: 1,
                      isFlat: true,
                      isTranslucent: true,
                      onSelect: (int index, String value) {
                        // ignore: avoid_print
                        print("ButtonSelect: $index $value");
                      },
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('DSKButtonCheckList:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: DSKButtonCheckList(
                      options: const ['Car', 'Motorbike', 'Plane'],
                      defaultIndex: 2,
                      onSelect: (int index, String value) {
                        // ignore: avoid_print
                        print("Checkmark: $index $value");
                        setState(() {});
                      },
                    )),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('DSKButtonsSegmented:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        width: 300,
                        child: DSKButtonsSegmented(
                          options: const [
                            Text('Car'),
                            Text('Motorbike'),
                            Icon(CupertinoIcons.airplane)
                          ],
                          defaultIndex: 1,
                          onSelect: (int index) {
                            // ignore: avoid_print
                            print("Segmented: $index");
                          },
                        ))),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        width: 250,
                        child: DSKButtonsSegmented(
                          options: const [
                            Icon(CupertinoIcons.ant),
                            Text('Flower'),
                            Text('Grass'),
                            Text('Bush')
                          ],
                          isAccent: true,
                          defaultIndex: 1,
                          onSelect: (int index) {
                            // ignore: avoid_print
                            print("Segmented: $index");
                          },
                        ))),
              ]),
              const Padding(
                  padding: EdgeInsets.all(8), child: Text('DSKButtonsBar:')),
              Wrap(children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        width: 300,
                        child: DSKButtonsBar(
                          options: const [
                            {
                              "widget": Icon(CupertinoIcons.text_alignleft),
                              "value": true
                            },
                            {
                              "widget": Icon(CupertinoIcons.text_aligncenter),
                              "value": false
                            },
                            {
                              "widget": Icon(CupertinoIcons.text_alignright),
                              "value": false
                            },
                            {"widget": Text("Justify"), "value": false}
                          ],
                          onChanged: (List<bool> options) {
                            // ignore: avoid_print
                            print("Segmented: $options");
                          },
                        ))),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                        width: 250,
                        child: DSKButtonsBar(
                          options: const [
                            {
                              "widget": Icon(CupertinoIcons.bold),
                              "value": false
                            },
                            {
                              "widget": Icon(CupertinoIcons.italic),
                              "value": false
                            },
                            {
                              "widget": Icon(CupertinoIcons.underline),
                              "value": true
                            },
                            {
                              "widget": Icon(CupertinoIcons.strikethrough),
                              "value": false
                            }
                          ],
                          allowsMultipleSelection: true,
                          onChanged: (List<bool> options) {
                            // ignore: avoid_print
                            print("Segmented: $options");
                          },
                        ))),
              ]),
              const SizedBox(height: 50),
            ])));
  }
}
