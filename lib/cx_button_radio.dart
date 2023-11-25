import 'package:flutter/cupertino.dart';
import 'cx_theme_notifier.dart';
import 'cx_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CXButtonRadio extends StatefulWidget {
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final double size;
  final Widget child; // Propietat per al label

  const CXButtonRadio({
    Key? key,
    this.isSelected = false,
    this.onSelected,
    this.size = 16.0,
    required this.child, // Requereix el label al crear l'objecte
  }) : super(key: key);

  @override
  CXButtonRadioState createState() => CXButtonRadioState();
}

/// Class `DSKButtonRadioState` - The state for `DSKButtonRadio`.
///
/// Manages the state and rendering of the radio button.
class CXButtonRadioState extends State<CXButtonRadio> {
  @override
  Widget build(BuildContext context) {
    CXTheme theme = CXThemeNotifier.of(context)!.changeNotifier;

    double boxSize = widget.size;

    // Main widget that handles interaction and arranges elements.
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
              colorAccent: theme.accent,
              colorAccent200: theme.accent200,
              colorBackgroundSecondary0: theme.backgroundSecondary0,
              isSelected: widget.isSelected,
              hasAppFocus: theme.isAppFocused,
              size: boxSize,
              isLightTheme: theme.isLight,
            ),
          ),
          const SizedBox(width: 4),
          Baseline(
            baseline: boxSize / 1.5,
            baselineType: TextBaseline.alphabetic,
            child: (widget.child is! Text)
                ? widget.child
                : Text(
                    (widget.child as Text).data!,
                    style:
                        (widget.child as Text).style?.copyWith(fontSize: 14) ??
                            const TextStyle(fontSize: 14),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Class `VNTButtonRadioPainter` - A `CustomPainter` for drawing the radio button.
///
/// This class uses canvas drawing methods to create the visual appearance of the radio button.
class VNTButtonRadioPainter extends CustomPainter {
  final Color colorAccent;
  final Color colorAccent200;
  final Color colorBackgroundSecondary0;
  final bool isSelected;
  final bool hasAppFocus;
  final double size;
  final bool isLightTheme;

  VNTButtonRadioPainter({
    required this.colorAccent,
    required this.colorAccent200,
    required this.colorBackgroundSecondary0,
    required this.isSelected,
    required this.hasAppFocus,
    required this.size,
    required this.isLightTheme,
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
    if (isLightTheme) {
      shadowOffset = const Offset(0, -10);
      shadowPaint = Paint()
        ..color = CXTheme.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    } else {
      shadowOffset = const Offset(0, -8);
      shadowPaint = Paint()
        ..color = CXTheme.black.withOpacity(0.5)
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
        colors: [colorAccent200, colorAccent],
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
        ..color = colorBackgroundSecondary0;
      canvas.drawCircle(center, radius, paint);

      drawShadow(canvas, size, center, radius);
    }
    // Draw outer circle
    Color outerColor = CXTheme.grey;
    if (!isLightTheme) {
      outerColor = CXTheme.grey600;
    }
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = outerColor;

    canvas.drawCircle(center, radius, paint);

    if (isSelected) {
      Color selectColor = CXTheme.white;
      if (isLightTheme && !hasAppFocus) {
        selectColor = CXTheme.black;
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
    return oldDelegate.colorAccent != colorAccent ||
        oldDelegate.colorAccent200 != colorAccent200 ||
        oldDelegate.colorBackgroundSecondary0 != colorBackgroundSecondary0 ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.hasAppFocus != hasAppFocus ||
        oldDelegate.isLightTheme != isLightTheme ||
        oldDelegate.size != size;
  }
}