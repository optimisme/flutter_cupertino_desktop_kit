import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

class DSKButtonCheckBox extends StatefulWidget {
  final bool value;
  final double size;
  final ValueChanged<bool> onChanged;

  const DSKButtonCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.size = 16.0,
  }) : super(key: key);

  @override
  DSKButtonCheckBoxState createState() => DSKButtonCheckBoxState();
}

class DSKButtonCheckBoxState extends State<DSKButtonCheckBox> {
  @override
  Widget build(BuildContext context) {
    double boxSize = widget.size;
    return GestureDetector(
        onTap: () {
          widget.onChanged(!widget.value);
        },
        child: CustomPaint(
          size: Size(boxSize, boxSize),
          painter: VNTButtonCheckBoxPainter(
            actionColor: DSKColors.accent,
            isSelected: widget.value,
            hasAppFocus: DSKThemeManager.isAppFocused,
            size: boxSize,
          ),
        ));
  }
}

class VNTButtonCheckBoxPainter extends CustomPainter {
  final Color actionColor;
  final bool isSelected;
  final bool hasAppFocus;
  final double size;

  VNTButtonCheckBoxPainter({
    required this.actionColor,
    required this.isSelected,
    required this.hasAppFocus,
    required this.size,
  });

  void drawShadow(Canvas canvas, Size size, Rect rect) {
    // Defineix el path per al quadrat arrodonit
    Path squarePath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)));

    // Restringeix el dibuix de l'ombra al quadrat
    canvas.clipPath(squarePath);

    // Pintura per a l'ombra
    Paint shadowPaint = Paint();
    Offset shadowOffset = const Offset(0, 0);
    if (DSKThemeManager.isLight) {
      shadowOffset = const Offset(0, -10);
      shadowPaint = Paint()
        ..color = DSKColors.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    } else {
      shadowOffset = const Offset(0, -8);
      shadowPaint = Paint()
        ..color = DSKColors.black.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    }

    // Dibuixar l'ombra
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            rect.shift(shadowOffset), const Radius.circular(4)),
        shadowPaint);

    // Torna a establir el clip per a dibuixar la resta
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  void paint(Canvas canvas, Size size) {
    double borderRadius = 4.0;
    Rect squareRect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height);
    RRect roundedSquare =
        RRect.fromRectAndRadius(squareRect, Radius.circular(borderRadius));
    Paint paint = Paint();

    if (isSelected && hasAppFocus) {
      LinearGradient gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [DSKColors.accent200, DSKColors.accent],
      );

      paint = Paint()
        ..style = PaintingStyle.fill
        ..shader = gradient.createShader(squareRect);

      canvas.drawRRect(roundedSquare, paint);
    } else {
      // Draw background square & shadow
      paint = Paint()
        ..style = PaintingStyle.fill
        ..color = DSKColors.backgroundSecondary0;
      canvas.drawRRect(roundedSquare, paint);

      drawShadow(canvas, size, squareRect);
    }

    // Draw outer square
    Color outerColor = DSKColors.grey;
    if (!DSKThemeManager.isLight) {
      outerColor = DSKColors.grey600;
    }
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = outerColor;

    canvas.drawRRect(roundedSquare, paint);

    if (isSelected) {
      Color selectColor = DSKColors.white;
      if (DSKThemeManager.isLight && !hasAppFocus) {
        selectColor = DSKColors.black;
      }
      Paint linePaint = Paint()
        ..color = selectColor
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      // First line coordinates
      Offset startLine1 = Offset(size.width * 0.15, size.height * 0.48);
      Offset endLine1 = Offset(size.width * 0.38, size.height * 0.80);
      canvas.drawLine(startLine1, endLine1, linePaint);

      // Second line coordinates
      Offset startLine2 = Offset(size.width * 0.36, size.height * 0.80);
      Offset endLine2 = Offset(size.width * 0.75, size.height * 0.22);
      canvas.drawLine(startLine2, endLine2, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant VNTButtonCheckBoxPainter oldDelegate) {
    return oldDelegate.actionColor != actionColor || oldDelegate.isSelected != isSelected ||
        oldDelegate.hasAppFocus != hasAppFocus ||
        oldDelegate.size != size;
  }
}