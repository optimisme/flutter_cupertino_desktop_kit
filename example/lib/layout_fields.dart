import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop/ck_widgets.dart';

class LayoutFields extends StatefulWidget {
  const LayoutFields({super.key});

  @override
  State<LayoutFields> createState() => _LayoutFieldsState();
}

class _LayoutFieldsState extends State<LayoutFields> {
  late TextEditingController _textController;
  late TextEditingController _passController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: 'Initial text');
    _passController = TextEditingController(text: '1234');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 8),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXFieldText:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CKFieldText(
                  controller: _textController,
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
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CKFieldText(
                  placeholder: 'Placeholder',
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
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CKFieldText(
                  controller: _passController,
                  obscureText: true,
                  isRounded: false,
                  onChanged: (value) {
                    // ignore: avoid_print
                    print("Password changed: $value");
                  },
                  onSubmitted: (value) {
                    // ignore: avoid_print
                    print("Password submitted: $value");
                  },
                  focusNode: FocusNode(),
                ))),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXFieldNumeric:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CKFieldNumeric(
                  defaultValue: 5.0,
                  onValueChanged: (double value) {
                    // ignore: avoid_print
                    print("Numeric A: $value");
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CKFieldNumeric(
                  defaultValue: -1.0,
                  decimals: 2,
                  min: -2,
                  max: 1.5,
                  increment: 0.15,
                  units: "px",
                  onValueChanged: (double value) {
                    // ignore: avoid_print
                    print("Numeric B: $value");
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CKFieldNumeric(
                  defaultValue: 5.0,
                  enabled: false,
                  onValueChanged: (double value) {
                    // ignore: avoid_print
                    print("Numeric C: $value");
                  },
                ))),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CXField360:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CKField360(
                  defaultValue: 270,
                  onChanged: (double value) {
                    // ignore: avoid_print
                    print("Field360: $value");
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CKField360(
                  enabled: false,
                  onChanged: (double value) {
                    // ignore: avoid_print
                    print("Field360: $value");
                  },
                ))),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CXFieldNumericSlider:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CKFieldNumericSlider(
                  defaultValue: 0.5,
                  onValueChanged: (double value) {
                    // ignore: avoid_print
                    print("Numeric slider default: $value");
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CKFieldNumericSlider(
                  defaultValue: 50,
                  min: 0,
                  max: 100,
                  increment: 1,
                  decimals: 0,
                  units: "%",
                  onValueChanged: (double value) {
                    // ignore: avoid_print
                    print("Numeric slider %: $value");
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CKFieldNumericSlider(
                  defaultValue: 128,
                  min: 0,
                  max: 255,
                  increment: 1,
                  decimals: 0,
                  onValueChanged: (double value) {
                    // ignore: avoid_print
                    print("Numeric slider %: $value");
                  },
                ))),
      ]),
      const SizedBox(height: 50),
    ]);
  }
}
