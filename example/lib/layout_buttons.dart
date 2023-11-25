import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop/cx_widgets.dart';

class LayoutButtons extends StatefulWidget {
  const LayoutButtons({super.key});

  @override
  State<LayoutButtons> createState() => _LayoutButtonsState();
}

class _LayoutButtonsState extends State<LayoutButtons> {
  bool isSwitched = false;
  int selectedRadio = 1;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 8),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXButton:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.action,
              isLarge: true,
              onPressed: () {},
              child: const Text('Action large'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.action,
              onPressed: () {},
              child: const Text('Action'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.destructive,
              onPressed: () {},
              child: const Text('Destructive'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.normal,
              onPressed: () {},
              child: const Text('Normal'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.normal,
              onPressed: () {},
              child: const Icon(CupertinoIcons.bookmark),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.action,
              enabled: false,
              onPressed: () {},
              child: const Text('Action disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.destructive,
              enabled: false,
              onPressed: () {},
              child: const Text('Destructive disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.normal,
              enabled: false,
              onPressed: () {},
              child: const Text('Normal disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButton(
              style: CXButtonStyle.normal,
              enabled: false,
              onPressed: () {},
              child: const Icon(CupertinoIcons.bookmark),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXButtonHelp:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonHelp(size: 24, onPressed: () {})),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXButtonIcon:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonIcon(
                size: 28, icon: CupertinoIcons.back, onPressed: () {})),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonIcon(size: 28, isCircle: true, onPressed: () {})),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonIcon(
                size: 28,
                icon: CupertinoIcons.cloud_fill,
                isCircle: true,
                isSelected: true,
                onPressed: () {})),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXButtonSwitch:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonSwitch(
              value: isSwitched,
              onChanged: (bool newValue) {
                setState(() {
                  isSwitched = newValue;
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonSwitch(
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
          padding: EdgeInsets.all(8), child: Text('CXButtonCheckbox:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonCheckBox(
              value: isSwitched,
              onChanged: (bool? value) {
                setState(() {
                  isSwitched = value!;
                });
              },
            )),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CXButtonDisclosure:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonDisclosure(
              value: isSwitched,
              onChanged: (bool newValue) {
                setState(() {
                  isSwitched = newValue;
                });
              },
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXButtonRadio:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonRadio(
              isSelected: selectedRadio == 1,
              onSelected: (bool? isSelected) {
                setState(() {
                  selectedRadio = 1;
                });
              },
              child: const Text("Me"),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonRadio(
              isSelected: selectedRadio == 2,
              onSelected: (bool? isSelected) {
                setState(() {
                  selectedRadio = 2;
                });
              },
              child: const Text("You"),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXButtonSelect:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonSelect(
              options: const ['One', 'Two', 'Three'],
              defaultIndex: 0,
              onSelected: (int index, String value) {
                // ignore: avoid_print
                print("ButtonSelect: $index $value");
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CXButtonSelect(
              options: const ['No', 'Yes', 'Maybe', 'Who knows?'],
              defaultIndex: 1,
              isFlat: true,
              isTranslucent: true,
              onSelected: (int index, String value) {
                // ignore: avoid_print
                print("ButtonSelect: $index $value");
              },
            )),
      ]),
      const SizedBox(height: 50),
    ]);
  }
}
