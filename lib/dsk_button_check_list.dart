import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// A customizable button checklist widget that allows the user to select a single option from a list of options.
///
/// It uses [MouseRegion] and [GestureDetector] to handle mouse hover and tap events.
///
/// The widget can be customized using the following properties:
///
/// * `options`: A list of strings representing the options to choose from.
/// * `size`: The size of the checkmark icon and the font size of the text.
/// * `defaultIndex`: The index of the option that is selected by default.
/// * `onSelect`: A callback function that is called when an option is selected. The callback function receives the index of the selected option and the text of the selected option as parameters.
class DSKButtonCheckList extends StatefulWidget {
  /// The list of options to choose from.
  final List<String> options;

  /// The size of the checkmark icon and the font size of the text.
  final int defaultIndex;

  /// The index of the option that is selected by default.
  final double size;

  /// A callback function that is called when an option is selected.
  final Function(int, String)? onSelect;

  /// Creates a DSKButtonCheckList widget.
  const DSKButtonCheckList({
    Key? key,
    required this.options,
    this.size = 12.0,
    this.defaultIndex = 0,
    this.onSelect,
  }) : super(key: key);

  @override
  DSKButtonCheckListState createState() => DSKButtonCheckListState();
}

/// The state of the `DSKButtonCheckBox` widget.
///
/// This class manages the widget's internal state, including the current
/// selection state and the app focus status.
class DSKButtonCheckListState extends State<DSKButtonCheckList> {
  /// The index of the option that is currently hovered over.
  int? _hoverIndex;

  /// The index of the option that is currently selected.
  int _selectedIndex = 0;

  /// Handles the selection of an option.
  ///
  /// Sets the `_selectedIndex` state variable to the index of the selected option and calls the `onSelect` callback function, if it is not null.
  _select(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onSelect?.call(index, widget.options[index]);
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
  }

  @override
  Widget build(BuildContext context) {
    DSKThemeManager themeManager = DSKThemeManager();

    return IntrinsicWidth(
        child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 300, // Alçada màxima de 300 pixels
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(widget.options.length, (index) {
            bool isSelected = index == _selectedIndex;
            bool isHovered = index == _hoverIndex;
            return MouseRegion(
                onEnter: (_) => setState(() => _hoverIndex = index),
                onExit: (_) => setState(() => _hoverIndex = null),
                child: GestureDetector(
                  onTap: () => _select(index),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color:
                          isHovered ? DSKColors.accent : DSKColors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: widget.size * 1.5,
                            child: !isSelected
                                ? null
                                : Icon(CupertinoIcons.check_mark,
                                    size: widget.size,
                                    color: isHovered
                                        ? DSKColors.background
                                        : DSKColors.text)),
                        Text(
                          widget.options[index],
                          style: TextStyle(
                              fontSize: widget.size,
                              color: themeManager.isLight && isHovered
                                  ? DSKColors.background
                                  : DSKColors.text),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
        ),
      ),
    ));
  }
}
