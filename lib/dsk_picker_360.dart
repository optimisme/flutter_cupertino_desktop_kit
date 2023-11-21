import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_theme_manager.dart';
import 'dart:math' as math;

import 'dsk_theme_colors.dart';

class DSKPicker360 extends StatefulWidget {
  final double defaultValue;
  final double size;
  final bool enabled;
  final Function(double)? onChanged;

  const DSKPicker360(
      {Key? key,
      this.defaultValue = 0,
      this.enabled = true,
      this.size = 16,
      this.onChanged})
      : super(key: key);

  @override
  DSKPicker360State createState() => DSKPicker360State();
}

class DSKPicker360State extends State<DSKPicker360> {
  double _currentAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _currentAngle = widget.defaultValue;
  }

  void setValue(double value) {
    setState(() {
      _currentAngle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: !widget.enabled ? null : _onPanUpdate,
      child: CustomPaint(
        painter: DSKPicker360Painter(
            _currentAngle,
            DSKColors.backgroundSecondary0,
            widget.enabled ? DSKColors.text : DSKColors.grey,
            DSKThemeManager.isLight ? DSKColors.grey100 : DSKColors.grey),
        size: Size(widget.size, widget.size),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final halfSize = widget.size / 2;
    final position = renderBox.globalToLocal(details.globalPosition);
    final double angle =
        (math.atan2(position.dy - halfSize, position.dx - halfSize) *
                180 /
                math.pi) %
            360;
    setState(() {
      _currentAngle = angle;
    });
    widget.onChanged?.call(angle);
  }
}

class DSKPicker360Painter extends CustomPainter {
  final double angle;
  final Color backgroundColor;
  final Color borderColor;
  final Color pickerColor;

  DSKPicker360Painter(
      this.angle, this.backgroundColor, this.pickerColor, this.borderColor);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final angleInRadians = (math.pi / 180) * angle;

    // Dibuixar la sombra
    final shadowPaint = Paint()
      ..color = DSKColors.grey50
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(circlePath, shadowPaint.color, 1, false);

    // Dibuixar el cercle principal
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = backgroundColor;
    canvas.drawCircle(center, radius, paint);

    final paintBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..color = borderColor;
    canvas.drawCircle(center, radius, paintBorder);

    // Dibuixar el punt que indica l'angle
    radius = radius - 3;
    final markerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = pickerColor;
    final markerPosition = Offset(
      center.dx + radius * math.cos(angleInRadians),
      center.dy + radius * math.sin(angleInRadians),
    );
    canvas.drawCircle(markerPosition, 3, markerPaint);
  }

  @override
  bool shouldRepaint(covariant DSKPicker360Painter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.pickerColor != pickerColor ||
        oldDelegate.borderColor != borderColor;
  }
}
