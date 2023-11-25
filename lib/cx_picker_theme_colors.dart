import 'package:flutter/cupertino.dart';
import 'cx_theme_notifier.dart';
import 'cx_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CXPickerThemeColors extends StatefulWidget {
  /// Map of color names to color values.
  final Map<String, Color> colors;

  /// Name of the currently selected color.

  /// Callback for color selection.
  final Function(String)? onColorChanged;

  const CXPickerThemeColors({
    Key? key,
    required this.colors,
    this.onColorChanged,
  }) : super(key: key);

  @override
  CXPickerThemeColorsState createState() => CXPickerThemeColorsState();
}

/// Class `DSKButtonsColorsState` - The state for `DSKButtonsColors`.
///
/// Manages the rendering of the color selection buttons.
class CXPickerThemeColorsState extends State<CXPickerThemeColors> {
  @override
  Widget build(BuildContext context) {
    CXTheme theme = CXThemeNotifier.of(context)!.changeNotifier;

    // Index to keep track of each color's position.
    int index = -1;
    return Wrap(
      children: widget.colors.entries.map((entry) {
        final String colorName = entry.key;
        final Color color = entry.value;
        Color colorBorder = color;

        // Adjust the border color based on the theme and color brightness.
        if (theme.isLight) {
          colorBorder = CXTheme.adjustColor(color, 1, 0.75);
        } else {
          colorBorder = CXTheme.adjustColor(color, 1, 1.25);
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
                        color: CXTheme.white,
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
