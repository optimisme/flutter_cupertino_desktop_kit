import 'package:flutter/cupertino.dart';
import 'ck_theme_notifier.dart';
import 'ck_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// Custom enum for button styles
enum CKButtonStyle { action, normal, destructive }

class CKButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final CKButtonStyle style;
  final bool isLarge;
  final bool enabled;

  const CKButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.style = CKButtonStyle.normal,
    this.isLarge = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  CKButtonState createState() => CKButtonState();
}

/// Class `DSKButtonState` - The state for `DSKButton`.
///
/// Manages the state and rendering of the customizable button.
class CKButtonState extends State<CKButton> {
  // Default font size.
  static const double _fontSize = 12.0;

  // Flag to track if the button is currently pressed.
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    CKTheme theme = CKThemeNotifier.of(context)!.changeNotifier;

    // Define styles and themes based on the button's state and style.
    BoxDecoration decoration;
    Color color;
    TextStyle textStyle;
    IconThemeData iconTheme;
    BoxShadow shadow = BoxShadow(
      color: CKTheme.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

    // Styling logic depending on the button's style and state.
    if (!widget.enabled) {
      switch (widget.style) {
        case CKButtonStyle.action:
          decoration = BoxDecoration(
              color: theme.isAppFocused ? theme.accent200 : CKTheme.grey200,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = theme.isAppFocused ? theme.accent600 : CKTheme.grey;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;

        case CKButtonStyle.normal:
        case CKButtonStyle.destructive:
          decoration = BoxDecoration(
              color: theme.backgroundSecondary0,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = CKTheme.grey;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;
      }
    } else {
      switch (widget.style) {
        case CKButtonStyle.action:
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
            color = _isPressed ? theme.accent50 : CKTheme.white;
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: color,
            );
            iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          } else {
            decoration = BoxDecoration(
                color:
                    _isPressed ? CKTheme.grey200 : theme.backgroundSecondary0,
                border: Border.all(color: theme.backgroundSecondary1),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [shadow]);
            color = CKTheme.black;
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: color,
            );
            iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          }
          break;

        case CKButtonStyle.destructive:
          decoration = BoxDecoration(
              color: theme.isLight
                  ? _isPressed
                      ? CKTheme.grey50
                      : CKTheme.white
                  : _isPressed
                      ? CKTheme.grey500
                      : theme.backgroundSecondary0,
              border: theme.isLight
                  ? Border.all(color: CKTheme.grey70)
                  : Border.all(color: CKTheme.grey600),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = CKTheme.red;
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
                      ? CKTheme.grey50
                      : CKTheme.white
                  : _isPressed
                      ? CKTheme.grey500
                      : theme.backgroundSecondary0,
              border: theme.isLight
                  ? Border.all(color: CKTheme.grey70)
                  : Border.all(color: CKTheme.grey600),
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
