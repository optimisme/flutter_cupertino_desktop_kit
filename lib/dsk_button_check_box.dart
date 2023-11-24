import 'package:flutter/cupertino.dart';
import 'dsk_app_inherited.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// A customizable checkbox widget that allows the user to toggle a boolean value.
///
/// It uses [GestureDetector] to handle tap events and [AnimatedContainer] to animate the checkbox's appearance.
///
/// The widget can be customized using the following properties:
///
/// * `value`: The initial value of the checkbox.
/// * `size`: The size of the checkbox in logical pixels.
/// * `onChanged`: A callback function that is called when the checkbox is tapped. The callback function receives the new value of the checkbox as a parameter.
class DSKButtonCheckBox extends StatefulWidget {
  /// The current selection state of the checkbox.
  final bool value;

  /// The size of the checkbox in logical pixels.
  /// Defaults to 16.0.
  final double size;

  /// The callback function that is called when the checkbox is tapped.
  /// The function receives the new value of the checkbox as a parameter.
  final ValueChanged<bool>? onChanged;

  const DSKButtonCheckBox({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 16.0,
  }) : super(key: key);

  @override
  DSKButtonCheckBoxState createState() => DSKButtonCheckBoxState();
}

/// The state of the `DSKButtonCheckBox` widget.
///
/// This class manages the widget's internal state, including the current
/// selection state and the app focus status.
class DSKButtonCheckBoxState extends State<DSKButtonCheckBox> {

  @override
  Widget build(BuildContext context) {
    DSKThemeManager themeManager = DSKAppInheritedWidget.of(context)!.changeNotifier; // React to theme changes


    /// Calculate the checkbox size based on the specified size property
    double boxSize = widget.size;

    /// Create a GestureDetector widget to handle tap interactions
    return GestureDetector(

        /// Call the onChanged callback when the checkbox is tapped
        onTap: () {
          widget.onChanged?.call(!widget.value);
        },

        /// Use a CustomPaint widget to draw the checkbox's visual representation
        child: CustomPaint(
          /// Set the size of the CustomPaint widget to match the checkbox size
          size: Size(boxSize, boxSize),

          /// Create a VNTButtonCheckBoxPainter instance to handle the painting
          painter: VNTButtonCheckBoxPainter(

              /// Set the action color based on the theme
              actionColor: DSKColors.accent,
              backgroundColor: DSKColors.backgroundSecondary0,

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

/// The custom painter responsible for drawing the checkbox's visual elements.
///
/// It handles the painting of the checkbox's background, border, and checkmark.
class VNTButtonCheckBoxPainter extends CustomPainter {
  /// The color used for the checkbox's action area
  final Color actionColor;

  /// The color used for the checkbox's background
  final Color backgroundColor;

  /// Whether the checkbox is currently selected
  final bool isSelected;

  /// Whether the app has focus
  final bool hasAppFocus;

  /// The size of the checkbox in logical pixels
  final double size;

  /// Whether the app is using the light theme
  final bool isLightTheme;

  VNTButtonCheckBoxPainter({
    required this.actionColor,
    required this.backgroundColor,
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
        ..color = DSKColors.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    } else {
      shadowOffset = const Offset(0, -8);
      shadowPaint = Paint()
        ..color = DSKColors.black.withOpacity(0.5)
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
        ..color = backgroundColor;
      canvas.drawRRect(roundedSquare, paint);

      drawShadow(canvas, size, squareRect);
    }

    // Draw outer square
    Color outerColor = DSKColors.grey;
    if (!isLightTheme) {
      outerColor = DSKColors.grey600;
    }
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = outerColor;

    canvas.drawRRect(roundedSquare, paint);

    if (isSelected) {
      Color selectColor = DSKColors.white;
      if (isLightTheme && !hasAppFocus) {
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
    return oldDelegate.actionColor != actionColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.hasAppFocus != hasAppFocus ||
        oldDelegate.size != size;
  }
}
