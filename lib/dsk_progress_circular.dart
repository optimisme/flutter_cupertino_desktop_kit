import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKProgressCircular extends StatefulWidget {
  final double progress;
  final bool isIndeterminate;
  final bool isRunning;

  const DSKProgressCircular({
    Key? key,
    this.progress = 0.0,
    this.isIndeterminate = false,
    this.isRunning = false,
  }) : super(key: key);

  @override
  DSKProgressCircularState createState() => DSKProgressCircularState();
}

class DSKProgressCircularState extends State<DSKProgressCircular>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation; // Animació per al progrés
  Timer? _timer;
  final int _animationMillis = 500;
  final int _animationMillisIndeterminate = 1500;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animationMillis),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ))
      ..addListener(() {
        setState(() {});
      });

    if (!widget.isIndeterminate) {
      _controller.value = widget.progress;
    }

    if (widget.isIndeterminate && widget.isRunning) {
      startIndeterminateAnimation();
    }
  }

  @override
  void didUpdateWidget(DSKProgressCircular oldWidget) {
    super.didUpdateWidget(oldWidget);
    super.didUpdateWidget(oldWidget);
    if (widget.isIndeterminate != oldWidget.isIndeterminate ||
        widget.isRunning != oldWidget.isRunning) {
      if (widget.isIndeterminate && widget.isRunning) {
        startIndeterminateAnimation();
      } else {
        stopIndeterminateAnimation();
      }
    } else if (!widget.isIndeterminate) {
      if (oldWidget.progress >= 0.95 && widget.progress <= 0.05) {
        // Si el canvi és de 100 a 0, actualitza directament el progress sense animació
        _controller.value = 0.0;
        _controller.duration = const Duration(milliseconds: 0);
        _progressAnimation =
            Tween<double>(begin: 0.0, end: 0.0).animate(_controller);
      } else if (widget.progress != oldWidget.progress) {
        // En cas contrari, crea una nova Tween i inicia l'animació
        _controller.duration = Duration(milliseconds: _animationMillis);
        var tween = Tween<double>(
            begin: _progressAnimation.value, end: widget.progress);
        _progressAnimation = tween.animate(_controller)
          ..addListener(() {
            setState(() {});
          });
        _controller.forward(from: 0.0);
      }
    }
  }

  void startIndeterminateAnimation() {
    _controller.duration =
        Duration(milliseconds: _animationMillisIndeterminate);
    _timer?.cancel();
    _timer = Timer(Duration.zero, () {
      _controller.forward();
    });

    _controller.addStatusListener(_statusListener);
  }

  void stopIndeterminateAnimation() {
    _timer?.cancel();
    _controller.stop();
    _controller.removeStatusListener(_statusListener);
    _controller.reset();
    _controller.duration = Duration(milliseconds: _animationMillis);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.repeat();
    } else if (status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DSKThemeManager themeManager = DSKThemeManager();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ProgressCircularPainter(
              actionColor: DSKColors.accent,
              backgroundColor: DSKColors.backgroundSecondary1,
              progress: widget.isIndeterminate
                  ? _controller.value
                  : _progressAnimation.value,
              isIndeterminate: widget.isIndeterminate,
              isIndeterminateAnimating: _controller.isAnimating,
              hasAppFocus: themeManager.isAppFocused,
              isLightTheme: themeManager.isLight),
          child: child,
        );
      },
      child: Container(), // Aquest és el child que no es reconstruirà
    );
  }
}

class ProgressCircularPainter extends CustomPainter {
  final Color actionColor;
  final Color backgroundColor;
  final double progress;
  final bool isIndeterminate;
  final bool isIndeterminateAnimating;
  final bool hasAppFocus;
  final bool isLightTheme;
  ProgressCircularPainter(
      {required this.actionColor,
      required this.backgroundColor,
      required this.progress,
      required this.isIndeterminate,
      this.isIndeterminateAnimating = false,
      this.hasAppFocus = true,
      required this.isLightTheme});

