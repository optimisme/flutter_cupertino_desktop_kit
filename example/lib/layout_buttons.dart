import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop/ck_widgets.dart';

class LayoutButtons extends StatefulWidget {
  const LayoutButtons({super.key});

  @override
  State<LayoutButtons> createState() => _LayoutButtonsState();
}

class _LayoutButtonsState extends State<LayoutButtons> {
  bool _isSwitched = false;
  int _selectedRadio = 1;
  int _indexButtonSelect0 = 1;
  int _indexButtonSelect1 = 1;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 8),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKButton:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.action,
              isLarge: true,
              onPressed: () {},
              child: const Text('Action large'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.action,
              onPressed: () {},
              child: const Text('Action'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.destructive,
              onPressed: () {},
              child: const Text('Destructive'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.normal,
              onPressed: () {},
              child: const Text('Normal'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.normal,
              onPressed: () {},
              child: const Icon(CupertinoIcons.bookmark),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.action,
              enabled: false,
              onPressed: () {},
              child: const Text('Action disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.destructive,
              enabled: false,
              onPressed: () {},
              child: const Text('Destructive disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.normal,
              enabled: false,
              onPressed: () {},
              child: const Text('Normal disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButton(
              style: CKButtonStyle.normal,
              enabled: false,
              onPressed: () {},
              child: const Icon(CupertinoIcons.bookmark),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKButtonHelp:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonHelp(size: 24, onPressed: () {})),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKButtonIcon:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonIcon(
                size: 28, icon: CupertinoIcons.back, onPressed: () {})),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonIcon(size: 28, isCircle: true, onPressed: () {})),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonIcon(
                size: 28,
                icon: CupertinoIcons.cloud_fill,
                isCircle: true,
                isSelected: true,
                onPressed: () {})),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKButtonSwitch:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonSwitch(
              value: _isSwitched,
              onChanged: (bool newValue) {
                setState(() {
                  _isSwitched = newValue;
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonSwitch(
              value: _isSwitched,
              size: 12,
              onChanged: (bool newValue) {
                setState(() {
                  _isSwitched = newValue;
                });
              },
            )),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CKButtonCheckbox:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonCheckBox(
              value: _isSwitched,
              onChanged: (bool? value) {
                setState(() {
                  _isSwitched = value!;
                });
              },
            )),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CKButtonDisclosure:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonDisclosure(
              value: _isSwitched,
              onChanged: (bool newValue) {
                setState(() {
                  _isSwitched = newValue;
                });
              },
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKButtonRadio:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonRadio(
              isSelected: _selectedRadio == 1,
              onSelected: (bool? isSelected) {
                setState(() {
                  _selectedRadio = 1;
                });
              },
              child: const Text("Me"),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonRadio(
              isSelected: _selectedRadio == 2,
              onSelected: (bool? isSelected) {
                setState(() {
                  _selectedRadio = 2;
                });
              },
              child: const Text("You"),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKButtonSelect:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonSelect(
              options: const ['One', 'Two', 'Three'],
              selectedIndex: _indexButtonSelect0,
              onSelected: (int index) {
                setState(() {_indexButtonSelect0 = index; });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKButtonSelect(
              options: const ['No', 'Yes', 'Maybe', 'Who knows?'],
              selectedIndex: _indexButtonSelect1,
              isFlat: true,
              isTranslucent: true,
              onSelected: (int index) {
                setState(() {
                  _indexButtonSelect1 = index;
                });
              },
            )),
      ]),
      const SizedBox(height: 50),
    ]);
  }
}
