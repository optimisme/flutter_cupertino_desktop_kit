import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dsk_theme_manager.dart';
import 'dsk_button_check_list.dart';
import 'dsk_dialogs_manager.dart';
import 'dsk_theme_colors.dart';
import 'dsk_dialog_popover.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Class `DSKButtonSelect` - A custom selectable button widget for Flutter.
///
/// This class creates a dropdown-like button widget that can show a list of selectable options.
///
/// Parameters:
/// * `onSelected`: (Function(int, String)?) Callback called when an option is selected,
///                 passing the index and value of the selected option.
/// * `defaultIndex`: (int) The index of the initially selected option.
/// * `isFlat`: (bool) Determines if the button has a flat design.
/// * `isTranslucent`: (bool) Determines if the button has a translucent effect.
/// * `options`: (List<String>) A list of string options that can be selected.
class DSKButtonSelect extends StatefulWidget {
  final Function(int, String)? onSelected;
  final int defaultIndex;
  final bool isFlat;
  final bool isTranslucent;
  final List<String> options;

  const DSKButtonSelect({
    Key? key,
    this.onSelected,
    required this.defaultIndex,
    required this.options,
    this.isFlat = false,
    this.isTranslucent = false,
  }) : super(key: key);

  @override
  DSKButtonSelectState createState() => DSKButtonSelectState();
}

/// Class `DSKButtonSelectState` - The state for `DSKButtonSelect`.
///
/// Manages the state and rendering of the selectable button.
class DSKButtonSelectState extends State<DSKButtonSelect> {
  // Font size for text.
  static const double _fontSize = 12.0;

  // Hover state flag.
  bool _isMouseOver = false;

  // Currently selected option's index.
  int _selectedIndex = 0;

  // Global key for positioning.
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Method to show a popover list when the button is tapped.
  _showPopover(BuildContext context) {
    final GlobalKey<DSKDialogPopoverState> key = GlobalKey();

    // Show popover with selectable options.
    DSKDialogsManager.showPopover(
      key: key,
      context: context,
      anchorKey: _globalKey,
      type: DSKDialogPopoverType.center,
      isAnimated: false,
      isTranslucent: widget.isTranslucent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: DSKButtonCheckList(
          options: widget.options,
          defaultIndex: _selectedIndex,
          onSelect: (int index, String value) {
            key.currentState?.hide();
            setState(() {
              _selectedIndex = index;
            });
            widget.onSelected?.call(index, value);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<DSKThemeManager>(context);

    BoxDecoration decoration;
    TextStyle textStyle;
    BoxShadow shadow = BoxShadow(
      color: DSKColors.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

    // Apply different styles based on state.
    if (_isMouseOver || !widget.isFlat) {
      decoration = BoxDecoration(
          color: DSKColors.backgroundSecondary0,
          border: Border.all(color: DSKColors.backgroundSecondary1),
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [shadow]);
    } else {
      decoration = const BoxDecoration();
    }

    textStyle = TextStyle(
      fontSize: _fontSize,
      color: DSKColors.text,
    );

    return MouseRegion(
      onEnter: (PointerEvent details) {
        setState(() {
          _isMouseOver = true;
        });
      },
      onExit: (PointerEvent details) {
        setState(() {
          _isMouseOver = false;
        });
      },
      child: GestureDetector(
          onTapDown: (details) => _showPopover(context),
          child: IntrinsicWidth(
            child: DecoratedBox(
              key: _globalKey,
              decoration: decoration,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 3, 4, 3),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DefaultTextStyle(
                        style: textStyle,
                        child: Text(widget.options[_selectedIndex]),
                      ),
                      const SizedBox(width: 5),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: !widget.isFlat
                              ? themeManager.isAppFocused
                                  ? DSKColors.accent300
                                  : DSKColors.transparent
                              : _isMouseOver
                                  ? null
                                  : DSKColors.backgroundSecondary1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Icon(
                                CupertinoIcons.chevron_up_chevron_down,
                                color: !widget.isFlat &&
                                        themeManager.isLight &&
                                        themeManager.isAppFocused
                                    ? DSKColors.white
                                    : DSKColors.text,
                                size: _fontSize * 1.2,
                              ),
                            )),
                      ),
                    ]),
              ),
            ),
          )),
    );
  }
}
