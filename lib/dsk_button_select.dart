import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_button_check_list.dart';
import 'dsk_dialogs_manager.dart';
import 'dsk_theme_colors.dart';
import 'dsk_dialog_popover.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

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

class DSKButtonSelectState extends State<DSKButtonSelect> {
  static const double _fontSize = 12.0;
  bool _isMouseOver = false;
  int _selectedIndex = 0;
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

  _showPopover(BuildContext context) {
    final GlobalKey<DSKDialogPopoverState> key = GlobalKey();

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
    BoxDecoration decoration;
    TextStyle textStyle;
    BoxShadow shadow = BoxShadow(
      color: DSKColors.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

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
                              ? DSKThemeManager.isAppFocused
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
                                        DSKThemeManager.isLight &&
                                        DSKThemeManager.isAppFocused
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
