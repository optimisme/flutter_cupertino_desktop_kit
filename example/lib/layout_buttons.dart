import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

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
      const Padding(padding: EdgeInsets.all(8), child: Text('DSKButton:')),
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
              onPressed: () {},
              child: const Text('Action'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButton(
              style: DSKButtonStyle.destructive,
              onPressed: () {},
              child: const Text('Destructive'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButton(
              style: DSKButtonStyle.normal,
              onPressed: () {},
              child: const Text('Normal'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButton(
              style: DSKButtonStyle.normal,
              onPressed: () {},
              child: const Icon(CupertinoIcons.bookmark),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButton(
              style: DSKButtonStyle.action,
              enabled: false,
              onPressed: () {},
              child: const Text('Action disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButton(
              style: DSKButtonStyle.destructive,
              enabled: false,
              onPressed: () {},
              child: const Text('Destructive disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButton(
              style: DSKButtonStyle.normal,
              enabled: false,
              onPressed: () {},
              child: const Text('Normal disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButton(
              style: DSKButtonStyle.normal,
              enabled: false,
              onPressed: () {},
              child: const Icon(CupertinoIcons.bookmark),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('DSKButtonHelp:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButtonHelp(size: 24, onPressed: () {})),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('DSKButtonIcon:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButtonIcon(
                size: 28, icon: CupertinoIcons.back, onPressed: () {})),
        Padding(
            padding: const EdgeInsets.all(8),
            child: DSKButtonIcon(size: 28, isCircle: true, onPressed: () {})),
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
          padding: EdgeInsets.all(8), child: Text('DSKButtonCheckbox:')),
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
          padding: EdgeInsets.all(8), child: Text('DSKButtonDisclosure:')),
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
      const Padding(padding: EdgeInsets.all(8), child: Text('DSKButtonRadio:')),
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
              onSelected: (int index, String value) {
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
