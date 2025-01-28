import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonsUpDown extends StatefulWidget {
  final bool enabledUp;
  final bool enabledDown;
  final VoidCallback? onUpPressed;
  final VoidCallback? onDownPressed;

  const CDKButtonsUpDown({
    super.key,
    this.enabledUp = true,
    this.enabledDown = true,
    this.onUpPressed,
    this.onDownPressed,
  });

  @override
  CDKButtonsUpDownState createState() => CDKButtonsUpDownState();
}

class CDKButtonsUpDownState extends State<CDKButtonsUpDown> {
  bool _isPressedUp = false; // State flag for the up button press.
  bool _isPressedDown = false; // State flag for the down button press.

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    // Definim l'ombra per al relleu
    var shadow = const BoxShadow(
      color: CDKTheme.grey200, // Ajusta el color per obtenir un gris
      spreadRadius: 0,
      blurRadius: 0.25,
      offset: Offset(0, 0.5),
    );

    Color backgroundUp = !_isPressedUp
        ? theme.backgroundSecondary0
        : theme.isLight
            ? theme.backgroundSecondary1
            : CDKTheme.grey;

    Color backgroundDown = !_isPressedDown
        ? theme.backgroundSecondary0
        : theme.isLight
            ? theme.backgroundSecondary1
            : CDKTheme.grey;

    Color iconUp = widget.enabledUp
        ? theme.isLight
            ? CDKTheme.black
            : CDKTheme.grey70
        : theme.isLight
            ? CDKTheme.grey70
            : CDKTheme.grey;

    Color iconDown = widget.enabledDown
        ? theme.isLight
            ? CDKTheme.black
            : CDKTheme.grey70
        : theme.isLight
            ? CDKTheme.grey70
            : CDKTheme.grey;

    // Estil per al botó amunt
    var decorationUp = BoxDecoration(
      color: backgroundUp,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
      ),
      border: Border.all(
        color: CDKTheme.grey,
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
        color: CDKTheme.grey,
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
              child: Icon(CupertinoIcons.chevron_up, size: 9, color: iconUp),
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
              child:
                  Icon(CupertinoIcons.chevron_down, size: 9, color: iconDown),
            ),
          )),
        ),
      ],
    );
  }
}
