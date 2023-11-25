import 'package:flutter/cupertino.dart';
import 'cx_theme_notifier.dart';
import 'cx_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CXButtonHelp extends StatefulWidget {
  /// The size of the button and the question mark icon.
  final double size;

  /// A callback function that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// Creates a DSKButtonHelp widget.
  const CXButtonHelp({
    Key? key,
    this.onPressed,
    this.size = 24.0,
  }) : super(key: key);

  @override
  CXButtonHelpState createState() => CXButtonHelpState();
}

/// The state of the `DSKButtonHelp` widget.
class CXButtonHelpState extends State<CXButtonHelp> {
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
    CXTheme theme = CXThemeNotifier.of(context)!.changeNotifier;

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
                  ? CXTheme.grey50
                  : CXTheme.grey500
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
              ? Border.all(color: CXTheme.grey70)
              : Border.all(color: CXTheme.grey600),
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
