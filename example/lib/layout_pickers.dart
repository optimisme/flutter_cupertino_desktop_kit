import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';
import 'package:provider/provider.dart';

class LayoutPickers extends StatefulWidget {
  const LayoutPickers({super.key});

  @override
  State<LayoutPickers> createState() => _LayoutPickersState();
}

class _LayoutPickersState extends State<LayoutPickers> {
  double _value = 0.1;
  double _angle = 0.0;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final themeManager = Provider.of<DSKThemeManager>(context);

    return Container(
        color: DSKColors.background,
        child: ListView(children: [
          const SizedBox(height: 8),
          const Padding(
              padding: EdgeInsets.all(8), child: Text('DSKPickerSlider:')),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 100,
                    child: DSKPickerSlider(
                      onChanged: (value) {
                        _value = value;
                        setState(() {});
                      },
                    ))),
            Text(_value.toStringAsFixed(2),
                style: const TextStyle(fontSize: 12)),
          ]),
          const SizedBox(height: 8),
          const Padding(
              padding: EdgeInsets.all(8), child: Text('DSKPicker360:')),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: DSKPicker360(
                  onChanged: (angle) {
                    _angle = angle;
                    setState(() {});
                  },
                )),
            Text(_angle.toStringAsFixed(2),
                style: const TextStyle(fontSize: 12)),
          ]),
          const SizedBox(height: 50),
        ]));
  }
}
