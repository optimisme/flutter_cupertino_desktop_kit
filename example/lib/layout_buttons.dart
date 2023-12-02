import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';

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
  late Widget _preloadedColorPicker;
  final GlobalKey<CDKDialogPopoverState> _anchorColorButton = GlobalKey();
  final ValueNotifier<Color> _valueColorNotifier =
      ValueNotifier(const Color(0x800080FF));

  _showPopoverColor(BuildContext context, GlobalKey anchorKey) {
    final GlobalKey<CDKDialogPopoverArrowedState> key = GlobalKey();
    if (anchorKey.currentContext == null) {
      // ignore: avoid_print
      print("Error: anchorKey not assigned to a widget");
      return;
    }
    CDKDialogsManager.showPopoverArrowed(
      key: key,
      context: context,
      anchorKey: anchorKey,
      isAnimated: true,
      isTranslucent: false,
      onHide: () {
        // ignore: avoid_print
        print("hide slider $key");
      },
      child: _preloadedColorPicker,
    );
  }

  Widget _buildPreloadedColorPicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder<Color>(
        valueListenable: _valueColorNotifier,
        builder: (context, value, child) {
          return CDKPickerColor(
            color: value,
            onChanged: (color) {
              setState(() {
                _valueColorNotifier.value = color;
              });
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _preloadedColorPicker = _buildPreloadedColorPicker();
    return ListView(children: [
      const SizedBox(height: 8),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKButton:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.action,
              isLarge: true,
              onPressed: () {},
              child: const Text('Action large'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.action,
              onPressed: () {},
              child: const Text('Action'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.destructive,
              onPressed: () {},
              child: const Text('Destructive'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              onPressed: () {},
              child: const Text('Normal'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              onPressed: () {},
              child: const Icon(CupertinoIcons.bookmark),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.action,
              enabled: false,
              onPressed: () {},
              child: const Text('Action disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.destructive,
              enabled: false,
              onPressed: () {},
              child: const Text('Destructive disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              enabled: false,
              onPressed: () {},
              child: const Text('Normal disabled'),
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButton(
              style: CDKButtonStyle.normal,
              enabled: false,
              onPressed: () {},
              child: const Icon(CupertinoIcons.bookmark),
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKButtonColor:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: ValueListenableBuilder<Color>(
                valueListenable: _valueColorNotifier,
                builder: (context, value, child) {
                  return CDKButtonColor(
                      key: _anchorColorButton,
                      color: _valueColorNotifier.value,
                      onPressed: () {
                        _showPopoverColor(context, _anchorColorButton);
                      });
                })),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKButtonHelp:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonHelp(size: 24, onPressed: () {})),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKButtonIcon:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonIcon(
                size: 28, icon: CupertinoIcons.back, onPressed: () {})),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonIcon(size: 28, isCircle: true, onPressed: () {})),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonIcon(
                size: 28,
                icon: CupertinoIcons.cloud_fill,
                isCircle: true,
                isSelected: true,
                onPressed: () {})),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKButtonSwitch:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonSwitch(
              value: _isSwitched,
              onChanged: (bool newValue) {
                setState(() {
                  _isSwitched = newValue;
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonSwitch(
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
          padding: EdgeInsets.all(8), child: Text('CDKButtonCheckbox:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonCheckBox(
              value: _isSwitched,
              onChanged: (bool? value) {
                setState(() {
                  _isSwitched = value!;
                });
              },
            )),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKButtonDisclosure:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonDisclosure(
              value: _isSwitched,
              onChanged: (bool newValue) {
                setState(() {
                  _isSwitched = newValue;
                });
              },
            )),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKButtonRadio:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonRadio(
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
            child: CDKButtonRadio(
              isSelected: _selectedRadio == 2,
              onSelected: (bool? isSelected) {
                setState(() {
                  _selectedRadio = 2;
                });
              },
              child: const Text("You"),
            )),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKButtonSelect:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonSelect(
              options: const ['One', 'Two', 'Three'],
              selectedIndex: _indexButtonSelect0,
              onSelected: (int index) {
                setState(() {
                  _indexButtonSelect0 = index;
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKButtonSelect(
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
