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

    return Semantics(
      container: true,
      label: widget.semanticLabel ?? 'Checklist',
      child: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: IntrinsicWidth(
          child: ConstrainedBox(
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
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: isHovered ? colors.accent : CDKTheme.transparent,
                    ),
                    child: Row(
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
                        Text(
                          widget.options[index],
                          style: TextStyle(
                              fontSize: widget.size, color: textColor),
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
          ),
        ),
      ),
    );
  }
}
