import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

class DSKButtonsUpDown extends StatefulWidget {
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final bool isDisabled;

  const DSKButtonsUpDown({
    Key? key,
    required this.onUpPressed,
    required this.onDownPressed,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  DSKButtonsUpDownState createState() => DSKButtonsUpDownState();
}

class DSKButtonsUpDownState extends State<DSKButtonsUpDown> {
  bool _isPressedUp = false;
  bool _isPressedDown = false;

  @override
  Widget build(BuildContext context) {
    // Definim l'ombra per al relleu
    var shadow = BoxShadow(
      color: DSKColors.grey200, // Ajusta el color per obtenir un gris
      spreadRadius: 0,
      blurRadius: 0.25,
      offset: const Offset(0, 0.5),
    );

    Color backgroundUp = !_isPressedUp
        ? DSKColors.backgroundSecondary0
        : DSKThemeManager.isLight
            ? DSKColors.backgroundSecondary1
            : DSKColors.grey;

    Color backgroundDown = !_isPressedDown
        ? DSKColors.backgroundSecondary0
        : DSKThemeManager.isLight
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
          onTapDown: widget.isDisabled
              ? null
              : (details) => setState(() => _isPressedUp = true),
          onTapUp: widget.isDisabled
              ? null
              : (details) => setState(() => _isPressedUp = false),
          onTapCancel: widget.isDisabled
              ? null
              : () => setState(() => _isPressedUp = false),
          onTap: widget.isDisabled ? null : widget.onUpPressed,
          child: IntrinsicWidth(
              child: DecoratedBox(
            decoration: decorationUp,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(2, 1, 2, 0),
              child: Icon(CupertinoIcons.chevron_up,
                  size: 9, color: DSKColors.black),
            ),
          )),
        ),
        GestureDetector(
          onTapDown: widget.isDisabled
              ? null
              : (details) => setState(() => _isPressedDown = true),
          onTapUp: widget.isDisabled
              ? null
              : (details) => setState(() => _isPressedDown = false),
          onTapCancel: widget.isDisabled
              ? null
              : () => setState(() => _isPressedDown = false),
          onTap: widget.isDisabled ? null : widget.onDownPressed,
          child: IntrinsicWidth(
              child: DecoratedBox(
            decoration: decorationDown,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(2, 0, 2, 1),
              child: Icon(CupertinoIcons.chevron_down,
                  size: 9, color: DSKColors.black),
            ),
          )),
        ),
      ],
    );
  }
}
