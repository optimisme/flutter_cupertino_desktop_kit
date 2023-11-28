import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk_widgets.dart';

class LayoutPickers extends StatefulWidget {
  const LayoutPickers({super.key});

  @override
  State<LayoutPickers> createState() => _LayoutPickersState();
}

class _LayoutPickersState extends State<LayoutPickers> {
  double _angle = 0.0;
  double _valueSlider = 0.5;
  int _selectedIndexButtonsSegmented0 = 1;
  int _selectedIndexButtonsSegmented1 = 1;
  List<bool> _selectedStatesButtonsBar0 = [true, false, false, false];
  List<bool> _selectedStatesButtonsBar1 = [true, false, true, false];
  int _selectedIndexCheckList = 1;

  late List<Color> _valueSliderColors;
  final List<double> _valueSliderStops = const [0.0, 1.0];
  double _valueSliderGradient = 0.75;

  Color _valueColor = CDKTheme.cyan;

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    _valueSliderColors = [CDKTheme.black, theme.accent];
    Color valueSliderGradientColor = CDKPickerSliderGradient.getColorAtValue(
        _valueSliderColors, _valueSliderStops, _valueSliderGradient);

    return ListView(children: [
      const SizedBox(height: 8),
      const Padding(padding: EdgeInsets.all(8), child: Text('CDKPicker360:')),
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKPicker360(
              value: _angle,
              onChanged: (angle) {
                setState(() {
                  _angle = angle;
                });
              },
            )),
        Text(_angle.toStringAsFixed(2), style: const TextStyle(fontSize: 12)),
      ]),
      const SizedBox(height: 8),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKPickerSlider:')),
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CDKPickerSlider(
                  value: _valueSlider,
                  onChanged: (value) {
                    setState(() {
                      _valueSlider = value;
                    });
                  },
                ))),
        Text(_valueSlider.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12)),
      ]),
      const SizedBox(height: 8),
      const Padding(
          padding: EdgeInsets.all(8),
          child: Text('CDKPickerButtonsSegmented:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 300,
                child: CDKPickerButtonsSegmented(
                  selectedIndex: _selectedIndexButtonsSegmented0,
                  options: const [
                    Text('Car'),
                    Text('Motorbike'),
                    Icon(CupertinoIcons.airplane)
                  ],
                  onSelected: (int index) {
                    setState(() {
                      _selectedIndexButtonsSegmented0 = index;
                    });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 250,
                child: CDKPickerButtonsSegmented(
                  selectedIndex: _selectedIndexButtonsSegmented1,
                  options: const [
                    Icon(CupertinoIcons.ant),
                    Text('Flower'),
                    Text('Grass'),
                    Text('Bush')
                  ],
                  isAccent: true,
                  onSelected: (int index) {
                    setState(() {
                      _selectedIndexButtonsSegmented1 = index;
                    });
                  },
                ))),
      ]),
      const SizedBox(height: 8),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKPickerButtonsBar:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 300,
                child: CDKPickerButtonsBar(
                  selectedStates: _selectedStatesButtonsBar0,
                  options: const [
                    Icon(CupertinoIcons.text_alignleft),
                    Icon(CupertinoIcons.text_aligncenter),
                    Icon(CupertinoIcons.text_alignright),
                    Text("Justify")
                  ],
                  onChanged: (List<bool> options) {
                    setState(() {
                      _selectedStatesButtonsBar0 = options;
                    });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 250,
                child: CDKPickerButtonsBar(
                  selectedStates: _selectedStatesButtonsBar1,
                  options: const [
                    Icon(CupertinoIcons.bold),
                    Icon(CupertinoIcons.italic),
                    Icon(CupertinoIcons.underline),
                    Icon(CupertinoIcons.strikethrough)
                  ],
                  allowsMultipleSelection: true,
                  onChanged: (List<bool> options) {
                    setState(() {
                      _selectedStatesButtonsBar1 = options;
                    });
                  },
                ))),
      ]),
      const SizedBox(height: 8),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKPickerSliderGradient:')),
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CDKPickerSliderGradient(
                  colors: _valueSliderColors,
                  stops: _valueSliderStops,
                  value: _valueSliderGradient,
                  onChanged: (value, color) {
                    setState(() {
                      _valueSliderGradient = value;
                      valueSliderGradientColor = color;
                    });
                  },
                ))),
        Container(width: 10, height: 10, color: valueSliderGradientColor),
        Text(_valueSliderGradient.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12)),
      ]),
      const SizedBox(height: 8),
      const Padding(
          padding: EdgeInsets.all(8),
          child: Text('CDKPickerColorDialog:')),
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(width: 250, child:
                  CDKPickerColorDialog(
                  value: _valueColor,
                  onChanged: (color) {
                    setState(() {
                      _valueColor = color;
                    });
                  },
                ))),
        Container(width: 50, height: 25, color: _valueColor),
      ]),
      const SizedBox(height: 8),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CDKPickerCheckList:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CDKPickerCheckList(
              options: const ['Dog', 'Cat', 'Parrot'],
              selectedIndex: _selectedIndexCheckList,
              onSelected: (int index) {
                setState(() {
                  _selectedIndexCheckList = index;
                });
              },
            )),
      ]),
      const SizedBox(height: 50),
    ]);
  }
}