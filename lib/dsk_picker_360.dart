import 'package:flutter/material.dart';
import 'dart:math' as math;

class DSKPicker360 extends StatefulWidget {
  final double angle;
  final double size;
  final Function(double) onAngleChanged;

  const DSKPicker360(
      {Key? key,
      required this.angle,
      this.size = 16,
      required this.onAngleChanged})
      : super(key: key);

  @override
  DSKPicker360State createState() => DSKPicker360State();
}

class DSKPicker360State extends State<DSKPicker360> {
  double _currentAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _currentAngle = widget.angle;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: CustomPaint(
        painter: _KnobPainter(_currentAngle),
        size: Size(widget.size, widget.size),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.globalToLocal(details.globalPosition);
    final double angle =
        (math.atan2(position.dy - 100, position.dx - 100) * 180 / math.pi) %
            360;
    setState(() {
      _currentAngle = angle;
    });
    widget.onAngleChanged(angle);
  }
}

class _KnobPainter extends CustomPainter {
  final double angle;

  _KnobPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final angleInRadians = (math.pi / 180) * angle;

    // Dibuixar el cercle principal
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.grey;
    canvas.drawCircle(center, radius, paint);

    // Dibuixar el punt que indica l'angle
    final markerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    final markerPosition = Offset(
      center.dx + radius * math.cos(angleInRadians),
      center.dy + radius * math.sin(angleInRadians),
    );
    canvas.drawCircle(markerPosition, 8, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Podries optimitzar això comprovant si l'angle ha canviat
  }
}
