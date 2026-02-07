import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerSlider extends StatefulWidget {
  final double value;
  final double size;
  final bool enabled;
  final ValueChanged<double>? onChanged;
  final String? semanticLabel;

  const CDKPickerSlider({
    super.key,
    required this.value,
    this.enabled = true,
    this.size = 16,
    required this.onChanged,
    this.semanticLabel,
  });

  @override
  State<CDKPickerSlider> createState() => _CDKPickerSliderState();
}

class _CDKPickerSliderState extends State<CDKPickerSlider> {
  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(
      TraversalDirection.right,
    ),
    SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(
      TraversalDirection.left,
    ),
    SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
      TraversalDirection.up,
    ),
    SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
      TraversalDirection.down,
    ),
  };

  @override
  void initState() {
    super.initState();
    if (widget.value < 0 || widget.value > 1) {
      throw Exception(
          "_CDKPickerSliderState initState: value must be between 0 and 1");
    }
  }

  void _getValue(Offset globalPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.globalToLocal(globalPosition);

    final double radius = renderBox.size.height / 3;
    final circleRail = renderBox.size.width - radius * 2;

    double newValue = ((position.dx - radius) / circleRail).clamp(0.0, 1.0);

    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 1) {
      newValue = 1;
    }

    widget.onChanged?.call(newValue);
  }

  void _onTapDown(TapDownDetails details) {
    _getValue(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _getValue(details.globalPosition);
  }

  void _stepBy(double delta) {
    if (!widget.enabled || widget.onChanged == null) {
      return;
    }
    final next = (widget.value + delta).clamp(0.0, 1.0);
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = CDKThemeNotifier.colorTokensOf(context);
    final runtime = CDKThemeNotifier.runtimeTokensOf(context);
    final isEnabled = widget.enabled && widget.onChanged != null;

    return Semantics(
      slider: true,
      enabled: isEnabled,
      label: widget.semanticLabel ?? 'Slider',
      value: '${(widget.value * 100).round()}%',
      onIncrease: isEnabled ? () => _stepBy(0.05) : null,
      onDecrease: isEnabled ? () => _stepBy(-0.05) : null,
      child: FocusableActionDetector(
        enabled: isEnabled,
        mouseCursor:
            isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        shortcuts: _shortcuts,
        actions: <Type, Action<Intent>>{
          DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
            onInvoke: (intent) {
              switch (intent.direction) {
                case TraversalDirection.left:
                case TraversalDirection.down:
                  _stepBy(-0.05);
                  break;
                case TraversalDirection.right:
                case TraversalDirection.up:
                  _stepBy(0.05);
                  break;
              }
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: !isEnabled ? null : _onTapDown,
          onPanUpdate: !isEnabled ? null : _onPanUpdate,
          child: CustomPaint(
            painter: CDKPickerSliderPainter(
              colorAccent: colors.accent,
              colorBar: colors.backgroundSecondary1,
              colorCircle: colors.backgroundSecondary0,
              value: widget.value,
              hasAppFocus: runtime.isAppFocused, // Border color
            ),
            size: Size(widget.size, widget.size),
          ),
        ),
      ),
    );
  }
}

class CDKPickerSliderPainter extends CustomPainter {
  final Color colorAccent;
  final Color colorBar;
  final Color colorCircle;
  final double value;
  final bool hasAppFocus;

  CDKPickerSliderPainter(
      {required this.colorAccent,
      required this.colorBar,
      required this.colorCircle,
      required this.value,
      this.hasAppFocus = true});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = colorBar
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

    double progressWidth = size.width * value;

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

    // Dibuixar la sombra
    final double radius = size.height / 3;
    final circleRail = size.width - radius * 2;
    final circleProgress = (progressWidth * circleRail) / size.width;
    final Offset center = Offset(radius + circleProgress, size.height / 2);
    final shadowPaint = Paint()
      ..color = CDKTheme.grey50
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(circlePath, shadowPaint.color, 1, false);

    // Dibuixar el cercle principal
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = colorCircle;
    canvas.drawCircle(center, radius, paint);

    final paintBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..color = CDKTheme.grey100;
    canvas.drawCircle(center, radius, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CDKPickerSliderPainter oldDelegate) {
    return oldDelegate.colorAccent != colorAccent ||
        oldDelegate.colorBar != colorBar ||
        oldDelegate.colorCircle != colorCircle ||
        oldDelegate.value != value ||
        oldDelegate.hasAppFocus != hasAppFocus;
  }
}
