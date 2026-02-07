import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerButtonsSegmented extends StatefulWidget {
  final List<Widget> options;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;
  final bool isAccent;

  const CDKPickerButtonsSegmented({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.isAccent = false,
  });

  @override
  State<CDKPickerButtonsSegmented> createState() =>
      _CDKPickerButtonsSegmentedState();
}

class _CDKPickerButtonsSegmentedState extends State<CDKPickerButtonsSegmented> {
  final int _animationMillis = 200;
  final List<GlobalKey> _keys = <GlobalKey>[];
  final List<Rect> _rects = <Rect>[];
  bool _positionsScheduled = false;
  double _width = 0.0;

  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
  };

  @override
  void initState() {
    super.initState();
    _validateSelectedIndex();
    _syncOptionKeys();
    _schedulePositionCalculation();
  }

  @override
  void didUpdateWidget(covariant CDKPickerButtonsSegmented oldWidget) {
    super.didUpdateWidget(oldWidget);
    _validateSelectedIndex();

    if (oldWidget.options.length != widget.options.length) {
      _syncOptionKeys();
      _rects.clear();
    }

    _schedulePositionCalculation();
  }

  void _validateSelectedIndex() {
    if (widget.selectedIndex < 0 ||
        widget.selectedIndex >= widget.options.length) {
      throw Exception(
          '_CDKPickerButtonsSegmentedState: selectedIndex must be between 0 and options.length');
    }
  }

  void _syncOptionKeys() {
    if (_keys.length == widget.options.length) {
      return;
    }

    _keys
      ..clear()
      ..addAll(
          List<GlobalKey>.generate(widget.options.length, (_) => GlobalKey()));
  }

  void _schedulePositionCalculation() {
    if (_positionsScheduled) {
      return;
    }

    _positionsScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _positionsScheduled = false;
      if (mounted) {
        _calculatePositions();
      }
    });
  }

  void _calculatePositions() {
    final rowBox = context.findRenderObject();
    if (rowBox is! RenderBox || !rowBox.attached) {
      return;
    }

    final nextRects = <Rect>[];
    for (final key in _keys) {
      final optionContext = key.currentContext;
      if (optionContext == null || !optionContext.mounted) {
        _schedulePositionCalculation();
        return;
      }
      final optionRenderObject = optionContext.findRenderObject();
      if (optionRenderObject is! RenderBox || !optionRenderObject.attached) {
        _schedulePositionCalculation();
        return;
      }

      final position =
          optionRenderObject.localToGlobal(Offset.zero, ancestor: rowBox);
      final size = optionRenderObject.size;
      nextRects.add(
          Rect.fromLTWH(position.dx, position.dy, size.width, size.height));
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _width = rowBox.size.width;
      _rects
        ..clear()
        ..addAll(nextRects);
    });
  }

  double _getPositionLeft(int index) {
    if (index == 0) {
      return 2;
    }

    final previous = index - 1;
    final previousEnd = _rects[previous].left + _rects[previous].width;
    return (_rects[index].left - previousEnd) / 2 + previousEnd;
  }

  double _getPositionWidth(int index) {
    if (index == (_rects.length - 1)) {
      var padding = 3.0;
      if (widget.isAccent) {
        padding = 2.0;
      }
      return _width - _getPositionLeft(index) - padding;
    }

    final positionLeft = _getPositionLeft(index);
    final nextLeft = _getPositionLeft(index + 1);
    return nextLeft - positionLeft;
  }

  Widget _fixWidgetStyle(Widget widget, Color color) {
    if (widget is Text) {
      const size = 12.0;
      return Text(
        widget.data!,
        style: widget.style?.copyWith(color: color, fontSize: size) ??
            TextStyle(color: color, fontSize: size),
      );
    }
    if (widget is Icon) {
      return Icon(widget.icon, color: color, size: 14.0);
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final colors = CDKThemeNotifier.colorTokensOf(context);
    final runtime = CDKThemeNotifier.runtimeTokensOf(context);

    return RepaintBoundary(
      child: Semantics(
        container: true,
        label: 'Segmented control',
        child: FocusTraversalGroup(
          policy: ReadingOrderTraversalPolicy(),
          child: Container(
            height: 24,
            decoration: widget.isAccent
                ? const BoxDecoration()
                : BoxDecoration(
                    color: colors.backgroundSecondary1,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: CDKTheme.grey300, width: 0.5),
                  ),
            child: Stack(
              children: [
                if (_rects.isNotEmpty)
                  AnimatedPositioned(
                    duration: Duration(milliseconds: _animationMillis),
                    curve: Curves.easeInOut,
                    left: _getPositionLeft(widget.selectedIndex),
                    top: 2,
                    width: _getPositionWidth(widget.selectedIndex),
                    height: _rects[widget.selectedIndex].height - 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.isAccent
                            ? runtime.isAppFocused
                                ? colors.accent
                                : CDKTheme.grey300
                            : runtime.isAppFocused
                                ? colors.backgroundSecondary0
                                : CDKTheme.grey300,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: widget.isAccent
                            ? const []
                            : [
                                BoxShadow(
                                  color: CDKTheme.black.withValues(alpha: 0.15),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                )
                              ],
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.options.length, (index) {
                    final isSelected = index == widget.selectedIndex;
                    final isEnabled = widget.onSelected != null;
                    final textColor =
                        widget.isAccent && isSelected && runtime.isAppFocused
                            ? CDKTheme.white
                            : colors.colorText;

                    return Semantics(
                      button: true,
                      selected: isSelected,
                      enabled: isEnabled,
                      onTap: isEnabled
                          ? () => widget.onSelected?.call(index)
                          : null,
                      child: FocusableActionDetector(
                        enabled: isEnabled,
                        mouseCursor: isEnabled
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.basic,
                        shortcuts: _shortcuts,
                        actions: <Type, Action<Intent>>{
                          ActivateIntent: CallbackAction<ActivateIntent>(
                            onInvoke: (intent) {
                              widget.onSelected?.call(index);
                              return null;
                            },
                          ),
                        },
                        child: GestureDetector(
                          key: _keys[index],
                          behavior: HitTestBehavior.opaque,
                          onTap: isEnabled
                              ? () => widget.onSelected?.call(index)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: TweenAnimationBuilder<Color?>(
                              duration: const Duration(milliseconds: 200),
                              tween: ColorTween(
                                  begin: colors.colorText, end: textColor),
                              builder: (context, color, child) {
                                return _fixWidgetStyle(
                                  widget.options[index],
                                  color ?? colors.colorText,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