  @override
  void paint(Canvas canvas, Size size) {
    const double pi = 3.14;
    const double circleDiameter = 32.0;
    const double radius = circleDiameter / 2;

    // For indeterminate state, animate the opacity of the progress circle
    if (isIndeterminate) {
      // Dimensions de les línies
      const double lineWidth = 2.0; // Ample de la línia
      const double lineLength = 6.0; // Longitud de la línia
      const double lineSpacing = 4.0; // Espaiat entre les línies

      // Centre del cercle
      final Offset center = Offset(size.width / 2, size.height / 2);

      // Calcula l'angle entre les línies
      const double angleIncrement = (2 * pi) / 8;

      // Dibuixa les 8 línies amb colors canviants
      for (int i = 0; i < 8; i++) {
        // Calcula l'angle actual de la línia
        final double lineAngle = i * angleIncrement;

        // Calcula el color de la línia basat en l'animació
        Color lineColor = backgroundColor;
        if (isIndeterminateAnimating) {
          final double normalizedProgress = (progress * 8) % 8;
          double diff = (normalizedProgress - i).abs();
          if (diff > 4) diff = 8 - diff;
          final int alpha = (255 * (1 - (diff / 4))).toInt().clamp(0, 255);
          if (isLightTheme) {
            lineColor = DSKColors.grey700.withAlpha(alpha);
          } else {
            lineColor = DSKColors.grey.withAlpha(alpha);
          }
        }

        // Defineix el punt d'inici i final de la línia
        final Offset start = center +
            Offset(math.cos(lineAngle), math.sin(lineAngle)) *
                (radius - lineLength - lineSpacing);
        final Offset end = start +
            Offset(math.cos(lineAngle), math.sin(lineAngle)) * lineLength;

        // Dibuixa cada línia amb les vores arrodonides
        Paint linePaint = Paint()
          ..color = lineColor
          ..strokeCap = StrokeCap
              .round // Això fa que les vores de la línia siguin arrodonides
          ..style = PaintingStyle.stroke
          ..strokeWidth = lineWidth;

        canvas.drawLine(start, end, linePaint);
      }
    } else {
      Paint backgroundPaint = Paint()
        ..color = DSKColors.backgroundSecondary1
        ..style = PaintingStyle.fill;

      Paint progressPaint = Paint()
        ..color = hasAppFocus ? actionColor : DSKColors.grey
        ..style = PaintingStyle.fill;

      // Center the circle within the canvas
      final Offset center = Offset(size.width / 2, size.height / 2);

      // Draw the background circle
      canvas.drawCircle(center, radius, backgroundPaint);

      // Calcula l'angle de barrida per al progrés determinat
      final double sweepAngle = 2 * pi * progress;
      // Crear un camí pel sector circular
      Path path = Path()..moveTo(center.dx, center.dy);
      if (progress <= 0.5) {
        // Si el progrés és menor o igual al 50%, dibuixarà només un sector
        path.lineTo(center.dx, center.dy - radius);
        path.arcToPoint(
          Offset(center.dx + radius * math.sin(sweepAngle),
              center.dy - radius * math.cos(sweepAngle)),
          radius: const Radius.circular(radius),
          clockwise: true,
        );
      } else {
        // Si el progrés és major que 50%, primer completa la primera meitat
        path.lineTo(center.dx, center.dy - radius);
        path.arcToPoint(
          Offset(center.dx, center.dy + radius),
          radius: const Radius.circular(radius),
          clockwise: true,
        );
        // Després completa la segona meitat fins al progrés actual
        path.arcToPoint(
          Offset(center.dx + radius * math.sin(sweepAngle),
              center.dy - radius * math.cos(sweepAngle)),
          radius: const Radius.circular(radius),
          clockwise: true,
        );
      }
      path.close();

      // Dibuixar el camí
      canvas.drawPath(path, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressCircularPainter oldDelegate) {
    return oldDelegate.actionColor != actionColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progress != progress ||
        oldDelegate.hasAppFocus != hasAppFocus ||
        oldDelegate.isIndeterminate != isIndeterminate ||
        oldDelegate.isLightTheme != isLightTheme ||
        oldDelegate.isIndeterminateAnimating != isIndeterminateAnimating;
  }
}
