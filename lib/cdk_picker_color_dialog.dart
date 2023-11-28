import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/cdk_widgets.dart';

class CDKPickerColorDialog extends StatefulWidget {
  final Color value;
  final Function(Color)? onChanged;

  const CDKPickerColorDialog({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  CDKPickerColorDialogState createState() => CDKPickerColorDialogState();
}

class CDKPickerColorDialogState extends State<CDKPickerColorDialog> {

  TextEditingController _controllerHex = TextEditingController();
  double _rgbRed = 0;
  double _rgbGreen = 0;
  double _rgbBlue = 0;
  double _rgbAlpha = 0;

  @override
  void initState() {
    super.initState();
    _controllerHex.text = widget.value.value.toRadixString(16).toUpperCase().padLeft(8, '0');
  }

  _callbackRGB() {
    Color result = Color.fromARGB(
              (_rgbAlpha * 255).toInt(), 
              _rgbRed.toInt(),
              _rgbGreen.toInt(),
              _rgbBlue.toInt(),
            );
    widget.onChanged!.call(result);
  }

  @override
  Widget build(BuildContext context) {

    _rgbRed = widget.value.red.toDouble();
    _rgbGreen = widget.value.green.toDouble();
    _rgbBlue = widget.value.blue.toDouble();
    _rgbAlpha = widget.value.alpha.toDouble() / 255;

    return Container(width: 200, child: Column( 
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CDKPickerColorDialogHSV(value: widget.value, onChanged: (value) {
          widget.onChanged!.call(value);
        }),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        SizedBox(width: 45, child: CDKFieldNumeric(
          value: _rgbRed,
          min: 0,
          max: 255,
          decimals: 0,
          units: "R",
          onValueChanged: (value) {
            _rgbRed = value;
            _callbackRGB();
          },
        )),        
        SizedBox(width: 45, child: CDKFieldNumeric(
          value: _rgbGreen,
          min: 0,
          max: 255,
          decimals: 0,
          units: "G",
          onValueChanged: (value) {
            _rgbGreen = value;
            _callbackRGB();
          },)),
        SizedBox(width: 45, child: CDKFieldNumeric(
          value: _rgbBlue,
          min: 0,
          max: 255,
          decimals: 0,
          units: "B",
          onValueChanged: (value) {
            _rgbBlue = value;
            _callbackRGB();
          },
        )),
        SizedBox(width: 45, child: CDKFieldNumeric(
          value: _rgbAlpha,
          min: 0,
          max: 1,
          decimals: 2,
          units: "A",
          onValueChanged: (value) {
            _rgbAlpha = value;
            _callbackRGB();
          },
        ))
      ]),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Container(
          width: 96,
          height: 22,
          decoration: BoxDecoration(
            color: widget.value,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 96, child: CDKFieldText(
          controller: _controllerHex,
          onChanged: (value) {
            print(value);
          },
        )),
      ]),
    ],));
  }
}
