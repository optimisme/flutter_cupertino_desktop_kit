import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Class `DSKButtonsUpDown` - A custom widget that creates a pair of up and down buttons.
///
/// This widget is typically used for incrementing or decrementing values.
///
/// Parameters:
/// * `enabledUp`: (bool) Determines if the up button is enabled.
/// * `enabledDown`: (bool) Determines if the down button is enabled.
/// * `onUpPressed`: (VoidCallback?) Callback called when the up button is pressed.
/// * `onDownPressed`: (VoidCallback?) Callback called when the down button is pressed.
class DSKButtonsUpDown extends StatefulWidget {
  final bool enabledUp;
  final bool enabledDown;
  final VoidCallback? onUpPressed;
  final VoidCallback? onDownPressed;

  const DSKButtonsUpDown({
    Key? key,
    this.enabledUp = true,
    this.enabledDown = true,
    this.onUpPressed,
    this.onDownPressed,
  }) : super(key: key);

  @override
  DSKButtonsUpDownState createState() => DSKButtonsUpDownState();
}

/// Class `DSKButtonsUpDownState` - The state for `DSKButtonsUpDown`.
///
/// Manages the state and rendering of the up and down buttons.
class DSKButtonsUpDownState extends State<DSKButtonsUpDown> {
  bool _isPressedUp = false; // State flag for the up button press.
  bool _isPressedDown = false; // State flag for the down button press.

  @override
  Widget build(BuildContext context) {
    DSKThemeManager themeManager = DSKThemeManager();

    // Definim l'ombra per al relleu
    var shadow = const BoxShadow(
      color: DSKColors.grey200, // Ajusta el color per obtenir un gris
      spreadRadius: 0,
      blurRadius: 0.25,
      offset: Offset(0, 0.5),
    );

    Color backgroundUp = !_isPressedUp
        ? DSKColors.backgroundSecondary0
        : themeManager.isLight
            ? DSKColors.backgroundSecondary1
            : DSKColors.grey;

    Color backgroundDown = !_isPressedDown
        ? DSKColors.backgroundSecondary0
        : themeManager.isLight
            ? DSKColors.backgroundSecondary1
            : DSKColors.grey;

    // Estil per al botó amunt
    var decorationUp = BoxDecoration(
      color: backgroundUp,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
      ),
      border: Border.all(
        color: DSKColors.grey,
        width: 0.5,
      ),
      boxShadow: [shadow],
    );

    // Estil per al botó avall
    var decorationDown = BoxDecoration(
      color: backgroundDown,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
      ),
      border: Border.all(
        color: DSKColors.grey,
        width: 0.5,
      ),
      boxShadow: [shadow],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTapDown: !widget.enabledUp
              ? null
              : (details) => setState(() => _isPressedUp = true),
          onTapUp: !widget.enabledUp
              ? null
              : (details) => setState(() => _isPressedUp = false),
          onTapCancel: !widget.enabledUp
              ? null
              : () => setState(() => _isPressedUp = false),
          onTap: !widget.enabledUp ? null : widget.onUpPressed,
          child: IntrinsicWidth(
              child: DecoratedBox(
            decoration: decorationUp,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 1, 2, 0),
              child: Icon(CupertinoIcons.chevron_up,
                  size: 9,
                  color: widget.enabledUp ? DSKColors.black : DSKColors.grey75),
            ),
          )),
        ),
        GestureDetector(
          onTapDown: !widget.enabledDown
              ? null
              : (details) => setState(() => _isPressedDown = true),
          onTapUp: !widget.enabledDown
              ? null
              : (details) => setState(() => _isPressedDown = false),
          onTapCancel: !widget.enabledDown
              ? null
              : () => setState(() => _isPressedDown = false),
          onTap: !widget.enabledDown ? null : widget.onDownPressed,
          child: IntrinsicWidth(
              child: DecoratedBox(
            decoration: decorationDown,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 1, 2, 0),
              child: Icon(CupertinoIcons.chevron_down,
                  size: 9,
                  color:
                      widget.enabledDown ? DSKColors.black : DSKColors.grey75),
            ),
          )),
        ),
      ],
    );
  }
}
