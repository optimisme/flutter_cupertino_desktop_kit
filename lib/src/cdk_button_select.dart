import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';
import 'cdk_picker_check_list.dart';
import 'cdk_dialogs_manager.dart';
import 'cdk_dialog_popover.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonSelect extends StatefulWidget {
  final int selectedIndex;
  final bool isFlat;
  final bool isTranslucent;
  final List<String> options;
  final ValueChanged<int>? onSelected;

  const CDKButtonSelect({
    super.key,
    required this.selectedIndex,
    required this.options,
    this.isFlat = false,
    this.isTranslucent = false,
    this.onSelected,
  });

  @override
  State<CDKButtonSelect> createState() => _CDKButtonSelectState();
}

class _CDKButtonSelectState extends State<CDKButtonSelect> {
  static const double _fontSize = 12.0;
  static const EdgeInsets _buttonPadding = EdgeInsets.fromLTRB(8, 3, 4, 3);
  static const double _labelSpacing = 5.0;
  static const double _iconPadding = 1.0;
  bool _isMouseOver = false;
  final GlobalKey _globalKey = GlobalKey();
  final CDKDialogController _popoverController = CDKDialogController();

  /// Method to show a popover list when the button is tapped.
  _showPopover(BuildContext context) {
    final anchorContext = _globalKey.currentContext;
    final anchorRenderObject = anchorContext?.findRenderObject();
    final anchorWidth =
        anchorRenderObject is RenderBox ? anchorRenderObject.size.width : null;

    // Show popover with selectable options.
    CDKDialogsManager.showPopover(
      context: context,
      anchorKey: _globalKey,
      type: CDKDialogPopoverType.center,
      isAnimated: false,
      isTranslucent: widget.isTranslucent,
      showBackgroundShade: false,
      controller: _popoverController,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: anchorWidth ?? 0),
          child: CDKPickerCheckList(
            options: widget.options,
            selectedIndex: widget.selectedIndex,
            onSelected: (int index) {
              _popoverController.close();
              widget.onSelected?.call(index);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    BoxDecoration decoration;
    TextStyle textStyle;
    BoxShadow shadow = BoxShadow(
      color: CDKTheme.black.withValues(alpha: 0.1),
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

    final naturalWidth = _measureButtonWidth(
      context: context,
      textStyle: textStyle,
      label: widget.options[widget.selectedIndex],
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shouldStretch = constraints.hasTightWidth ||
              constraints.minWidth > (naturalWidth + 0.001);
          final buttonWidth = shouldStretch
              ? (constraints.hasTightWidth
                  ? constraints.maxWidth
                  : constraints.minWidth)
              : naturalWidth;

          final button = DecoratedBox(
            key: _globalKey,
            decoration: decoration,
            child: Padding(
              padding: _buttonPadding,
              child: Row(
                mainAxisSize:
                    shouldStretch ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (shouldStretch)
                    Expanded(
                      child: DefaultTextStyle(
                        style: textStyle,
                        child: Text(
                          widget.options[widget.selectedIndex],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  else
                    DefaultTextStyle(
                      style: textStyle,
                      child: Text(
                        widget.options[widget.selectedIndex],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(width: _labelSpacing),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: !widget.isFlat
                          ? theme.isAppFocused
                              ? theme.accent300
                              : CDKTheme.transparent
                          : _isMouseOver
                              ? null
                              : theme.backgroundSecondary1,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(_iconPadding),
                          child: Icon(
                            CupertinoIcons.chevron_up_chevron_down,
                            color: !widget.isFlat &&
                                    theme.isLight &&
                                    theme.isAppFocused
                                ? CDKTheme.white
                                : theme.colorText,
                            size: _fontSize * 1.2,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );

          return GestureDetector(
            onTapDown: (details) => _showPopover(context),
            child: SizedBox(width: buttonWidth, child: button),
          );
        },
      ),
    );
  }

  double _measureButtonWidth({
    required BuildContext context,
    required TextStyle textStyle,
    required String label,
  }) {
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);

    final textPainter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: 1,
    )..layout();

    return textPainter.width +
        _buttonPadding.left +
        _buttonPadding.right +
        _labelSpacing +
        (_fontSize * 1.2) +
        (_iconPadding * 2);
  }
}
