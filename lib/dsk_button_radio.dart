import 'package:flutter/cupertino.dart';
import 'dsk_theme_notifier.dart';
import 'dsk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Class `DSKButtonRadio` - A custom radio button widget for Flutter.
///
/// This class creates a radio button widget with custom design and behavior.
/// It can be used where exclusive selection of options is needed.
///
/// Parameters:
/// * `isSelected`: (bool) Indicates whether the radio button is currently selected.
/// * `onSelected`: (ValueChanged<bool>?) Callback called when the selection state of the button changes.
/// * `size`: (double) The size of the button in logical pixels.
/// * `label`: (String) Text associated with the radio button.
class DSKButtonRadio extends StatefulWidget {
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final double size;
  final Widget child; // Propietat per al label

  const DSKButtonRadio({
    Key? key,
    this.isSelected = false,
    this.onSelected,
    this.size = 16.0,
    required this.child, // Requereix el label al crear l'objecte
  }) : super(key: key);

  @override
  DSKButtonRadioState createState() => DSKButtonRadioState();
}

/// Class `DSKButtonRadioState` - The state for `DSKButtonRadio`.
///
/// Manages the state and rendering of the radio button.
class DSKButtonRadioState extends State<DSKButtonRadio> {
  @override
  Widget build(BuildContext context) {
    DSKTheme theme = DSKThemeNotifier.of(context)!.changeNotifier;

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
        ..color = DSKTheme.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    } else {
      shadowOffset = const Offset(0, -8);
      shadowPaint = Paint()
        ..color = DSKTheme.black.withOpacity(0.5)
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
    Color outerColor = DSKTheme.grey;
    if (!isLightTheme) {
      outerColor = DSKTheme.grey600;
    }
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = outerColor;

    canvas.drawCircle(center, radius, paint);

    if (isSelected) {
      Color selectColor = DSKTheme.white;
      if (isLightTheme && !hasAppFocus) {
        selectColor = DSKTheme.black;
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
