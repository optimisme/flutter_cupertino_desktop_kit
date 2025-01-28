import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerThemeColors extends StatefulWidget {
  final Map<String, Color> colors;
  final Function(String)? onColorChanged;

  const CDKPickerThemeColors({
    super.key,
    required this.colors,
    this.onColorChanged,
  });

  @override
  CDKPickerThemeColorsState createState() => CDKPickerThemeColorsState();
}

class CDKPickerThemeColorsState extends State<CDKPickerThemeColors> {
  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    // Index to keep track of each color's position.
    int index = -1;
    return Wrap(
      children: widget.colors.entries.map((entry) {
        final String colorName = entry.key;
        final Color color = entry.value;
        Color colorBorder = color;

        // Adjust the border color based on the theme and color brightness.
        if (theme.isLight) {
          colorBorder = CDKTheme.adjustColor(color, 1, 0.75);
        } else {
          colorBorder = CDKTheme.adjustColor(color, 1, 1.25);
        }
        index = index + 1;
        return GestureDetector(
          onTap: () {
            theme.setAccentColour(colorName);
            widget.onColorChanged?.call(colorName);
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
            child: Center(
              child: theme.colorConfig == colorName
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CDKTheme.white,
                      ),
                    )
                  : null, // Si no està seleccionat, no mostra res
            ),
          ),
        );
      }).toList(),
    );
  }
}
