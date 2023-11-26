import 'package:flutter/cupertino.dart';
import 'ck_theme_notifier.dart';
import 'ck_theme.dart';
import 'ck_picker_check_list.dart';
import 'ck_dialogs_manager.dart';
import 'ck_dialog_popover.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKButtonSelect extends StatefulWidget {
  final Function(int, String)? onSelected;
  final int defaultIndex;
  final bool isFlat;
  final bool isTranslucent;
  final List<String> options;

  const CKButtonSelect({
    Key? key,
    this.onSelected,
    required this.defaultIndex,
    required this.options,
    this.isFlat = false,
    this.isTranslucent = false,
  }) : super(key: key);

  @override
  CKButtonSelectState createState() => CKButtonSelectState();
}

/// Class `DSKButtonSelectState` - The state for `DSKButtonSelect`.
///
/// Manages the state and rendering of the selectable button.
class CKButtonSelectState extends State<CKButtonSelect> {
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
    final GlobalKey<CKDialogPopoverState> key = GlobalKey();

    // Show popover with selectable options.
    CKDialogsManager.showPopover(
      key: key,
      context: context,
      anchorKey: _globalKey,
      type: CKDialogPopoverType.center,
      isAnimated: false,
      isTranslucent: widget.isTranslucent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CKPickerCheckList(
          options: widget.options,
          selectedIndex: _selectedIndex,
          onSelected: (int index, String value) {
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
    CKTheme theme = CKThemeNotifier.of(context)!.changeNotifier;

    BoxDecoration decoration;
    TextStyle textStyle;
    BoxShadow shadow = BoxShadow(
      color: CKTheme.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

    // Apply different styles based on state.
    if (_isMouseOver || !widget.isFlat) {
      decoration = BoxDecoration(
          color: theme.backgroundSecondary0,
          border: Border.all(color: theme.backgroundSecondary1),
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [shadow]);
    } else {
      decoration = const BoxDecoration();
    }

    textStyle = TextStyle(
      fontSize: _fontSize,
      color: theme.colorText,
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
                              ? theme.isAppFocused
                                  ? theme.accent300
                                  : CKTheme.transparent
                              : _isMouseOver
                                  ? null
                                  : theme.backgroundSecondary1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Icon(
                                CupertinoIcons.chevron_up_chevron_down,
                                color: !widget.isFlat &&
                                        theme.isLight &&
                                        theme.isAppFocused
                                    ? CKTheme.white
                                    : theme.colorText,
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
