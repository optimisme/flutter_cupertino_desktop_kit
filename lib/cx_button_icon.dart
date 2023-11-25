import 'package:flutter/cupertino.dart';
import 'cx_theme_notifier.dart';
import 'cx_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CXButtonIcon extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final bool isCircle;
  final bool isSelected;

  const CXButtonIcon({
    Key? key,
    this.onPressed,
    this.icon = CupertinoIcons.bell_fill,
    this.size = 24.0,
    this.isCircle = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  CXButtonIconState createState() => CXButtonIconState();
}

/// The state of the `DSKButtonIcon` widget.
class CXButtonIconState extends State<CXButtonIcon> {
  /// Whether the button is currently pressed.
  bool _isPressed = false;

  /// Whether the mouse is currently hovering over the button.
  bool _isHovering = false;

  /// Handles the `onTapDown` event, updating the `_isPressed` state variable.
  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  /// Handles the `onTapUp` event, updating the `_isPressed` state variable and calling the `onPressed` callback function.
  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  /// Handles the `onTapCancel` event, updating the `_isPressed` state variable.
  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  /// Handles the `onEnter` event, updating the `_isHovering` state variable.
  void _onMouseEnter(PointerEvent details) {
    setState(() => _isHovering = true);
  }

  /// Handles the `onExit` event, updating the `_isHovering` state variable.
  void _onMouseExit(PointerEvent details) {
    setState(() => _isHovering = false);
  }

  @override
  Widget build(BuildContext context) {
    CXTheme theme = CXThemeNotifier.of(context)!.changeNotifier;

    final Color backgroundColor = theme.isLight
        ? _isPressed
            ? CXTheme.grey70
            : _isHovering
                ? CXTheme.grey50
                : widget.isSelected
                    ? theme.backgroundSecondary1
                    : CXTheme.transparent
        : _isPressed
            ? CXTheme.grey
            : _isHovering
                ? CXTheme.grey600
                : widget.isSelected
                    ? theme.backgroundSecondary1
                    : CXTheme.transparent;

    return MouseRegion(
      onEnter: _onMouseEnter,
      onExit: _onMouseExit,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onPressed,
        child: widget.isCircle
            ? DecoratedBox(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(widget.size)),
                child: Container(
                    width: widget.size,
                    height: widget.size,
                    alignment: Alignment.center,
                    child: Icon(
                      widget.icon,
                      color: widget.isSelected && theme.isAppFocused
                          ? theme.accent
                          : theme.colorText,
                      size: widget.size * 0.5, // Icona més petita que el botó
                    )),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                    width: widget.size,
                    height: widget.size,
                    alignment: Alignment.center,
                    child: Icon(
                      widget.icon,
                      color: theme.colorText,
                      size: widget.size * 0.75,
                    )),
              ),
      ),
    );
  }
}
