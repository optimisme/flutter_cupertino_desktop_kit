import 'package:flutter/cupertino.dart';
import 'cx_theme_notifier.dart';
import 'cx_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// Custom enum for button styles
enum CXButtonStyle { action, normal, destructive }

class CXButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final CXButtonStyle style;
  final bool isLarge;
  final bool enabled;

  const CXButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.style = CXButtonStyle.normal,
    this.isLarge = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  CXButtonState createState() => CXButtonState();
}

/// Class `DSKButtonState` - The state for `DSKButton`.
///
/// Manages the state and rendering of the customizable button.
class CXButtonState extends State<CXButton> {
  // Default font size.
  static const double _fontSize = 12.0;

  // Flag to track if the button is currently pressed.
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    CXTheme theme = CXThemeNotifier.of(context)!.changeNotifier;

    // Define styles and themes based on the button's state and style.
    BoxDecoration decoration;
    Color color;
    TextStyle textStyle;
    IconThemeData iconTheme;
    BoxShadow shadow = BoxShadow(
      color: CXTheme.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

    // Styling logic depending on the button's style and state.
    if (!widget.enabled) {
      switch (widget.style) {
        case CXButtonStyle.action:
          decoration = BoxDecoration(
              color: theme.isAppFocused ? theme.accent200 : CXTheme.grey200,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = theme.isAppFocused ? theme.accent600 : CXTheme.grey;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;

        case CXButtonStyle.normal:
        case CXButtonStyle.destructive:
          decoration = BoxDecoration(
              color: theme.backgroundSecondary0,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = CXTheme.grey;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;
      }
    } else {
      switch (widget.style) {
        case CXButtonStyle.action:
          if (theme.isAppFocused) {
            decoration = BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _isPressed
                      ? [theme.accent100, theme.accent]
                      : [theme.accent300, theme.accent500],
                ),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [shadow]);
            color = _isPressed ? theme.accent50 : CXTheme.white;
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: color,
            );
            iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          } else {
            decoration = BoxDecoration(
                color:
                    _isPressed ? CXTheme.grey200 : theme.backgroundSecondary0,
                border: Border.all(color: theme.backgroundSecondary1),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [shadow]);
            color = CXTheme.black;
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: color,
            );
            iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          }
          break;

        case CXButtonStyle.destructive:
          decoration = BoxDecoration(
              color: theme.isLight
                  ? _isPressed
                      ? CXTheme.grey50
                      : CXTheme.white
                  : _isPressed
                      ? CXTheme.grey500
                      : theme.backgroundSecondary0,
              border: theme.isLight
                  ? Border.all(color: CXTheme.grey70)
                  : Border.all(color: CXTheme.grey600),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = CXTheme.red;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;

        default:
          decoration = BoxDecoration(
              color: theme.isLight
                  ? _isPressed
                      ? CXTheme.grey50
                      : CXTheme.white
                  : _isPressed
                      ? CXTheme.grey500
                      : theme.backgroundSecondary0,
              border: theme.isLight
                  ? Border.all(color: CXTheme.grey70)
                  : Border.all(color: CXTheme.grey600),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = theme.colorText;
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
