import 'package:flutter/cupertino.dart';
import 'ck_theme_notifier.dart';
import 'ck_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKButtonRadio extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final double size;
  final Widget child;

  const CKButtonRadio({
    Key? key,
    this.isSelected = false,
    this.onSelected,
    this.size = 16.0,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CKTheme theme = CKThemeNotifier.of(context)!.changeNotifier;

    return GestureDetector(
      onTap: () {
        onSelected?.call(!isSelected);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: VNTButtonRadioPainter(
              colorAccent: theme.accent,
              colorAccent200: theme.accent200,
              colorBackgroundSecondary0: theme.backgroundSecondary0,
              isSelected: isSelected,
              hasAppFocus: theme.isAppFocused,
              size: size,
              isLightTheme: theme.isLight,
            ),
          ),
          const SizedBox(width: 4),
          Baseline(
            baseline: size / 1.5,
            baselineType: TextBaseline.alphabetic,
            child: child is Text
                ? Text(
                    (child as Text).data!,
                    style:
                        (child as Text).style?.copyWith(fontSize: 14) ??
                            const TextStyle(fontSize: 14),
                  )
                : child,
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
        ..color = CKTheme.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    } else {
      shadowOffset = const Offset(0, -8);
      shadowPaint = Paint()
        ..color = CKTheme.black.withOpacity(0.5)
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
    Color outerColor = CKTheme.grey;
    if (!isLightTheme) {
      outerColor = CKTheme.grey600;
    }
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = outerColor;

    canvas.drawCircle(center, radius, paint);

    if (isSelected) {
      Color selectColor = CKTheme.white;
      if (isLightTheme && !hasAppFocus) {
        selectColor = CKTheme.black;
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
