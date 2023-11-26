import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop/ck_widgets.dart';

class LayoutPickers extends StatefulWidget {
  const LayoutPickers({super.key});

  @override
  State<LayoutPickers> createState() => _LayoutPickersState();
}

class _LayoutPickersState extends State<LayoutPickers> {
  double _angle = 0.0;
  double _value = 0.1;
  int _selectedIndexButtonsSegmented0 = 1;
  int _selectedIndexButtonsSegmented1 = 1;
  List<bool> _selectedStatesButtonsBar0 = [true, false, false, false];
  List<bool> _selectedStatesButtonsBar1 = [true, false, true, false];
  int _selectedIndexCheckList = 1;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 8),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKPicker360:')),
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKPicker360(
              value: _angle,
              onChanged: (angle) {
                setState(() {_angle = angle;});
              },
            )),
        Text(_angle.toStringAsFixed(2), style: const TextStyle(fontSize: 12)),
      ]),
      const SizedBox(height: 8),
      const Padding(padding: EdgeInsets.all(8), child: Text('CKPickerSlider:')),
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 100,
                child: CKPickerSlider(
                  value: _value,
                  onChanged: (value) {
                    setState(() {_value = value;});
                  },
                ))),
        Text(_value.toStringAsFixed(2), style: const TextStyle(fontSize: 12)),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CKPickerButtonsSegmented:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 300,
                child: CKPickerButtonsSegmented(
                  selectedIndex: _selectedIndexButtonsSegmented0,
                  options: const [
                    Text('Car'),
                    Text('Motorbike'),
                    Icon(CupertinoIcons.airplane)
                  ],
                  onSelected: (int index) {
                    setState(() {_selectedIndexButtonsSegmented0 = index; });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 250,
                child: CKPickerButtonsSegmented(
                  selectedIndex: _selectedIndexButtonsSegmented1,
                  options: const [
                    Icon(CupertinoIcons.ant),
                    Text('Flower'),
                    Text('Grass'),
                    Text('Bush')
                  ],
                  isAccent: true,
                  onSelected: (int index) {
                    setState(() {_selectedIndexButtonsSegmented1 = index; });
                  },
                ))),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CKPickerButtonsBar:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 300,
                child: CKPickerButtonsBar(
                  selectedStates: _selectedStatesButtonsBar0,
                  options: const [
                    Icon(CupertinoIcons.text_alignleft),
                    Icon(CupertinoIcons.text_aligncenter),
                    Icon(CupertinoIcons.text_alignright),
                    Text("Justify")
                  ],
                  onChanged: (List<bool> options) {
                    setState(() {_selectedStatesButtonsBar0 = options; });
                  },
                ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: 250,
                child: CKPickerButtonsBar(
                  selectedStates: _selectedStatesButtonsBar1,
                  options: const [
                    Icon(CupertinoIcons.bold), 
                    Icon(CupertinoIcons.italic),
                    Icon(CupertinoIcons.underline), 
                    Icon(CupertinoIcons.strikethrough)
                  ],
                  allowsMultipleSelection: true,
                  onChanged: (List<bool> options) {
                    setState(() {_selectedStatesButtonsBar1 = options; });
                  },
                ))),
      ]),
      const Padding(
          padding: EdgeInsets.all(8), child: Text('CKPickerCheckList:')),
      Wrap(children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: CKPickerCheckList(
              options: const ['Car', 'Motorbike', 'Plane'],
              selectedIndex: _selectedIndexCheckList,
              onSelected: (int index) {
                setState(() {_selectedIndexCheckList = index;});
              },
            )),
      ]),
      const SizedBox(height: 50),
    ]);
  }
}
