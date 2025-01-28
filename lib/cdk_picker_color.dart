import 'package:flutter/cupertino.dart';
import 'cdk.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerColor extends StatefulWidget {
  final Color color;
  final Function(Color)? onChanged;

  const CDKPickerColor({
    super.key,
    required this.color,
    this.onChanged,
  });

  @override
  CDKPickerColorState createState() => CDKPickerColorState();
}

class CDKPickerColorState extends State<CDKPickerColor> {
  double _rgbRed = 0;
  double _rgbGreen = 0;
  double _rgbBlue = 0;
  double _rgbAlpha = 0;

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
    _rgbRed = widget.color.red.toDouble();
    _rgbGreen = widget.color.green.toDouble();
    _rgbBlue = widget.color.blue.toDouble();
    _rgbAlpha = widget.color.alpha.toDouble() / 255;

    return SizedBox(
        width: 225,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CDKPickerColorHSV(
                value: widget.color,
                onChanged: (value) {
                  widget.onChanged!.call(value);
                }),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                  width: 65,
                  child: CDKFieldNumeric(
                    value: _rgbRed,
                    min: 0,
                    max: 255,
                    decimals: 0,
                    increment: 1,
                    units: "R",
                    onValueChanged: (value) {
                      _rgbRed = value;
                      _callbackRGB();
                    },
                  )),
              SizedBox(
                  width: 65,
                  child: CDKFieldNumeric(
                    value: _rgbGreen,
                    min: 0,
                    max: 255,
                    decimals: 0,
                    increment: 1,
                    units: "G",
                    onValueChanged: (value) {
                      _rgbGreen = value;
                      _callbackRGB();
                    },
                  )),
              SizedBox(
                  width: 65,
                  child: CDKFieldNumeric(
                    value: _rgbBlue,
                    min: 0,
                    max: 255,
                    decimals: 0,
                    increment: 1,
                    units: "B",
                    onValueChanged: (value) {
                      _rgbBlue = value;
                      _callbackRGB();
                    },
                  )),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                  width: 65,
                  child: CDKFieldNumeric(
                    value: _rgbAlpha,
                    min: 0,
                    max: 1,
                    decimals: 2,
                    increment: 0.05,
                    units: "A",
                    onValueChanged: (value) {
                      _rgbAlpha = value;
                      _callbackRGB();
                    },
                  )),
              SizedBox(
                  width: 65,
                  child: CDKFieldColorHex(
                    value: widget.color.value,
                    onValueChanged: (value) {
                      Color color = Color(value | 0xFF000000);
                      _rgbRed = color.red.toDouble();
                      _rgbGreen = color.green.toDouble();
                      _rgbBlue = color.blue.toDouble();
                      _callbackRGB();
                    },
                  )),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                  width: 65,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CDKTheme.grey100, // Color del border
                      width: 1, // Amplada del border
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: CustomPaint(
                    painter: CDKUtilShaderGrid(7),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          color: widget.color,
                        )),
                        Container(
                          width: 20,
                          color: Color(widget.color.value | 0xFF000000),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ));
  }
}
