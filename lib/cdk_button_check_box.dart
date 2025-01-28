import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonCheckBox extends StatelessWidget {
  final bool value;
  final double size;
  final ValueChanged<bool>? onChanged;

  const CDKButtonCheckBox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    CDKTheme themeManager = CDKThemeNotifier.of(context)!.changeNotifier;

    double boxSize = size;

    return GestureDetector(
      onTap: () {
        onChanged?.call(!value);
      },
      child: CustomPaint(
        size: Size(boxSize, boxSize),
        painter: CDKButtonCheckBoxPainter(
          colorAccent: themeManager.accent,
          colorAccent200: themeManager.accent200,
          colorBackgroundSecondary0: themeManager.backgroundSecondary0,
          isSelected: value,
          hasAppFocus: themeManager.isAppFocused,
          size: boxSize,
          isLightTheme: themeManager.isLight,
        ),
      ),
    );
  }
}

class CDKButtonCheckBoxPainter extends CustomPainter {
  final Color colorAccent;
  final Color colorAccent200;
  final Color colorBackgroundSecondary0;
  final bool isSelected;
  final bool hasAppFocus;
  final double size;

  final bool isLightTheme;

  CDKButtonCheckBoxPainter({
    required this.colorAccent,
    required this.colorAccent200,
    required this.colorBackgroundSecondary0,
    required this.isSelected,
    required this.hasAppFocus,
    required this.size,
    required this.isLightTheme,
  });

  /// Draws a shadow around the checkbox to provide visual depth
  void drawShadow(Canvas canvas, Size size, Rect rect) {
    /// Define the path for the rounded square
    Path squarePath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)));

    /// Restrict the shadow painting to the checkbox area
    canvas.clipPath(squarePath);

    /// Create a Paint object for the shadow
    Paint shadowPaint = Paint();

    /// Offset the shadow based on the theme
    Offset shadowOffset = const Offset(0, 0);
    if (isLightTheme) {
      shadowOffset = const Offset(0, -10);
      shadowPaint = Paint()
        ..color = CDKTheme.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    } else {
      shadowOffset = const Offset(0, -8);
      shadowPaint = Paint()
        ..color = CDKTheme.black.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    }

    // Draw shadow
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            rect.shift(shadowOffset), const Radius.circular(4)),
        shadowPaint);

    // Restore drawing clip
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
        colors: [colorAccent200, colorAccent],
      );

      paint = Paint()
        ..style = PaintingStyle.fill
        ..shader = gradient.createShader(squareRect);

      canvas.drawRRect(roundedSquare, paint);
    } else {
      // Draw background square & shadow
      paint = Paint()
        ..style = PaintingStyle.fill
        ..color = colorBackgroundSecondary0;
      canvas.drawRRect(roundedSquare, paint);

      drawShadow(canvas, size, squareRect);
    }

    // Draw outer square
    Color outerColor = CDKTheme.grey;
    if (!isLightTheme) {
      outerColor = CDKTheme.grey600;
    }
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = outerColor;

    canvas.drawRRect(roundedSquare, paint);

    if (isSelected) {
      Color selectColor = CDKTheme.white;
      if (isLightTheme && !hasAppFocus) {
        selectColor = CDKTheme.black;
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
  bool shouldRepaint(covariant CDKButtonCheckBoxPainter oldDelegate) {
    return oldDelegate.colorAccent != colorAccent ||
        oldDelegate.colorAccent200 != colorAccent200 ||
        oldDelegate.colorBackgroundSecondary0 != colorBackgroundSecondary0 ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.hasAppFocus != hasAppFocus ||
        oldDelegate.size != size;
  }
}
