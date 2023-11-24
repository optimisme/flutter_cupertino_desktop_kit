import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// Custom enum for button styles
enum DSKButtonStyle { action, normal, destructive }

/// Class `DSKButton` - A customizable button widget for Flutter.
///
/// This class creates a button widget with various styles and behaviors.
/// It supports different styles, sizes, and states (enabled/disabled).
///
/// Parameters:
/// * `onPressed`: (VoidCallback?) Callback called when the button is pressed.
/// * `child`: (Widget) The content of the button, usually a text or icon.
/// * `style`: (DSKButtonStyle) The style of the button (action, normal, destructive).
/// * `isLarge`: (bool) Determines if the button is of a large size.
/// * `enabled`: (bool) Determines if the button is enabled or disabled.
class DSKButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final DSKButtonStyle style;
  final bool isLarge;
  final bool enabled;

  const DSKButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.style = DSKButtonStyle.normal,
    this.isLarge = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  DSKButtonState createState() => DSKButtonState();
}

/// Class `DSKButtonState` - The state for `DSKButton`.
///
/// Manages the state and rendering of the customizable button.
class DSKButtonState extends State<DSKButton> {
  // Default font size.
  static const double _fontSize = 12.0;

  // Flag to track if the button is currently pressed.
  bool _isPressed = false;

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

  @override
  Widget build(BuildContext context) {
    DSKThemeManager themeManager = DSKThemeManager();

    // Define styles and themes based on the button's state and style.
    BoxDecoration decoration;
    Color color;
    TextStyle textStyle;
    IconThemeData iconTheme;
    BoxShadow shadow = BoxShadow(
      color: DSKColors.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

    // Styling logic depending on the button's style and state.
    if (!widget.enabled) {
      switch (widget.style) {
        case DSKButtonStyle.action:
          decoration = BoxDecoration(
              color: themeManager.isAppFocused
                  ? DSKColors.accent200
                  : DSKColors.grey200,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color =
              themeManager.isAppFocused ? DSKColors.accent600 : DSKColors.grey;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;

        case DSKButtonStyle.normal:
        case DSKButtonStyle.destructive:
          decoration = BoxDecoration(
              color: DSKColors.backgroundSecondary0,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = DSKColors.grey;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;
      }
    } else {
      switch (widget.style) {
        case DSKButtonStyle.action:
          if (themeManager.isAppFocused) {
            decoration = BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _isPressed
                      ? [DSKColors.accent100, DSKColors.accent]
                      : [DSKColors.accent300, DSKColors.accent500],
                ),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [shadow]);
            color = _isPressed ? DSKColors.accent50 : DSKColors.white;
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: color,
            );
            iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          } else {
            decoration = BoxDecoration(
                color: _isPressed
                    ? DSKColors.grey200
                    : DSKColors.backgroundSecondary0,
                border: Border.all(color: DSKColors.backgroundSecondary1),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [shadow]);
            color = DSKColors.black;
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: color,
            );
            iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          }
          break;

        case DSKButtonStyle.destructive:
          decoration = BoxDecoration(
              color: themeManager.isLight
                  ? _isPressed
                      ? DSKColors.grey50
                      : DSKColors.white
                  : _isPressed
                      ? DSKColors.grey500
                      : DSKColors.backgroundSecondary0,
              border: themeManager.isLight
                  ? Border.all(color: DSKColors.grey75)
                  : Border.all(color: DSKColors.grey600),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = DSKColors.red;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;

        default:
          decoration = BoxDecoration(
              color: themeManager.isLight
                  ? _isPressed
                      ? DSKColors.grey50
                      : DSKColors.white
                  : _isPressed
                      ? DSKColors.grey500
                      : DSKColors.backgroundSecondary0,
              border: themeManager.isLight
                  ? Border.all(color: DSKColors.grey75)
                  : Border.all(color: DSKColors.grey600),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = DSKColors.text;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
      }
    }

    return GestureDetector(
      onTapDown: !widget.enabled
          ? null
          : (details) => setState(() => _isPressed = true),
      onTapUp: !widget.enabled
          ? null
          : (details) => setState(() => _isPressed = false),
      onTapCancel:
          !widget.enabled ? null : () => setState(() => _isPressed = false),
      onTap: !widget.enabled ? null : widget.onPressed,
      child: IntrinsicWidth(
          child: DecoratedBox(
        decoration: decoration,
        child: Padding(
          padding: widget.isLarge
              ? const EdgeInsets.fromLTRB(8, 8, 8, 10)
              : widget.child is Text
                  ? const EdgeInsets.fromLTRB(8, 3, 8, 5)
                  : const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: widget.child is Text
              ? DefaultTextStyle(
                  style: textStyle,
                  child: widget.child,
                )
              : widget.child is Icon
                  ? IconTheme.merge(data: iconTheme, child: widget.child)
                  : widget.child,
        ),
      )),
    );
  }
}
