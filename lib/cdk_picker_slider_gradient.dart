import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerSliderGradient extends StatefulWidget {
  final List<Color> colors;
  final List<double> stops;
  final Color thumbColorBackground;
  final double value;
  final bool enabled;
  final Function(double, Color)? onChanged;

  const CDKPickerSliderGradient({
    super.key,
    required this.colors,
    required this.stops,
    this.thumbColorBackground = CDKTheme.transparent,
    required this.value,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  CDKPickerSliderGradientState createState() => CDKPickerSliderGradientState();

  static Color getColorAtValue(
      List<Color> colors, List<double> stops, double value) {
    for (int i = 0; i < stops.length - 1; i++) {
      if (value <= stops[i + 1]) {
        // Interpolate between the two colors
        return Color.lerp(colors[i], colors[i + 1],
            (value - stops[i]) / (stops[i + 1] - stops[i]))!;
      }
    }
    return colors.last;
  }
}

class CDKPickerSliderGradientState extends State<CDKPickerSliderGradient> {
  @override
  void initState() {
    super.initState();
    if (widget.value < 0 || widget.value > 1) {
      throw Exception(
          "CDKPickerSliderGradientState initState: value must be between 0 and 1");
    }
  }

  void _getValue(Offset globalPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.globalToLocal(globalPosition);

    const double thumbSize = 10.0;
    const double thumbSizeHalf = thumbSize / 2;
    final thumbRail = renderBox.size.width - thumbSize;
    double newValue =
        ((position.dx - thumbSizeHalf) / thumbRail).clamp(0.0, 1.0);

    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 1) {
      newValue = 1;
    }

    Color color = CDKPickerSliderGradient.getColorAtValue(
        widget.colors, widget.stops, newValue);
    widget.onChanged?.call(newValue, color);
  }

  void _onTapDown(TapDownDetails details) {
    _getValue(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _getValue(details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTapDown: (details) {
          _onTapDown(details);
        },
        onPanUpdate: !widget.enabled ? null : _onPanUpdate,
        child: CustomPaint(
          painter: CDKPickerSliderGradientPainter(
            colors: widget.colors,
            stops: widget.stops,
            thumbColorBackground: widget.thumbColorBackground,
            value: widget.value,
            thumbColor: CDKPickerSliderGradient.getColorAtValue(
                widget.colors, widget.stops, widget.value),
            hasAppFocus: theme.isAppFocused, // Border color
          ),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        ),
      );
    });
  }
}

class CDKPickerSliderGradientPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> stops;
  final double value;
  final Color thumbColor;
  final Color thumbColorBackground;
  final bool hasAppFocus;

  CDKPickerSliderGradientPainter(
      {required this.stops,
      required this.colors,
      required this.value,
      required this.thumbColor,
      required this.thumbColorBackground,
      this.hasAppFocus = true});

  @override
  void paint(Canvas canvas, Size size) {
    RRect backgroundRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height - 2,
      const Radius.circular(4.0),
    );
    Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        stops: stops,
      ).createShader(backgroundRRect.outerRect);
    canvas.drawRRect(backgroundRRect, gradientPaint);

    // Draw the custom thumb
    // Calculate the center position of the thumb on the slider
    const double thumbSize = 10.0;
    const double thumbSizeHalf = thumbSize / 2;
    final thumbRail = size.width - thumbSize;
    final double thumbX = thumbSizeHalf + (value * thumbRail);
    final double thumbY = (size.height / 2) + 1;
    final Offset thumbCenter = Offset(thumbX, thumbY);
    double limitLeft = thumbCenter.dx - thumbSizeHalf;
    double limitRight = thumbCenter.dx + thumbSizeHalf;

    // Create the thumb path
    Path thumbPath = Path();
    thumbPath.moveTo(limitLeft, thumbCenter.dy);
    thumbPath.lineTo(thumbCenter.dx, thumbCenter.dy - 4);
    thumbPath.lineTo(limitRight, thumbCenter.dy);
    thumbPath.lineTo(limitRight, thumbCenter.dy + 7);
    thumbPath.lineTo(limitRight - 1, thumbCenter.dy + 8);
    thumbPath.lineTo(limitLeft + 1, thumbCenter.dy + 8);
    thumbPath.lineTo(limitLeft, thumbCenter.dy + 7);
    thumbPath.close();

    Paint thumbStrokePaint = Paint()
      ..color = CDKTheme.grey700
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawPath(thumbPath, thumbStrokePaint);

    Paint thumbPaint = Paint()
      ..color = CDKTheme.grey
      ..style = PaintingStyle.fill;
    canvas.drawPath(thumbPath, thumbPaint);

    // Create the thumb colored square path
    Path thumbSquarePath = Path();
    thumbSquarePath.moveTo(limitLeft + 1, thumbCenter.dy);
    thumbSquarePath.lineTo(limitRight - 1, thumbCenter.dy);
    thumbSquarePath.lineTo(limitRight - 1, thumbCenter.dy + 7);
    thumbSquarePath.lineTo(limitLeft + 1, thumbCenter.dy + 7);
    thumbSquarePath.close();

    // Paint the background of the thumb
    Paint thumbSquarePaintBackground = Paint()
      ..color = CDKTheme.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(thumbSquarePath, thumbSquarePaintBackground);

    // Create the thumb colored square path
    Paint thumbSquarePaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(thumbSquarePath, thumbSquarePaint);
  }

  @override
  bool shouldRepaint(covariant CDKPickerSliderGradientPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.stops != stops ||
        oldDelegate.thumbColor != thumbColor ||
        oldDelegate.thumbColorBackground != thumbColorBackground ||
        oldDelegate.value != value ||
        oldDelegate.hasAppFocus != hasAppFocus;
  }
}
