import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Documented by: D. Sanchez.
///
/// `CDKButtonIcon` is a custom Flutter widget representing a button with an icon.
///
/// This button responds to tap and hover events, changing its appearance accordingly.
/// The button can be customized with an icon, size, shape, and an optional
/// callback function (`onPressed`) to be executed when the button is tapped.
///
/// <img src="/flutter_cupertino_desktop_kit/gh-pages/doc-images/CDKButtonIcon_0.png" alt="CDKButtonIcon Example" style="max-width: 500px; width: 100%;">
///
/// ## Example
/// ```dart
/// // Example usage within a widget tree
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return CDKButtonIcon(
///       onPressed: () {
///         // Handle button tap
///         // ...
///       },
///       icon: CupertinoIcons.bell_fill,
///       size: 24.0,
///       isCircle: false,
///       isSelected: false,
///     );
///   }
/// }
/// ```
///
/// /// The `CDKButtonIcon` widget responds to the following parameters:
///
/// - `onPressed`: A callback function to be executed when the button is tapped.
/// - `icon`: The icon to be displayed on the button. Defaults to `CupertinoIcons.bell_fill`.
/// - `size`: The size of the button. Defaults to 24.0.
/// - `isCircle`: A boolean indicating whether the button should have a circular shape. Defaults to `false`.
/// - `isSelected`: A boolean indicating whether the button is selected. Defaults to `false`.
///
/// The button's appearance is influenced by the current theme provided by `CDKThemeNotifier`.
/// It adapts its color, shape, and icon size based on the press state, hover state, and theme settings.
///

class CDKButtonIcon extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final bool isCircle;
  final bool isSelected;

  const CDKButtonIcon({
    Key? key,
    this.onPressed,
    this.icon = CupertinoIcons.bell_fill,
    this.size = 24.0,
    this.isCircle = false,
    this.isSelected = false,
  }) : super(key: key);

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
