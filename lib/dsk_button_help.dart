import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dsk_theme_colors.dart';
import 'dsk_theme_manager.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// A customizable button that displays a question mark icon and triggers a callback function when tapped.
///
/// It uses [GestureDetector] to handle tap events and a [DecoratedBox] to create the button's appearance.
///
/// The widget can be customized using the following properties:
///
/// * `size`: The size of the button and the question mark icon.
/// * `onPressed`: A callback function that is called when the button is tapped.
class DSKButtonHelp extends StatefulWidget {
  /// The size of the button and the question mark icon.
  final double size;

  /// A callback function that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// Creates a DSKButtonHelp widget.
  const DSKButtonHelp({
    Key? key,
    this.onPressed,
    this.size = 24.0,
  }) : super(key: key);

  @override
  DSKButtonHelpState createState() => DSKButtonHelpState();
}

/// The state of the `DSKButtonHelp` widget.
class DSKButtonHelpState extends State<DSKButtonHelp> {
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
    final themeManager = Provider.of<DSKThemeManager>(context);

    /// Creates a GestureDetector widget to handle tap events.
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _isPressed
              ? themeManager.isLight
                  ? DSKColors.grey50
                  : DSKColors.grey500
              : DSKColors.backgroundSecondary0,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: DSKColors.text.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
          border: themeManager.isLight
              ? Border.all(color: DSKColors.grey75)
              : Border.all(color: DSKColors.grey600),
        ),
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          child: Text(
            '?',
            style: TextStyle(
              fontSize: widget.size / 1.5,
              color: DSKColors.text,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
