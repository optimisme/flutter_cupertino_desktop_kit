import 'package:flutter/cupertino.dart';
import 'ck_theme_notifier.dart';
import 'ck_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKPickerCheckList extends StatefulWidget {
  /// The list of options to choose from.
  final List<String> options;

  /// The size of the checkmark icon and the font size of the text.
  final int defaultIndex;

  /// The index of the option that is selected by default.
  final double size;

  /// A callback function that is called when an option is selected.
  final Function(int, String)? onSelect;

  /// Creates a DSKButtonCheckList widget.
  const CKPickerCheckList({
    Key? key,
    required this.options,
    this.size = 12.0,
    this.defaultIndex = 0,
    this.onSelect,
  }) : super(key: key);

  @override
  CKPickerCheckListState createState() => CKPickerCheckListState();
}

/// The state of the `DSKButtonCheckBox` widget.
///
/// This class manages the widget's internal state, including the current
/// selection state and the app focus status.
class CKPickerCheckListState extends State<CKPickerCheckList> {
  /// The index of the option that is currently hovered over.
  int? _hoverIndex;

  /// The index of the option that is currently selected.
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _select(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onSelect?.call(index, widget.options[index]);
  }

  @override
  Widget build(BuildContext context) {
    CKTheme theme = CKThemeNotifier.of(context)!.changeNotifier;

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
                      color: isHovered ? theme.accent : CKTheme.transparent,
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
                                        ? theme.background
                                        : theme.colorText)),
                        Text(
                          widget.options[index],
                          style: TextStyle(
                              fontSize: widget.size,
                              color: theme.isLight && isHovered
                                  ? theme.background
                                  : theme.colorText),
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
