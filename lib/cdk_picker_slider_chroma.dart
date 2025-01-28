import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerSliderChroma extends StatefulWidget {
  final double staturation;
  final double brightness;
  final bool enabled;
  final Color hueColor;
  final Function(double, double)? onChanged;

  const CDKPickerSliderChroma({
    super.key,
    required this.staturation,
    required this.brightness,
    this.enabled = true,
    required this.hueColor,
    this.onChanged,
  });

  @override
  CDKPickerSliderChromaState createState() => CDKPickerSliderChromaState();
}

class CDKPickerSliderChromaState extends State<CDKPickerSliderChroma> {
  final double _thumbSize = 16.0;
  final double _thumbHalf = 8;

  void _updatePosition(Offset globalPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(globalPosition);

    double saturation =
        ((localPosition.dx - _thumbHalf) / (renderBox.size.width - _thumbSize))
            .clamp(0.0, 1.0);
    double brightness = 1 -
        ((localPosition.dy - _thumbHalf) / (renderBox.size.height - _thumbSize))
            .clamp(0.0, 1.0);

    if (widget.onChanged != null) {
      widget.onChanged!(saturation, brightness);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.enabled) {
      _updatePosition(details.globalPosition);
    }
  }

  void _onTapDown(TapDownDetails details) {
    _updatePosition(details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onPanUpdate: _onPanUpdate,
        onTapDown: _onTapDown,
        child: CustomPaint(
          painter: CDKPickerSliderGradient2DPainter(
            saturation: widget.staturation,
            brightness: widget.brightness,
            hueColor: widget.hueColor,
            thumbSize: _thumbSize,
            thumbHalf: _thumbHalf,
          ),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        ),
      );
    });
  }
}

class CDKPickerSliderGradient2DPainter extends CustomPainter {
  final double saturation;
  final double brightness;
  final Color hueColor;
  final double thumbSize;
  final double thumbHalf;

  CDKPickerSliderGradient2DPainter({
    required this.saturation,
    required this.brightness,
    required this.hueColor,
    required this.thumbSize,
    required this.thumbHalf,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the 2D gradient
    _draw2DGradient(canvas, size);

    // Draw the custom thumb
    // Calculate the center position of the thumb on the slider

    final double thumbX = thumbHalf + (saturation * (size.width - thumbSize));
    final double thumbY =
        thumbHalf + ((1 - brightness) * (size.height - thumbSize));
    final Offset thumbCenter = Offset(thumbX, thumbY);
    double limitLeft = thumbCenter.dx - thumbHalf;
    double limitTop = thumbCenter.dy - thumbHalf;

    // Create the thumb path
    RRect thumbRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(limitLeft, limitTop, thumbSize, thumbSize),
      const Radius.circular(4), // Arrodoniment de 4 pixels
    );

    Color thumbColor = HSVColor.fromAHSV(
      1.0, // Alpha
      HSVColor.fromColor(hueColor).hue,
      saturation,
      brightness,
    ).toColor();

    Paint thumbStrokePaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(thumbRRect, thumbStrokePaint);

    Paint thumbPaint0 = Paint()
      ..color = CDKTheme.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(thumbRRect, thumbPaint0);

    Paint thumbPaint1 = Paint()
      ..color = CDKTheme.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(thumbRRect, thumbPaint1);
  }

  void _draw2DGradient(Canvas canvas, Size size) {
    RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4), // Arrodoniment de 4 pixels
    );
    HSVColor hsvColor = HSVColor.fromColor(hueColor);

    // Gradient for brightness (black to transparent)
    var brightnessGradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(size.width, 0),
      [CDKTheme.white, hsvColor.toColor()],
    );

    // Gradient for saturation (color to white)
    var saturationGradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(0, size.height),
      [CDKTheme.transparent, CDKTheme.black],
    );

    Paint whiteBackground = Paint()
      ..color = CDKTheme.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(roundedRect, whiteBackground);

    // Apply the gradients using a Paint object
    var paint = Paint()..blendMode = BlendMode.multiply;
    // Draw the brightness gradient
    canvas.drawRRect(
      roundedRect,
      paint..shader = brightnessGradient,
    );
    // Draw the saturation gradient
    canvas.drawRRect(
      roundedRect,
      paint..shader = saturationGradient,
    );
  }

  @override
  bool shouldRepaint(covariant CDKPickerSliderGradient2DPainter oldDelegate) {
    return oldDelegate.saturation != saturation ||
        oldDelegate.brightness != brightness ||
        oldDelegate.hueColor != hueColor;
  }
}
