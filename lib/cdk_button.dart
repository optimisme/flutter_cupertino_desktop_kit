import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Custom enum for button styles
enum CDKButtonStyle { action, normal, destructive }

/// A customizable button widget for Flutter applications.
///
/// The [CDKButton] allows for various styles, sizes, and states, making it versatile
/// for different UI needs.
///
/// ![CDKButton Example](gh-pages/doc-images/CDKButton_0.png)
///
/// ```dart
/// CDKButton(
///   onPressed: () {
///     // Handle button press
///   },
///   child: Text('Click Me'),
///   style: CDKButtonStyle.action,
///   isLarge: true,
/// )
/// ```
///
/// Parameters:
/// * `onPressed`: A callback function that is called when the button is pressed.
///   If null, the button will be disabled.
/// * `child`: The content of the button. Typically a `Text` or `Icon` widget.
/// * `style`: The style of the button, with options like `action`, `normal`,
///   and `destructive`. Defaults to `normal`.
/// * `isLarge`: A flag to determine if the button should be displayed in a large
///   size. Defaults to `false`.
/// * `enabled`: A flag to enable or disable the button. Defaults to `true`.
class CDKButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final CDKButtonStyle style;
  final bool isLarge;
  final bool enabled;

  const CDKButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.style = CDKButtonStyle.normal,
    this.isLarge = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  CDKButtonState createState() => CDKButtonState();
}

class CDKButtonState extends State<CDKButton> {
  // Default font size.
  static const double _fontSize = 12.0;

  // Flag to track if the button is currently pressed.
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    // Define styles and themes based on the button's state and style.
    BoxDecoration decoration;
    Color color;
    TextStyle textStyle;
    IconThemeData iconTheme;
    BoxShadow shadow = BoxShadow(
      color: CDKTheme.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

    // Styling logic depending on the button's style and state.
    if (!widget.enabled) {
      switch (widget.style) {
        case CDKButtonStyle.action:
          decoration = BoxDecoration(
              color: theme.isAppFocused ? theme.accent200 : CDKTheme.grey200,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = theme.isAppFocused ? theme.accent600 : CDKTheme.grey;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;

        case CDKButtonStyle.normal:
        case CDKButtonStyle.destructive:
          decoration = BoxDecoration(
              color: theme.backgroundSecondary0,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = CDKTheme.grey;
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: color,
          );
          iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          break;
      }
    } else {
      switch (widget.style) {
        case CDKButtonStyle.action:
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
            color = _isPressed ? theme.accent50 : CDKTheme.white;
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: color,
            );
            iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          } else {
            decoration = BoxDecoration(
                color:
                    _isPressed ? CDKTheme.grey200 : theme.backgroundSecondary0,
                border: Border.all(color: theme.backgroundSecondary1),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [shadow]);
            color = CDKTheme.black;
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: color,
            );
            iconTheme = IconThemeData(color: color, size: _fontSize + 2);
          }
          break;

        case CDKButtonStyle.destructive:
          decoration = BoxDecoration(
              color: theme.isLight
                  ? _isPressed
                      ? CDKTheme.grey50
                      : CDKTheme.white
                  : _isPressed
                      ? CDKTheme.grey500
                      : theme.backgroundSecondary0,
              border: theme.isLight
                  ? Border.all(color: CDKTheme.grey70)
                  : Border.all(color: CDKTheme.grey600),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          color = CDKTheme.red;
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
                      ? CDKTheme.grey50
                      : CDKTheme.white
                  : _isPressed
                      ? CDKTheme.grey500
                      : theme.backgroundSecondary0,
              border: theme.isLight
                  ? Border.all(color: CDKTheme.grey70)
                  : Border.all(color: CDKTheme.grey600),
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
