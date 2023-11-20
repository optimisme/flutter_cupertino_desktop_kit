import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';
import 'dsk_button.dart'; // Assuming this is the file name of your DSKButton widget

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
  @override
  Widget build(BuildContext context) {
  // Definim l'ombra per al relleu
  var shadow = BoxShadow(
    color: DSKColors.grey200, // Ajusta el color per obtenir un gris
    spreadRadius: 0,
    blurRadius: 0.25,
    offset: const Offset(0, 0.5),
  );

  // Estil per al botó amunt
  var decorationUp = BoxDecoration(
    color: DSKColors.backgroundSecondary0,
    borderRadius: BorderRadius.only(
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
    color: DSKColors.backgroundSecondary0,
    borderRadius: BorderRadius.only(
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
          onTap: widget.isDisabled ? null : widget.onUpPressed,
          child: IntrinsicWidth(
              child: DecoratedBox(
            decoration: decorationUp,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 1, 2, 0),
              child: Icon(CupertinoIcons.chevron_up, size: 9, color: DSKColors.black),
            ),
          )),
        ),
        GestureDetector(
          onTap: widget.isDisabled ? null : widget.onDownPressed,
          child: IntrinsicWidth(
              child: DecoratedBox(
            decoration: decorationDown,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 1),
                            child: Icon(CupertinoIcons.chevron_down, size: 9, color: DSKColors.black),

            ),
          )),
        ),
      ],
    );
  }
}
