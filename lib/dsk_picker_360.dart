import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'dsk_theme_notifier.dart';
import 'dsk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

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

  @override
  void dispose() {
    super.dispose();
  }

  void setValue(double value) {
    setState(() {
      _currentAngle = value;
    });
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
      if (angle != _currentAngle) {
        _currentAngle = angle;
        widget.onChanged?.call(angle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DSKTheme theme = DSKThemeNotifier.of(context)!.changeNotifier;

    return GestureDetector(
      onPanUpdate: !widget.enabled ? null : _onPanUpdate,
      child: CustomPaint(
        painter: DSKPicker360Painter(
            theme.backgroundSecondary0,
            _currentAngle,
            widget.enabled ? theme.colorText : DSKTheme.grey,
            theme.isLight ? DSKTheme.grey100 : DSKTheme.grey),
        size: Size(widget.size, widget.size),
      ),
    );
  }
}

class DSKPicker360Painter extends CustomPainter {
  final Color colorBackgroundSecondary0;
  final double angle;
  final Color borderColor;
  final Color pickerColor;

  DSKPicker360Painter(this.colorBackgroundSecondary0, this.angle,
      this.pickerColor, this.borderColor);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final angleInRadians = (math.pi / 180) * angle;

    // Dibuixar la sombra
    final shadowPaint = Paint()
      ..color = DSKTheme.grey50
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(circlePath, shadowPaint.color, 1, false);

    // Dibuixar el cercle principal
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = colorBackgroundSecondary0;
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
        oldDelegate.colorBackgroundSecondary0 != colorBackgroundSecondary0 ||
        oldDelegate.pickerColor != pickerColor ||
        oldDelegate.borderColor != borderColor;
  }
}
