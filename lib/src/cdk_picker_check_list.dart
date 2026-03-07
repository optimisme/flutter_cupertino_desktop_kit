import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerCheckList extends StatefulWidget {
  final List<String> options;
  final int selectedIndex;
  final double size;
  final ValueChanged<int>? onSelected;
  final String? semanticLabel;

  const CDKPickerCheckList({
    super.key,
    required this.options,
    this.size = 12.0,
    required this.selectedIndex,
    required this.onSelected,
    this.semanticLabel,
  });

  @override
  State<CDKPickerCheckList> createState() => _CDKPickerCheckListState();
}

class _CDKPickerCheckListState extends State<CDKPickerCheckList> {
  static const EdgeInsets _itemPadding = EdgeInsets.fromLTRB(4, 2, 4, 6);
  int? _hoverIndex;

  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
  };

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex < 0 ||
        widget.selectedIndex >= widget.options.length) {
      throw Exception(
          '_CDKPickerCheckListState initState: selectedIndex must be between 0 and options.length');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = CDKThemeNotifier.colorTokensOf(context);
    final runtime = CDKThemeNotifier.runtimeTokensOf(context);
    final itemTextStyle = TextStyle(fontSize: widget.size);
    final minimumWidth = _measureMinimumWidth(
      context: context,
      textStyle: itemTextStyle,
    );

    return Semantics(
      container: true,
      label: widget.semanticLabel ?? 'Checklist',
      child: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final resolvedMinWidth = constraints.minWidth > minimumWidth
                ? constraints.minWidth
                : minimumWidth;
            final resolvedWidth =
                constraints.hasTightWidth ? constraints.maxWidth : null;

            final checklist = ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(widget.options.length, (index) {
                    final isSelected = index == widget.selectedIndex;
                    final isHovered = index == _hoverIndex;
                    final isEnabled = widget.onSelected != null;

                    final textColor = runtime.isLight && isHovered
                        ? colors.background
                        : colors.colorText;

                    final item = Container(
                      padding: _itemPadding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: isHovered ? colors.accent : CDKTheme.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: widget.size * 1.5,
                            child: !isSelected
                                ? null
                                : Icon(
                                    CupertinoIcons.check_mark,
                                    size: widget.size,
                                    color: isHovered
                                        ? colors.background
                                        : colors.colorText,
                                  ),
                          ),
                          Expanded(
                            child: Text(
                              widget.options[index],
                              style: itemTextStyle.copyWith(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    );

                    return MouseRegion(
                      onEnter: (_) => setState(() => _hoverIndex = index),
                      onExit: (_) => setState(() => _hoverIndex = null),
                      child: Semantics(
                        button: true,
                        selected: isSelected,
                        enabled: isEnabled,
                        label: widget.options[index],
                        onTap: isEnabled
                            ? () => widget.onSelected?.call(index)
                            : null,
                        child: FocusableActionDetector(
                          enabled: isEnabled,
                          mouseCursor: isEnabled
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic,
                          shortcuts: _shortcuts,
                          actions: <Type, Action<Intent>>{
                            ActivateIntent: CallbackAction<ActivateIntent>(
                              onInvoke: (intent) {
                                widget.onSelected?.call(index);
                                return null;
                              },
                            ),
                          },
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: isEnabled
                                ? () => widget.onSelected?.call(index)
                                : null,
                            child: item,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );

            if (resolvedWidth != null || !constraints.hasBoundedWidth) {
              return SizedBox(
                width: resolvedWidth ?? resolvedMinWidth,
                child: checklist,
              );
            }

            return ConstrainedBox(
              constraints: BoxConstraints(minWidth: resolvedMinWidth),
              child: checklist,
            );
          },
        ),
      ),
    );
  }

  double _measureMinimumWidth({
    required BuildContext context,
    required TextStyle textStyle,
  }) {
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);
    var widestLabel = 0.0;

    for (final option in widget.options) {
      final textPainter = TextPainter(
        text: TextSpan(text: option, style: textStyle),
        textDirection: textDirection,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      if (textPainter.width > widestLabel) {
        widestLabel = textPainter.width;
      }
    }

    return widestLabel +
        _itemPadding.left +
        _itemPadding.right +
        (widget.size * 1.5);
  }
}
