import 'package:flutter/cupertino.dart';
import 'cdk_picker_slider_chroma.dart';
import 'cdk_picker_slider_gradient.dart';
import 'cdk_theme.dart';
import 'cdk_util_shader_grid.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerColorHSV extends StatefulWidget {
  final Color value;
  final Function(Color)? onChanged;

  const CDKPickerColorHSV({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  CDKPickerColorHSVState createState() => CDKPickerColorHSVState();
}

class CDKPickerColorHSVState extends State<CDKPickerColorHSV> {
  late double _saturation;
  late double _brightness;
  late double _hue;
  late double _alpha;
  bool _isInternalUpdate = false;

  final List<Color> _gradientHueColors = [
    CDKTheme.red,
    CDKTheme.yellow,
    CDKTheme.green,
    CDKTheme.cyan,
    CDKTheme.blue,
    CDKTheme.magenta,
    CDKTheme.red
  ];
  final List<double> _gradientHueStops = const [
    0.0,
    0.17,
    0.33,
    0.5,
    0.67,
    0.83,
    1.0
  ];

  final List<Color> _gradientAlphaColors = [
    CDKTheme.transparent,
    CDKTheme.black
  ];
  final List<double> _gradientAlphaStops = const [0.0, 1.0];

  @override
  void initState() {
    super.initState();
    _updateValuesFromColor(widget.value);
  }

  @override
  void didUpdateWidget(CDKPickerColorHSV oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_isInternalUpdate) {
      _updateValuesFromColor(widget.value);
    }
    _isInternalUpdate = false; // Reset the flag
  }

  void _updateValuesFromColor(Color color) {
    HSVColor hsvColor = HSVColor.fromColor(color);
    _saturation = hsvColor.saturation;
    _brightness = hsvColor.value;
    _hue = hsvColor.hue / 360;
    _alpha = hsvColor.alpha;
  }

  void _callback() {
    _isInternalUpdate = true; // Set the flag to indicate internal update
    if (widget.onChanged != null) {
      Color result = HSVColor.fromAHSV(
        _alpha,
        _hue * 360,
        _saturation,
        _brightness,
      ).toColor();
      widget.onChanged!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color hueSliderToColor = CDKPickerSliderGradient.getColorAtValue(
        _gradientHueColors, _gradientHueStops, _hue);

    _gradientAlphaColors[1] = Color(widget.value.value | 0xFF000000);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: double.infinity,
            height: 150,
            child: CDKPickerSliderChroma(
              staturation: _saturation,
              brightness: _brightness,
              hueColor: hueSliderToColor,
              onChanged: (saturation, brightness) {
                setState(() {
                  _saturation = saturation;
                  _brightness = brightness;
                  _callback();
                });
              },
            )),
        const SizedBox(height: 8),
        SizedBox(
            width: double.infinity,
            height: 16,
            child: CDKPickerSliderGradient(
              colors: _gradientHueColors,
              stops: _gradientHueStops,
              value: _hue,
              onChanged: (value, color) {
                setState(() {
                  _hue = value;
                  _callback();
                });
              },
            )),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 16,
          child: Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  4.0), // Defineix el radi de les vores arrodonides a 4 pixels
              child: CustomPaint(
                painter: CDKUtilShaderGrid(5),
                child: Container(
                  height: 14,
                ),
              ),
            ),
            CDKPickerSliderGradient(
              colors: _gradientAlphaColors,
              stops: _gradientAlphaStops,
              thumbColorBackground: widget.value,
              value: _alpha,
              onChanged: (value, color) {
                setState(() {
                  _alpha = value;
                  _callback();
                });
              },
            )
          ]),
        ),
      ],
    );
  }
}
