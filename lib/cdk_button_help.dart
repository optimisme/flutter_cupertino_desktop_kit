import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Documented by: D. Sanchez.
/// `CDKButtonHelp` is a custom Flutter widget representing a help button with a question mark icon.
///
/// It responds to tap events and changes its appearance accordingly.
/// The button can be customized with a specified size and an optional
/// callback function (`onPressed`) to be executed when the button is tapped.
///
/// <img src="/flutter_cupertino_desktop_kit/gh-pages/doc-images/CDKButtonHelp_0.png" alt="CDKButtonHelp Example" style="max-width: 500px; width: 100%;">

///
/// ## Example
/// ```dart
/// // Example usage within a widget tree
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return CDKButtonHelp(
///       onPressed: () {
///         // Handle button tap
///         // ...
///       },
///       size: 24.0,
///     );
///   }
/// }
/// ```
////// The `CDKButtonHelp` widget responds to the following parameters:
///
/// - `size`: The size of the button. Defaults to 24.0.
/// - `onPressed`: A callback function to be executed when the button is tapped.
///
/// The button's appearance is influenced by the current theme provided by `CDKThemeNotifier`.
/// It adapts its color, shape, and shadow based on the press state and theme settings.
///
class CDKButtonHelp extends StatefulWidget {
  final double size;

  final VoidCallback? onPressed;

  const CDKButtonHelp({
    Key? key,
    this.onPressed,
    this.size = 24.0,
  }) : super(key: key);

  @override
  CDKButtonHelpState createState() => CDKButtonHelpState();
}

class CDKButtonHelpState extends State<CDKButtonHelp> {
  /// Whether the button is currently pressed.
  bool _isPressed = false;

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

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    /// Creates a GestureDetector widget to handle tap events.
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _isPressed
              ? theme.isLight
                  ? CDKTheme.grey50
                  : CDKTheme.grey500
              : theme.backgroundSecondary0,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorText.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
          border: theme.isLight
              ? Border.all(color: CDKTheme.grey70)
              : Border.all(color: CDKTheme.grey600),
        ),
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          child: Text(
            '?',
            style: TextStyle(
              fontSize: widget.size / 1.5,
              color: theme.colorText,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
