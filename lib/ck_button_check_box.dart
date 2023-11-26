import 'package:flutter/cupertino.dart';
import 'ck_theme_notifier.dart';
import 'ck_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKButtonCheckBox extends StatefulWidget {
  final bool value;
  final double size;
  final ValueChanged<bool>? onChanged;

  const CKButtonCheckBox({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 16.0,
  }) : super(key: key);

  @override
  CKButtonCheckBoxState createState() => CKButtonCheckBoxState();
}

class CKButtonCheckBoxState extends State<CKButtonCheckBox> {
  @override
  Widget build(BuildContext context) {
    CKTheme themeManager = CKThemeNotifier.of(context)!.changeNotifier;

    double boxSize = widget.size;

    return GestureDetector(

        onTap: () {
          widget.onChanged?.call(!widget.value);
        },

        child: CustomPaint(
          size: Size(boxSize, boxSize),

          painter: VNTButtonCheckBoxPainter(

              /// Set the action color based on the theme
              colorAccent: themeManager.accent,
              colorAccent200: themeManager.accent200,
              colorBackgroundSecondary0: themeManager.backgroundSecondary0,

              /// Set the isSelected flag based on the widget's value property
              isSelected: widget.value,

              /// Check whether the app has focus
              hasAppFocus: themeManager.isAppFocused,

              /// Set the checkbox size
              size: boxSize,
              isLightTheme: themeManager.isLight),
        ));
  }
}


class VNTButtonCheckBoxPainter extends CustomPainter {
  final Color colorAccent;
  final Color colorAccent200;
  final Color colorBackgroundSecondary0;
  final bool isSelected;
  final bool hasAppFocus;
  final double size;

  final bool isLightTheme;

  VNTButtonCheckBoxPainter({
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
        ..color = CKTheme.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    } else {
      shadowOffset = const Offset(0, -8);
      shadowPaint = Paint()
        ..color = CKTheme.black.withOpacity(0.5)
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
    Color outerColor = CKTheme.grey;
    if (!isLightTheme) {
      outerColor = CKTheme.grey600;
    }
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = outerColor;

    canvas.drawRRect(roundedSquare, paint);

    if (isSelected) {
      Color selectColor = CKTheme.white;
      if (isLightTheme && !hasAppFocus) {
        selectColor = CKTheme.black;
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
    return oldDelegate.colorAccent != colorAccent ||
        oldDelegate.colorAccent200 != colorAccent200 ||
        oldDelegate.colorBackgroundSecondary0 != colorBackgroundSecondary0 ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.hasAppFocus != hasAppFocus ||
        oldDelegate.size != size;
  }
}
