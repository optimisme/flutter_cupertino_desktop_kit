import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

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
    DSKTheme theme = DSKThemeNotifier.of(context)!.changeNotifier;

    return Container(
        color: theme.background,
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
                    child: DSKFieldText(
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
                    child: DSKFieldText(
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
              padding: EdgeInsets.all(8), child: Text('DSKFieldNumeric:')),
          Wrap(children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 100,
                    child: DSKFieldNumeric(
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
                    child: DSKFieldNumeric(
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
                    child: DSKFieldNumeric(
                      defaultValue: 5.0,
                      enabled: false,
                      onValueChanged: (double value) {
                        // ignore: avoid_print
                        print("Numeric C: $value");
                      },
                    ))),
          ]),
          const Padding(
              padding: EdgeInsets.all(8), child: Text('DSKField360:')),
          Wrap(children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 150,
                    child: DSKField360(
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
                    child: DSKField360(
                      enabled: false,
                      onChanged: (double value) {
                        // ignore: avoid_print
                        print("Field360: $value");
                      },
                    ))),
          ]),
          const Padding(
              padding: EdgeInsets.all(8),
              child: Text('DSKFieldNumericSlider:')),
          Wrap(children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 150,
                    child: DSKFieldNumericSlider(
                      defaultValue: 50,
                      onChanged: (double value) {
                        // ignore: avoid_print
                        print("Field100: $value");
                      },
                    ))),
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 150,
                    child: DSKFieldNumericSlider(
                      enabled: false,
                      onChanged: (double value) {
                        // ignore: avoid_print
                        print("Field360: $value");
                      },
                    ))),
          ]),
          const SizedBox(height: 50),
        ]));
  }
}
