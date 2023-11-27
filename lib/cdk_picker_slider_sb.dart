import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class CDKPickerSliderSB extends StatefulWidget {
  final double staturation;
  final double brightness;
  final double width;
  final double height;
  final bool enabled;
  final Color initialColor;
  final Function(double, double)? onChanged;

  const CDKPickerSliderSB({
    Key? key,
    required this.staturation,
    required this.brightness,
    this.enabled = true,
    this.width = 150,
    this.height = 100,
    required this.initialColor,
    this.onChanged,
  }) : super(key: key);

  @override
  CDKPickerSliderSBState createState() => CDKPickerSliderSBState();
}

class CDKPickerSliderSBState extends State<CDKPickerSliderSB> {
  
  void _updatePosition(Offset globalPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(globalPosition);

    double saturation = (localPosition.dx / renderBox.size.width).clamp(0.0, 1.0);
    double brightness = 1 - (localPosition.dy / renderBox.size.height).clamp(0.0, 1.0);

    HSVColor hsvColor = HSVColor.fromColor(widget.initialColor);
    final Color selectedColor = HSVColor.fromAHSV(
      1.0, // Alpha
      hsvColor.hue, // Hue from the initial color
      saturation,
      brightness,
    ).toColor();

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
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onTapDown: _onTapDown,
      child: CustomPaint(
        painter: CDKPickerSliderGradient2DPainter(
          saturation: widget.staturation,
          brightness: widget.brightness,
          initialColor: widget.initialColor,
        ),
        size: Size(widget.width, widget.height),
      ),
    );
  }
}

class CDKPickerSliderGradient2DPainter extends CustomPainter {
  final double saturation;
  final double brightness;
  final Color initialColor;

  CDKPickerSliderGradient2DPainter({
    required this.saturation,
    required this.brightness,
    required this.initialColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the 2D gradient
    _draw2DGradient(canvas, size);

    // Paint the thumb as a circle
    const double thumbRadius = 10.0;
    Paint thumbPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(saturation * size.width, (1 - brightness) * size.height),
        thumbRadius, thumbPaint);
  }

  void _draw2DGradient(Canvas canvas, Size size) {
  Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
  HSVColor hsvColor = HSVColor.fromColor(initialColor);

  // Gradient for brightness (black to transparent)
  var brightnessGradient = ui.Gradient.linear(
    const Offset(0, 0),
    Offset(size.width, 0),
    [Colors.white, hsvColor.toColor()],
  );

  // Gradient for saturation (color to white)
  var saturationGradient = ui.Gradient.linear(
    const Offset(0, 0),
    Offset(0, size.height),
    [Colors.transparent, Colors.black],
  );

  // Apply the gradients using a Paint object
  var paint = Paint()..blendMode = BlendMode.multiply;
  // Draw the brightness gradient
  canvas.drawRect(
    rect,
    paint..shader = brightnessGradient,
  );
  // Draw the saturation gradient
  canvas.drawRect(
    rect,
    paint..shader = saturationGradient,
  );
}


  @override
  bool shouldRepaint(covariant CDKPickerSliderGradient2DPainter oldDelegate) {
    return oldDelegate.saturation != saturation || 
      oldDelegate.brightness != brightness ||
      oldDelegate.initialColor != initialColor;
  }
}
