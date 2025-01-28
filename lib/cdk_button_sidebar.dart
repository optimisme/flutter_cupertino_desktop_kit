import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonSidebar extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isAccent;
  final Function() onSelected;
  final Widget child;

  const CDKButtonSidebar({
    super.key,
    this.onPressed,
    this.isSelected = false,
    this.isAccent = true,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    Color colorText = theme.getSidebarColorText(isSelected, isAccent);

    Color colorBackground =
        theme.getSidebarColorBackground(isSelected, isAccent);

    return GestureDetector(
      onTap: onSelected,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            width: double.infinity,
            padding: child is Text
                ? const EdgeInsets.fromLTRB(8, 6, 8, 8)
                : const EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: colorBackground,
            ),
            child: child is Text
                ? Text(
                    (child as Text).data!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (child as Text)
                            .style
                            ?.copyWith(fontSize: 14, color: colorText) ??
                        TextStyle(fontSize: 14, color: colorText),
                  )
                : child,
          )),
    );
  }
}
