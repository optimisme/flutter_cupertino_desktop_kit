import 'package:flutter/material.dart';
import 'dsk_theme_colors.dart';
import 'dsk_theme_manager.dart';

class DSKButtonsColors extends StatefulWidget {
  final Map<String, Color> colors;
  final String selectedColor;
  final Function(String) onColorChanged;

  const DSKButtonsColors({
    Key? key,
    required this.colors,
    this.selectedColor = "systemBlue",
    required this.onColorChanged,
  }) : super(key: key);

  @override
  DSKButtonsColorsState createState() => DSKButtonsColorsState();
}

class DSKButtonsColorsState extends State<DSKButtonsColors> {
  @override
  Widget build(BuildContext context) {
  int index = -1;
    return Row(
      children: widget.colors.entries.map((entry) {
        final String colorName = entry.key;
        final Color color = entry.value;
        Color colorBorder = color;

        if (DSKThemeManager.isLight) {
          colorBorder = DSKColors.adjustColor(color, 1, 0.75);
        } else {
          colorBorder = DSKColors.adjustColor(color, 1, 1.25);
        }
        index = index + 1;
        return GestureDetector(
          onTap: () {
            widget.onColorChanged(
                colorName); // Pots passar el nom del color com a paràmetre
          },
          child: Container(
            width: 16,
            height: 16,
            margin: index == 0 ? null : const EdgeInsets.only(left: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: colorBorder, width: 1.25),
            ),
            child: widget.selectedColor ==
                    colorName // Comprova si aquest color està seleccionat
                ? const Icon(
                    size: 8,
                    Icons.circle,
                    color: Colors.white,
                  )
                : Container(),
          ),
        );
        print(index);
      }).toList(),
    );
  }
}
