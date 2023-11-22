import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

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

class DSKButtonsUpDownState extends State<DSKButtonsUpDown> {
  bool _isPressedUp = false;
  bool _isPressedDown = false;

  @override
  Widget build(BuildContext context) {
    // Definim l'ombra per al relleu
    var shadow = const BoxShadow(
      color: DSKColors.grey200, // Ajusta el color per obtenir un gris
      spreadRadius: 0,
      blurRadius: 0.25,
      offset: Offset(0, 0.5),
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
