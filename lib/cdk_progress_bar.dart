import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKProgressBar extends StatefulWidget {
  final double value;
  final bool isIndeterminate;
  final bool isRunning;

  const CDKProgressBar({
    super.key,
    this.value = 0.0,
    this.isIndeterminate = false,
    this.isRunning = false,
  });

  @override
  CDKProgressBarState createState() => CDKProgressBarState();
}

class CDKProgressBarState extends State<CDKProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation; // Animació per al progrés
  Timer? _timer;
  final int _animationMillis = 500;
  final int _animationMillisIndeterminate = 1500;

  @override
  void initState() {
    super.initState();

    if (widget.value < 0 || widget.value > 1) {
      throw Exception(
          "CDKProgressBarState initState: value must be between 0 and 1");
    }

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animationMillis),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ))
      ..addListener(() {
        setState(() {});
      });

    if (!widget.isIndeterminate) {
      _controller.value = widget.value;
    }

    if (widget.isIndeterminate && widget.isRunning) {
      startIndeterminateAnimation();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CDKProgressBar oldWidget) {
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
      if (oldWidget.value >= 0.95 && widget.value <= 0.05) {
        // Si el canvi és de 100 a 0, actualitza directament el progress sense animació
        _controller.value = 0.0;
        _controller.duration = const Duration(milliseconds: 0);
        _progressAnimation =
            Tween<double>(begin: 0.0, end: 0.0).animate(_controller);
      } else if (widget.value != oldWidget.value) {
        // En cas contrari, crea una nova Tween i inicia l'animació
        _controller.duration = Duration(milliseconds: _animationMillis);
        var tween =
            Tween<double>(begin: _progressAnimation.value, end: widget.value);
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
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ProgressBarPainter(
              colorAccent: theme.accent,
              backgroundColor: theme.backgroundSecondary1,
              progress: widget.isIndeterminate
                  ? _controller.value
                  : _progressAnimation.value,
              isIndeterminate: widget.isIndeterminate,
              isIndeterminateAnimating: _controller.isAnimating,
              hasAppFocus: theme.isAppFocused),
          child: child,
        );
      },
      child: Container(), // Aquest és el child que no es reconstruirà
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final Color colorAccent;
  final Color backgroundColor;
  final double progress;
  final bool isIndeterminate;
  final bool isIndeterminateAnimating;
  final bool hasAppFocus;

  ProgressBarPainter(
      {required this.colorAccent,
      required this.backgroundColor,
      required this.progress,
      required this.isIndeterminate,
      this.isIndeterminateAnimating = false,
      this.hasAppFocus = true});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Paint progressPaint = Paint()
      ..color = hasAppFocus ? colorAccent : CDKTheme.grey
      ..style = PaintingStyle.fill;

    // Calcula l'alçada i la posició vertical centrada de la barra
    const double barHeight = 6.0;
    const Radius barHeightHalf = Radius.circular(barHeight / 2);
    final double verticalOffset = (size.height - barHeight) / 2;

    // Crea rectangles amb els costats arrodonits
    RRect backgroundRRect = RRect.fromLTRBR(
      0,
      verticalOffset,
      size.width,
      verticalOffset + barHeight,
      const Radius.circular(barHeight /
          2), // El radi és la meitat de l'alçada per fer-ho completament arrodonit
    );

    double progressWidth =
        isIndeterminate ? size.width / 4 : size.width * progress;

    // For indeterminate state
    if (isIndeterminate) {
      double leftProgressStart = size.width * progress - (size.width / 6);
      double progressEnd = leftProgressStart + (size.width / 3);

      // Asegurar que el progrés indeterminat no surti dels límits
      leftProgressStart = leftProgressStart.clamp(0.0, size.width);
      progressEnd = progressEnd.clamp(0.0, size.width);

      RRect progressRRect = RRect.fromLTRBR(
        leftProgressStart,
        verticalOffset,
        progressEnd,
        verticalOffset + barHeight,
        barHeightHalf,
      );

      // Dibuixa el fons i el progrés
      canvas.drawRRect(backgroundRRect, backgroundPaint);
      if (isIndeterminateAnimating) {
        canvas.drawRRect(progressRRect, progressPaint);
      }
    } else {
      RRect progressRRect = RRect.fromLTRBR(
        0,
        verticalOffset,
        progressWidth,
        verticalOffset + barHeight,
        barHeightHalf,
      );

      // Dibuixa el fons i el progrés
      canvas.drawRRect(backgroundRRect, backgroundPaint);
      canvas.drawRRect(progressRRect, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressBarPainter oldDelegate) {
    return oldDelegate.colorAccent != colorAccent ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progress != progress ||
        oldDelegate.hasAppFocus != hasAppFocus ||
        oldDelegate.isIndeterminate != isIndeterminate ||
        oldDelegate.isIndeterminateAnimating != isIndeterminateAnimating;
  }
}
