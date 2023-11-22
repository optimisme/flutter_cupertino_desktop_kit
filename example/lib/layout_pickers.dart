import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_widgets.dart';

class LayoutPickers extends StatefulWidget {
  const LayoutPickers({super.key});

  @override
  State<LayoutPickers> createState() => _LayoutPickersState();
}

class _LayoutPickersState extends State<LayoutPickers> {
  double _angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
            color: DSKColors.background,
            child: ListView(children: [
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
              const SizedBox(height: 8),
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('DSKPickerDisclosure:')),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DSKPickerDisclosure(
                      title: const Text('Show/Hide',
                          style: TextStyle(fontSize: 14)),
                      child: SizedBox(
                          width: 300,
                          height: 150,
                          child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: DSKColors.backgroundSecondary1,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: const Text('Expandible disclosure'))),
                      onChanged: (bool value) {
                        setState(() {});
                      }),
                ),
              ]),
              const Padding(padding: EdgeInsets.all(8), child: Text('---')),
              const SizedBox(height: 50),
            ]));
  }
}
