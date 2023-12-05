import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Documented by: Alex Chica
/// A picker for checklists in Flutter applications, allowing users to select from a list of options.
///
/// The [CDKPickerCheckList] widget provides a picker for checklists with customizable options,
/// size, and initial selected index. It supports a callback function to handle the selected option.
///
/// <img src="/flutter_cupertino_desktop_kit/gh-pages/doc-images/CDKButtonColor_0.png" alt="CDKButtonColor Example 1" style="max-width: 500px; width: 100%;">
/// <img src="/flutter_cupertino_desktop_kit/gh-pages/doc-images/CDKButtonColor_0.png" alt="CDKButtonColor Example 1" style="max-width: 500px; width: 100%;">
///
/// ```dart
/// CDKPickerCheckList(
///   options: ['Option 1', 'Option 2', 'Option 3'],
///   size: 12.0,
///   selectedIndex: 0,
///   onSelected: (index) {
///     // Handle the selected option
///   },
/// )
/// ```
///
/// Parameters:
/// * `options`: The list of options to be displayed in the picker.
/// * `size`: The size of the picker. Defaults to `12.0`.
/// * `selectedIndex`: The index of the initially selected option.
/// * `onSelected`: A callback function that is called when an option is selected.
class CDKPickerCheckList extends StatefulWidget {
  final List<String> options;
  final int selectedIndex;
  final double size;
  final Function(int)? onSelected;

  const CDKPickerCheckList({
    Key? key,
    required this.options,
    this.size = 12.0,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  CDKPickerCheckListState createState() => CDKPickerCheckListState();
}

class CDKPickerCheckListState extends State<CDKPickerCheckList> {
  int? _hoverIndex;

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex < 0 ||
        widget.selectedIndex >= widget.options.length) {
      throw Exception(
          "CDKPickerCheckListState initState: selectedIndex must be between 0 and options.length");
    }
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return IntrinsicWidth(
        child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 300, // Alçada màxima de 300 pixels
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(widget.options.length, (index) {
            bool isSelected = index == widget.selectedIndex;
            bool isHovered = index == _hoverIndex;
            return MouseRegion(
                onEnter: (_) => setState(() => _hoverIndex = index),
                onExit: (_) => setState(() => _hoverIndex = null),
                child: GestureDetector(
                  onTap: () => widget.onSelected?.call(index),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: isHovered ? theme.accent : CDKTheme.transparent,
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
