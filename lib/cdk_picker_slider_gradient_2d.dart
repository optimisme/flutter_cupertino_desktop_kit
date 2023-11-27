import 'package:flutter/material.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

class CDKPickerPoint {
  final double x;
  final double y;

  CDKPickerPoint(this.x, this.y);
}

class CDKPickerSliderGradient2D extends StatefulWidget {
  final CDKPickerPoint value;
  final double width;
  final double height;
  final bool enabled;
  final Function(CDKPickerPoint)? onChanged;

  const CDKPickerSliderGradient2D({
    Key? key,
    required this.value,
    this.enabled = true,
    this.width = 150,
    this.height = 100,
    required this.onChanged,
  }) : super(key: key);

  @override
  CDKPickerSliderGradient2DState createState() =>
      CDKPickerSliderGradient2DState();
}

class CDKPickerSliderGradient2DState extends State<CDKPickerSliderGradient2D> {
  CDKPickerPoint _currentPoint = CDKPickerPoint(0, 0);

  @override
  void initState() {
    super.initState();
    _currentPoint = widget.value;
  }

  void _updatePosition(Offset globalPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(globalPosition);

    setState(() {
      _currentPoint = CDKPickerPoint(
        (localPosition.dx / renderBox.size.width).clamp(0.0, 1.0),
        (localPosition.dy / renderBox.size.height).clamp(0.0, 1.0),
      );
    });

    if (widget.onChanged != null) {
      widget.onChanged!(_currentPoint);
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
          point: _currentPoint,
          hasAppFocus:
              CDKThemeNotifier.of(context)!.changeNotifier.isAppFocused,
        ),
        size: Size(widget.width, widget.height),
      ),
    );
  }
}

class CDKPickerSliderGradient2DPainter extends CustomPainter {
  final CDKPickerPoint point;
  final bool hasAppFocus;

  CDKPickerSliderGradient2DPainter({
    required this.point,
    this.hasAppFocus = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Paint the background
    Paint backgroundPaint = Paint()
      ..color = hasAppFocus ? CDKTheme.red : CDKTheme.grey;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Here you should draw your 2D gradient or color space

    // Paint the thumb as a circle
    final double thumbRadius = 10.0;
    Paint thumbPaint = Paint()..color = CDKTheme.green;
    canvas.drawCircle(Offset(point.x * size.width, point.y * size.height),
        thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant CDKPickerSliderGradient2DPainter oldDelegate) {
    return oldDelegate.point != point || oldDelegate.hasAppFocus != hasAppFocus;
  }
}
