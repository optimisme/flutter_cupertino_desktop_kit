import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_dialog_outer_shadow_painter.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKDialogModal extends StatefulWidget {
  final bool isAnimated;
  final bool animateContentResize;
  final bool isTranslucent;
  final VoidCallback? onHide;
  final Widget child;

  const CDKDialogModal({
    super.key,
    this.isAnimated = false,
    this.animateContentResize = true,
    this.isTranslucent = false,
    this.onHide,
    required this.child,
  });

  @override
  State<CDKDialogModal> createState() => _CDKDialogModalState();
}

class _CDKDialogModalState extends State<CDKDialogModal>
    with SingleTickerProviderStateMixin {
  static const int _animationMillis = 200;
  static const Duration _resizeAnimationDuration = Duration(milliseconds: 160);
  static const double _screenPadding = 10.0;
  static const double _chromePadding = 8.0;
  static const double _dialogRadius = 8.0;

  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.isAnimated) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: _animationMillis),
        vsync: this,
      );

      _scaleAnimation = CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeOutBack,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _animationController?.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void hide() {
    widget.onHide?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CDKThemeNotifier.of(context)!.changeNotifier;
    final mediaQuery = MediaQuery.maybeOf(context);
    final disableResizeAnimation = mediaQuery?.disableAnimations ?? false;

    final backgroundColor = !widget.isTranslucent
        ? theme.background
        : theme.isLight
            ? theme.background.withValues(alpha: 0.25)
            : theme.background.withValues(alpha: 0.5);

    final dialogContents = DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_dialogRadius)),
      ),
      child: widget.child,
    );

    final dialogSurface = _CDKDialogModalSurface(
      chromePadding: _chromePadding,
      radius: _dialogRadius,
      colorBackground: backgroundColor,
      isLightTheme: theme.isLight,
      child: !widget.isTranslucent
          ? dialogContents
          : ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(_dialogRadius),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                child: dialogContents,
              ),
            ),
    );

    final resizeAnimatedDialog =
        !widget.animateContentResize || disableResizeAnimation
            ? dialogSurface
            : AnimatedSize(
                duration: _resizeAnimationDuration,
                curve: Curves.easeOut,
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                child: dialogSurface,
              );

    final dialogBody = widget.isAnimated && _scaleAnimation != null
        ? ScaleTransition(
            scale: _scaleAnimation!,
            child: resizeAnimatedDialog,
          )
        : resizeAnimatedDialog;

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(_screenPadding),
        child: Align(
          alignment: Alignment.center,
          child: RepaintBoundary(
            child: dialogBody,
          ),
        ),
      ),
    );
  }
}

class _CDKDialogModalSurface extends StatelessWidget {
  const _CDKDialogModalSurface({
    required this.chromePadding,
    required this.radius,
    required this.colorBackground,
    required this.isLightTheme,
    required this.child,
  });

  final double chromePadding;
  final double radius;
  final Color colorBackground;
  final bool isLightTheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CDKDialogModalSurfacePainter(
        chromePadding: chromePadding,
        radius: radius,
        colorBackground: colorBackground,
        isLightTheme: isLightTheme,
      ),
      child: Padding(
        padding: EdgeInsets.all(chromePadding),
        child: child,
      ),
    );
  }
}

class _CDKDialogModalSurfacePainter extends CustomPainter {
  const _CDKDialogModalSurfacePainter({
    required this.chromePadding,
    required this.radius,
    required this.colorBackground,
    required this.isLightTheme,
  });

  final double chromePadding;
  final double radius;
  final Color colorBackground;
  final bool isLightTheme;

  @override
  void paint(Canvas canvas, Size size) {
    final contentWidth = math.max(0.0, size.width - (chromePadding * 2));
    final contentHeight = math.max(0.0, size.height - (chromePadding * 2));
    final contourRect = Rect.fromLTWH(
      chromePadding,
      chromePadding,
      contentWidth,
      contentHeight,
    );
    final pathContour = _createRoundedContourPath(contourRect);

    _drawShadow(canvas, pathContour, size);

    final paintBack = Paint()
      ..color = colorBackground
      ..style = PaintingStyle.fill;
    canvas.drawPath(pathContour, paintBack);

    final paintLine = Paint()
      ..strokeWidth = 0.5
      ..color = isLightTheme ? CDKTheme.grey200 : CDKTheme.grey500
      ..style = PaintingStyle.stroke;
    canvas.drawPath(pathContour, paintLine);
  }

  void _drawShadow(Canvas canvas, Path path, Size size) {
    canvas.save();
    final outerPath = Path()
      ..addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final clipPath = Path.combine(PathOperation.difference, outerPath, path);
    canvas.clipPath(clipPath);

    final shadowColor =
        isLightTheme ? CDKTheme.black.withValues(alpha: 0.5) : CDKTheme.black;
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawShadow(path, shadowPaint.color, 4.0, true);
    canvas.restore();
  }

  Path _createRoundedContourPath(Rect rect) {
    if (radius == 8.0) {
      return CDKDialogOuterShadowPainter.createContourPath(rect);
    }

    final borderRadius = Radius.circular(radius);
    return Path()..addRRect(RRect.fromRectAndRadius(rect, borderRadius));
  }

  @override
  bool shouldRepaint(covariant _CDKDialogModalSurfacePainter oldDelegate) {
    return chromePadding != oldDelegate.chromePadding ||
        radius != oldDelegate.radius ||
        colorBackground != oldDelegate.colorBackground ||
        isLightTheme != oldDelegate.isLightTheme;
  }
}
