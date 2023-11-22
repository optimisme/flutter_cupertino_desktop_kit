import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

class DSKButtonRadio extends StatefulWidget {
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final double size;
  final String label; // Propietat per al label

  const DSKButtonRadio({
    Key? key,
    this.isSelected = false,
    this.onSelected,
    this.size = 16.0,
    required this.label, // Requereix el label al crear l'objecte
  }) : super(key: key);

  @override
  DSKButtonRadioState createState() => DSKButtonRadioState();
}

class DSKButtonRadioState extends State<DSKButtonRadio> {
  @override
  Widget build(BuildContext context) {
    double boxSize = widget.size;

    return GestureDetector(
      onTap: () {
        widget.onSelected?.call(!widget.isSelected);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPaint(
            size: Size(boxSize, boxSize),
            painter: VNTButtonRadioPainter(
              actionColor: DSKColors.accent,
              isSelected: widget.isSelected,
              hasAppFocus: DSKThemeManager.isAppFocused,
              size: boxSize,
            ),
          ),
          const SizedBox(width: 4),
          Baseline(
            baseline: boxSize / 1.5,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              widget.label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class VNTButtonRadioPainter extends CustomPainter {
  final Color actionColor;
  final bool isSelected;
  final bool hasAppFocus;
  final double size;

  VNTButtonRadioPainter({
    required this.actionColor,
    required this.isSelected,
    required this.hasAppFocus,
    required this.size,
  });

  void drawShadow(Canvas canvas, Size size, Offset center, double radius) {
    // Defineix el path per al cercle
    Path circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    // Restringeix el dibuix de l'ombra al cercle
    canvas.clipPath(circlePath);

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
    canvas.drawCircle(center + shadowOffset, radius, shadowPaint);

    // Torna a establir el clip per a dibuixar la resta
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double innerRadius = this.size * 0.4;
    Offset center = Offset(size.width / 2, size.height / 2);
    Paint paint = Paint();

    if (isSelected && hasAppFocus) {
      LinearGradient gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [DSKColors.accent200, DSKColors.accent],
      );

      Paint paint = Paint()
        ..style = PaintingStyle.fill
        ..shader = gradient
            .createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawCircle(center, radius, paint);
    } else {
      // Draw background circle & shadow
      paint = Paint()
        ..style = PaintingStyle.fill
        ..color = DSKColors.backgroundSecondary0;
      canvas.drawCircle(center, radius, paint);

      drawShadow(canvas, size, center, radius);
    }
    // Draw outer circle
    Color outerColor = DSKColors.grey;
    if (!DSKThemeManager.isLight) {
      outerColor = DSKColors.grey600;
    }
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = outerColor;

    canvas.drawCircle(center, radius, paint);

    if (isSelected) {
      Color selectColor = DSKColors.white;
      if (DSKThemeManager.isLight && !hasAppFocus) {
        selectColor = DSKColors.black;
      }
      paint = Paint()
        ..style = PaintingStyle.fill
        ..color = selectColor;

      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), innerRadius / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant VNTButtonRadioPainter oldDelegate) {
    return oldDelegate.actionColor != actionColor ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.hasAppFocus != hasAppFocus ||
        oldDelegate.size != size;
  }
}
