import 'package:flutter/cupertino.dart';
import 'cdk_field_color_hex.dart';
import 'cdk_field_numeric.dart';
import 'cdk_picker_color_hsv.dart';
import 'cdk_theme.dart';
import 'cdk_util_shader_grid.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerColor extends StatefulWidget {
  final Color color;
  final ValueChanged<Color>? onChanged;

  const CDKPickerColor({
    super.key,
    required this.color,
    this.onChanged,
  });

  @override
  State<CDKPickerColor> createState() => _CDKPickerColorState();
}

class _CDKPickerColorState extends State<CDKPickerColor> {
  double _rgbRed = 0;
  double _rgbGreen = 0;
  double _rgbBlue = 0;
  double _rgbAlpha = 0;

  void _callbackRGB() {
    Color result = Color.fromARGB(
      (_rgbAlpha * 255).toInt(),
      _rgbRed.toInt(),
      _rgbGreen.toInt(),
      _rgbBlue.toInt(),
    );
    widget.onChanged?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final argb = widget.color.toARGB32();
    _rgbRed = ((argb >> 16) & 0xFF).toDouble();
    _rgbGreen = ((argb >> 8) & 0xFF).toDouble();
    _rgbBlue = (argb & 0xFF).toDouble();
    _rgbAlpha = ((argb >> 24) & 0xFF) / 255;

    return SizedBox(
        width: 225,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CDKPickerColorHSV(
                value: widget.color,
                onChanged: (value) {
                  widget.onChanged?.call(value);
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
                    value: widget.color.toARGB32(),
                    onValueChanged: (value) {
                      Color color = Color(value | 0xFF000000);
                      final colorArgb = color.toARGB32();
                      _rgbRed = ((colorArgb >> 16) & 0xFF).toDouble();
                      _rgbGreen = ((colorArgb >> 8) & 0xFF).toDouble();
                      _rgbBlue = (colorArgb & 0xFF).toDouble();
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
                          color: Color(widget.color.toARGB32() | 0xFF000000),
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
