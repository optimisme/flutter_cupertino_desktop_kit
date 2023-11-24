import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// A customizable button widget that displays an icon and triggers a callback function when tapped.
///
/// It uses [GestureDetector] to handle tap events and [MouseRegion] to handle hover events.
///
/// The widget can be customized using the following properties:
///
/// * `onPressed`: (VoidCallback?) A callback function that is called when the button is tapped.
/// * `icon`: (IconData) The icon to display on the button.
/// * `size`: (double) The size of the button in logical pixels.
/// * `isCircle`: (bool) Whether the button should be circular or rectangular.
/// * `isSelected`: (bool) Whether the button is currently selected.
class DSKButtonIcon extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final bool isCircle;
  final bool isSelected;

  const DSKButtonIcon({
    Key? key,
    this.onPressed,
    this.icon = CupertinoIcons.bell_fill,
    this.size = 24.0,
    this.isCircle = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  DSKButtonIconState createState() => DSKButtonIconState();
}

/// The state of the `DSKButtonIcon` widget.
class DSKButtonIconState extends State<DSKButtonIcon> {
  /// Whether the button is currently pressed.
  bool _isPressed = false;

  /// Whether the mouse is currently hovering over the button.
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    DSKThemeManager().addListener(_update);
  }

  @override
  void dispose() {
    DSKThemeManager().removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

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
    DSKThemeManager themeManager = DSKThemeManager();

    final Color backgroundColor = themeManager.isLight
        ? _isPressed
            ? DSKColors.grey75
            : _isHovering
                ? DSKColors.grey50
                : widget.isSelected
                    ? DSKColors.backgroundSecondary1
                    : DSKColors.transparent
        : _isPressed
            ? DSKColors.grey
            : _isHovering
                ? DSKColors.grey600
                : widget.isSelected
                    ? DSKColors.backgroundSecondary1
                    : DSKColors.transparent;

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
                      color: widget.isSelected && themeManager.isAppFocused
                          ? DSKColors.accent
                          : DSKColors.text,
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
                      color: DSKColors.text,
                      size: widget.size * 0.75,
                    )),
              ),
      ),
    );
  }
}
