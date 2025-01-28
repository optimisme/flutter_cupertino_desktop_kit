import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonIcon extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final bool isCircle;
  final bool isSelected;

  const CDKButtonIcon({
    super.key,
    this.onPressed,
    this.icon = CupertinoIcons.bell_fill,
    this.size = 24.0,
    this.isCircle = false,
    this.isSelected = false,
  });

  @override
  CDKButtonIconState createState() => CDKButtonIconState();
}

class CDKButtonIconState extends State<CDKButtonIcon> {
  bool _isPressed = false;
  bool _isHovering = false;
  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  void _onMouseEnter(PointerEvent details) {
    setState(() => _isHovering = true);
  }

  void _onMouseExit(PointerEvent details) {
    setState(() => _isHovering = false);
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    final Color backgroundColor = theme.isLight
        ? _isPressed
            ? CDKTheme.grey70
            : _isHovering
                ? CDKTheme.grey50
                : widget.isSelected
                    ? theme.backgroundSecondary1
                    : CDKTheme.transparent
        : _isPressed
            ? CDKTheme.grey
            : _isHovering
                ? CDKTheme.grey600
                : widget.isSelected
                    ? theme.backgroundSecondary1
                    : CDKTheme.transparent;

    final Color textColor = theme.isLight
        ? widget.isSelected && theme.isAppFocused
            ? theme.accent
            : theme.colorText
        : widget.isSelected && theme.isAppFocused
            ? CDKTheme.white
            : theme.colorText;

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
                      color: textColor,
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
                      color: textColor,
                      size: widget.size * 0.75,
                    )),
              ),
      ),
    );
  }
}
