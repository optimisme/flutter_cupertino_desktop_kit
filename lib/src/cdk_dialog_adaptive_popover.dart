import 'package:flutter/cupertino.dart';

import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

typedef CDKAdaptivePopoverGeometryResolver = CDKAdaptivePopoverGeometry
    Function({
  required Size childSize,
  required Rect anchorRect,
  required Size screenSize,
  required double screenPadding,
});

typedef CDKAdaptivePopoverSurfaceBuilder = Widget Function({
  required BuildContext context,
  required Widget dialogContents,
  required CDKAdaptivePopoverGeometry geometry,
  required Rect anchorRect,
  required Color backgroundColor,
  required bool isLightTheme,
  required bool isTranslucent,
});

class CDKAdaptivePopoverGeometry {
  const CDKAdaptivePopoverGeometry({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  static CDKAdaptivePopoverGeometry lerp(
    CDKAdaptivePopoverGeometry a,
    CDKAdaptivePopoverGeometry b,
    double t,
  ) {
    return CDKAdaptivePopoverGeometry(
      left: lerpDouble(a.left, b.left, t),
      top: lerpDouble(a.top, b.top, t),
      width: lerpDouble(a.width, b.width, t),
      height: lerpDouble(a.height, b.height, t),
    );
  }

  bool isCloseTo(
    CDKAdaptivePopoverGeometry other, {
    double tolerance = 0.1,
  }) {
    return (left - other.left).abs() <= tolerance &&
        (top - other.top).abs() <= tolerance &&
        (width - other.width).abs() <= tolerance &&
        (height - other.height).abs() <= tolerance;
  }

  static double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

class CDKAdaptivePopoverContainer extends StatefulWidget {
  const CDKAdaptivePopoverContainer({
    super.key,
    required this.anchorKey,
    required this.isAnimated,
    required this.isTranslucent,
    required this.animateContentResize,
    required this.onHide,
    required this.child,
    required this.geometryResolver,
    required this.surfaceBuilder,
    this.resizeAnimationDuration = const Duration(milliseconds: 180),
  });

  final GlobalKey anchorKey;
  final bool isAnimated;
  final bool isTranslucent;
  final bool animateContentResize;
  final VoidCallback? onHide;
  final Widget child;
  final CDKAdaptivePopoverGeometryResolver geometryResolver;
  final CDKAdaptivePopoverSurfaceBuilder surfaceBuilder;
  final Duration resizeAnimationDuration;

  @override
  State<CDKAdaptivePopoverContainer> createState() =>
      _CDKAdaptivePopoverContainerState();
}

class _CDKAdaptivePopoverContainerState
    extends State<CDKAdaptivePopoverContainer> with TickerProviderStateMixin {
  static const int _openAnimationMillis = 200;
  static const double _screenPadding = 10.0;
  static const double _chromePadding = 8.0;
  static const Offset _hiddenOffset = Offset(-10000000, -10000000);

  final GlobalKey _childKey = GlobalKey();

  AnimationController? _openAnimationController;
  Animation<double>? _scaleAnimation;
  late final AnimationController _resizeAnimationController;

  CDKAdaptivePopoverGeometry? _startGeometry;
  CDKAdaptivePopoverGeometry? _targetGeometry;
  Rect? _anchorRect;
  Size? _lastScreenSize;
  bool _hasOpened = false;
  bool _recomputeScheduled = false;

  @override
  void initState() {
    super.initState();

    _configureOpenAnimation();

    _resizeAnimationController = AnimationController(
      duration: widget.resizeAnimationDuration,
      vsync: this,
      value: 1.0,
    )..addListener(_onResizeAnimationTick);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleGeometryRecompute();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleGeometryRecompute();
  }

  @override
  void didUpdateWidget(covariant CDKAdaptivePopoverContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.resizeAnimationDuration != widget.resizeAnimationDuration) {
      _resizeAnimationController.duration = widget.resizeAnimationDuration;
    }

    if (oldWidget.isAnimated != widget.isAnimated) {
      _configureOpenAnimation();
      if (widget.isAnimated && _targetGeometry != null && !_hasOpened) {
        _hasOpened = true;
        _openAnimationController?.forward();
      }
    }

    if (oldWidget.anchorKey != widget.anchorKey ||
        oldWidget.child != widget.child ||
        oldWidget.animateContentResize != widget.animateContentResize) {
      _scheduleGeometryRecompute();
    }
  }

  void _configureOpenAnimation() {
    _openAnimationController?.dispose();
    _openAnimationController = null;
    _scaleAnimation = null;

    if (!widget.isAnimated) {
      return;
    }

    _openAnimationController = AnimationController(
      duration: const Duration(milliseconds: _openAnimationMillis),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _openAnimationController!,
      curve: Curves.easeOutBack,
    );
  }

  void _onResizeAnimationTick() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _openAnimationController?.dispose();
    _resizeAnimationController
      ..removeListener(_onResizeAnimationTick)
      ..dispose();
    super.dispose();
  }

  void _scheduleGeometryRecompute() {
    if (_recomputeScheduled || !mounted) {
      return;
    }
    _recomputeScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recomputeScheduled = false;
      if (!mounted) {
        return;
      }
      _recomputeGeometry();
    });
  }

  void _recomputeGeometry() {
    final childContext = _childKey.currentContext;
    if (childContext == null || !childContext.mounted) {
      return;
    }

    final childRenderObject = childContext.findRenderObject();
    if (childRenderObject is! RenderBox ||
        !childRenderObject.attached ||
        !childRenderObject.hasSize) {
      return;
    }

    final anchorRenderBox = _resolveAnchorRenderBox();
    if (anchorRenderBox == null) {
      _scheduleHideForMissingAnchor();
      return;
    }

    final anchorRect =
        anchorRenderBox.localToGlobal(Offset.zero) & anchorRenderBox.size;
    final screenSize = MediaQuery.sizeOf(context);
    final childSize = childRenderObject.size;

    final nextGeometry = widget.geometryResolver(
      childSize: childSize,
      anchorRect: anchorRect,
      screenSize: screenSize,
      screenPadding: _screenPadding,
    );

    _applyGeometry(nextGeometry, anchorRect);
  }

  RenderBox? _resolveAnchorRenderBox() {
    final anchorContext = widget.anchorKey.currentContext;
    if (anchorContext == null || !anchorContext.mounted) {
      return null;
    }

    final renderObject = anchorContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) {
      return null;
    }

    return renderObject;
  }

  void _scheduleHideForMissingAnchor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onHide?.call();
      }
    });
  }

  void _applyGeometry(
      CDKAdaptivePopoverGeometry nextGeometry, Rect anchorRect) {
    final previousTarget = _targetGeometry;
    final hadGeometry = previousTarget != null;
    final anchorUnchanged =
        _anchorRect != null && _isRectClose(_anchorRect!, anchorRect);

    if (hadGeometry &&
        previousTarget.isCloseTo(nextGeometry) &&
        anchorUnchanged) {
      return;
    }

    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final shouldAnimateResize =
        widget.animateContentResize && !disableAnimations && hadGeometry;

    if (!shouldAnimateResize) {
      _resizeAnimationController
        ..stop()
        ..value = 1.0;
      setState(() {
        _startGeometry = nextGeometry;
        _targetGeometry = nextGeometry;
        _anchorRect = anchorRect;
      });
    } else {
      final displayedGeometry = _displayedGeometry(
        disableResizeAnimation: false,
      );
      _resizeAnimationController
        ..stop()
        ..value = 0.0;
      setState(() {
        _startGeometry = displayedGeometry ?? previousTarget;
        _targetGeometry = nextGeometry;
        _anchorRect = anchorRect;
      });
      _resizeAnimationController.forward();
    }

    if (!_hasOpened) {
      _hasOpened = true;
      _openAnimationController?.forward();
    }
  }

  bool _isRectClose(Rect a, Rect b, {double tolerance = 0.1}) {
    return (a.left - b.left).abs() <= tolerance &&
        (a.top - b.top).abs() <= tolerance &&
        (a.right - b.right).abs() <= tolerance &&
        (a.bottom - b.bottom).abs() <= tolerance;
  }

  CDKAdaptivePopoverGeometry? _displayedGeometry({
    required bool disableResizeAnimation,
  }) {
    final target = _targetGeometry;
    if (target == null) {
      return null;
    }

    if (disableResizeAnimation || !widget.animateContentResize) {
      return target;
    }

    final start = _startGeometry;
    if (start == null) {
      return target;
    }

    final animationValue = Curves.easeOut.transform(
      _resizeAnimationController.value,
    );
    return CDKAdaptivePopoverGeometry.lerp(start, target, animationValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CDKThemeNotifier.of(context)!.changeNotifier;
    final mediaQuery = MediaQuery.maybeOf(context);
    final disableResizeAnimation = mediaQuery?.disableAnimations ?? false;
    final screenSize = mediaQuery?.size;
    if (screenSize != null &&
        (_lastScreenSize == null || _lastScreenSize != screenSize)) {
      _lastScreenSize = screenSize;
      _scheduleGeometryRecompute();
    }

    final backgroundColor = !widget.isTranslucent
        ? theme.background
        : theme.isLight
            ? theme.background.withValues(alpha: 0.25)
            : theme.background.withValues(alpha: 0.5);

    final dialogContents = Container(
      key: _childKey,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: widget.child,
    );

    final measurableDialogContents =
        NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        _scheduleGeometryRecompute();
        return false;
      },
      child: SizeChangedLayoutNotifier(
        child: dialogContents,
      ),
    );

    final geometry = _displayedGeometry(
      disableResizeAnimation: disableResizeAnimation,
    );
    final anchorRect = _anchorRect;
    if (geometry == null || anchorRect == null) {
      return Positioned(
        left: _hiddenOffset.dx,
        top: _hiddenOffset.dy,
        child: measurableDialogContents,
      );
    }

    final dialogWithDecorations = widget.surfaceBuilder(
      context: context,
      dialogContents: measurableDialogContents,
      geometry: geometry,
      anchorRect: anchorRect,
      backgroundColor: backgroundColor,
      isLightTheme: theme.isLight,
      isTranslucent: widget.isTranslucent,
    );

    final dialogBody = widget.isAnimated && _scaleAnimation != null
        ? ScaleTransition(
            scale: _scaleAnimation!,
            child: dialogWithDecorations,
          )
        : dialogWithDecorations;

    return Positioned(
      left: geometry.left - _chromePadding,
      top: geometry.top - _chromePadding,
      width: geometry.width + (_chromePadding * 2),
      height: geometry.height + (_chromePadding * 2),
      child: RepaintBoundary(
        child: dialogBody,
      ),
    );
  }
}
