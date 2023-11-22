import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKButtonsSegmented extends StatefulWidget {
  final List<Widget> options;
  final int defaultIndex;
  final Function(int)? onSelect;
  final bool isAccent;

  const DSKButtonsSegmented({
    Key? key,
    required this.options,
    this.defaultIndex = 0,
    this.onSelect,
    this.isAccent = false,
  }) : super(key: key);

  @override
  DSKButtonsSegmentedState createState() => DSKButtonsSegmentedState();
}

class DSKButtonsSegmentedState extends State<DSKButtonsSegmented> {
  final int _animationMillis = 200;
  int _selectedIndex = 0;
  final List<GlobalKey> _keys = [];
  final List<Rect> _rects = [];
  double _width = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
    _keys.addAll(List.generate(widget.options.length, (index) => GlobalKey()));
  }

  _select(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onSelect?.call(index);
  }

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

  double _getPositionLeft(int index) {
    if (index == 0) {
      return 2;
    } else {
      int previous = index - 1;
      double previousEnd = _rects[previous].left + _rects[previous].width;
      return (_rects[index].left - previousEnd) / 2 + previousEnd;
    }
  }

  double _getPositionWidth(int index) {
    if (index == (_rects.length - 1)) {
      return _width - _getPositionLeft(index) - 3;
    } else {
      double positionLeft = _getPositionLeft(index);
      double nextLeft = _getPositionLeft(index + 1);
      return nextLeft - positionLeft;
    }
  }

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
              color: DSKColors.backgroundSecondary1,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: DSKColors.grey300,
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
                      ? DSKThemeManager.isAppFocused
                          ? DSKColors.accent
                          : DSKColors.grey300
                      : DSKThemeManager.isAppFocused
                          ? DSKColors.backgroundSecondary0
                          : DSKColors.grey300,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: widget.isAccent
                      ? []
                      : [
                          BoxShadow(
                            color: DSKColors.black.withOpacity(0.15),
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
                          begin: DSKColors.text,
                          end: widget.isAccent &&
                                  index == _selectedIndex &&
                                  DSKThemeManager.isAppFocused
                              ? DSKColors.white
                              : DSKColors.text,
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
