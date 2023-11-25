import 'package:flutter/cupertino.dart';
import 'dsk_theme_notifier.dart';
import 'dsk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Class `DSKButtonsSegmented` - A custom segmented control widget for Flutter.
///
/// This widget creates a row of options, similar to a segmented control, allowing the user to select one option from a group.
///
/// Parameters:
/// * `options`: (List<Widget>) A list of widgets (usually Text or Icon) to be used as options.
/// * `defaultIndex`: (int) The index of the initially selected option.
/// * `onSelect`: (Function(int)?) Callback called when an option is selected.
/// * `isAccent`: (bool) Determines if the accent style should be applied.
class DSKPickerButtonsSegmented extends StatefulWidget {
  final List<Widget> options;
  final int defaultIndex;
  final Function(int)? onSelect;
  final bool isAccent;

  const DSKPickerButtonsSegmented({
    Key? key,
    required this.options,
    this.defaultIndex = 0,
    this.onSelect,
    this.isAccent = false,
  }) : super(key: key);

  @override
  DSKPickerButtonsSegmentedState createState() =>
      DSKPickerButtonsSegmentedState();
}

/// Class `DSKButtonsSegmentedState` - The state for `DSKButtonsSegmented`.
///
/// Manages the state and rendering of the segmented control.
class DSKPickerButtonsSegmentedState extends State<DSKPickerButtonsSegmented> {
  final int _animationMillis =
      200; // Duration of the animation in milliseconds.
  int _selectedIndex = 0; // Currently selected option's index.
  final List<GlobalKey> _keys = []; // Global keys for each option.
  final List<Rect> _rects = []; // Rectangles for the position of each option.
  double _width = 0.0; // Width of the entire widget.

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
    _keys.addAll(List.generate(widget.options.length, (index) => GlobalKey()));
  }

  /// Handles the selection of an option.
  _select(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onSelect?.call(index);
  }

  /// Calculates the positions of each option for the animation.
  void _calculatePositions() {
    _rects.clear();
    RenderBox? rowBox = context.findRenderObject() as RenderBox?;

    if (rowBox != null) {
      _width = rowBox.size.width;
      for (var key in _keys) {
        final RenderBox box =
            key.currentContext?.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero, ancestor: rowBox);
        final size = box.size;
        _rects.add(
            Rect.fromLTWH(position.dx, position.dy, size.width, size.height));
      }
    }

    setState(() {});
  }

  /// Calculates the left position for the animation.
  double _getPositionLeft(int index) {
    if (index == 0) {
      return 2;
    } else {
      int previous = index - 1;
      double previousEnd = _rects[previous].left + _rects[previous].width;
      return (_rects[index].left - previousEnd) / 2 + previousEnd;
    }
  }

  /// Calculates the width for the animated selector.
  double _getPositionWidth(int index) {
    if (index == (_rects.length - 1)) {
      return _width - _getPositionLeft(index) - 3;
    } else {
      double positionLeft = _getPositionLeft(index);
      double nextLeft = _getPositionLeft(index + 1);
      return nextLeft - positionLeft;
    }
  }

  /// Adjusts the widget style based on the state and theme.
  Widget fixWidgetStyle(Widget widget, Color color) {
    if (widget is Text) {
      double size = 12.0;
      return Text(
        widget.data!,
        style: widget.style?.copyWith(color: color, fontSize: size) ??
            TextStyle(color: color, fontSize: size),
      );
    }
    if (widget is Icon) {
      return Icon(
        widget.icon,
        color: color,
        size: 14.0,
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    DSKTheme theme = DSKThemeNotifier.of(context)!.changeNotifier;

    // Schedule a post-frame callback to calculate positions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _calculatePositions();
      }
    });

    return Container(
      height: 24,
      decoration: widget.isAccent
          ? const BoxDecoration()
          : BoxDecoration(
              color: theme.backgroundSecondary1,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: DSKTheme.grey300,
                width: 0.5,
              ),
            ),
      child: Stack(
        children: [
          if (_rects.isNotEmpty)
            AnimatedPositioned(
              duration: Duration(milliseconds: _animationMillis),
              curve: Curves.easeInOut,
              left: _getPositionLeft(_selectedIndex),
              top: 2,
              width: _getPositionWidth(_selectedIndex),
              height: _rects[_selectedIndex].height - 3,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isAccent
                      ? theme.isAppFocused
                          ? theme.accent
                          : DSKTheme.grey300
                      : theme.isAppFocused
                          ? theme.backgroundSecondary0
                          : DSKTheme.grey300,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: widget.isAccent
                      ? []
                      : [
                          BoxShadow(
                            color: DSKTheme.black.withOpacity(0.15),
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
              return GestureDetector(
                  key: _keys[index],
                  onTap: () => _select(index),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 200),
                        tween: ColorTween(
                          begin: theme.text,
                          end: widget.isAccent &&
                                  index == _selectedIndex &&
                                  theme.isAppFocused
                              ? DSKTheme.white
                              : theme.text,
                        ),
                        builder: (BuildContext context, Color? color,
                            Widget? child) {
                          return fixWidgetStyle(widget.options[index], color!);
                        }),
                  ));
            }),
          ),
        ],
      ),
    );
  }
}
