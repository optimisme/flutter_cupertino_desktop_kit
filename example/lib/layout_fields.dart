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
  double _valueNumeric = 5.5;
  double _valueNumericIncrement = -1.0;
  double _valueNumeric360 = 270;
  double _valueNumericSlider0 = 0.5;
  double _valueNumericSlider1 = 50;
  double _valueNumericSlider2 = 128;

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
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKFieldText:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CDKFieldText(
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
                child: CDKFieldText(
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
                child: CDKFieldText(
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
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKFieldNumeric:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CDKFieldNumeric(
                  value: _valueNumeric,
                  onValueChanged: (double value) {
                    setState(() {
                      _valueNumeric = value;
                    });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CDKFieldNumeric(
                  value: _valueNumericIncrement,
                  decimals: 2,
                  min: -2,
                  max: 1.5,
                  increment: 0.15,
                  units: "px",
                  onValueChanged: (double value) {
                    setState(() {
                      _valueNumericIncrement = value;
                    });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CDKFieldNumeric(
                  value: 5.0,
                  enabled: false,
                  onValueChanged: (double value) {},
                ))),
      ]),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKField360:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CDKField360(
                  value: _valueNumeric360,
                  onChanged: (double value) {
                    setState(() {
                      _valueNumeric360 = value;
                    });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CDKField360(
                  enabled: false,
                  onChanged: (double value) {
                    // ignore: avoid_print
                    print("Field360: $value");
                  },
                ))),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKFieldNumericSlider:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CDKFieldNumericSlider(
                  value: _valueNumericSlider0,
                  onValueChanged: (double value) {
                    setState(() {
                      _valueNumericSlider0 = value;
                    });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CDKFieldNumericSlider(
                  value: _valueNumericSlider1,
                  min: 0,
                  max: 100,
                  increment: 1,
                  decimals: 0,
                  units: "%",
                  onValueChanged: (double value) {
                    setState(() {
                      _valueNumericSlider1 = value;
                    });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 150,
                child: CDKFieldNumericSlider(
                  value: _valueNumericSlider2,
                  min: 0,
                  max: 255,
                  increment: 1,
                  decimals: 0,
                  onValueChanged: (double value) {
                    setState(() {
                      _valueNumericSlider2 = value;
                    });
                  },
                ))),
      ]),
      const SizedBox(height: 50),
    ]);
  }
}
