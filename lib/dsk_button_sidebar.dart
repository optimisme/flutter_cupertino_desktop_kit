import 'package:flutter/cupertino.dart';
import 'dsk_theme_notifier.dart';
import 'dsk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKButtonSidebar extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isAccent;
  final Function() onSelected;
  final Widget child;

  const DSKButtonSidebar({
    Key? key,
    this.onPressed,
    this.isSelected = false,
    this.isAccent = true,
    required this.onSelected,
    required this.child,
  }) : super(key: key);

  @override
  DSKButtonSidebarState createState() => DSKButtonSidebarState();
}

class DSKButtonSidebarState extends State<DSKButtonSidebar> {
  @override
  Widget build(BuildContext context) {
    DSKTheme theme = DSKThemeNotifier.of(context)!.changeNotifier;

    Color colorText =
        theme.getSidebarColorText(widget.isSelected, widget.isAccent);

    Color colorBackground =
        theme.getSidebarColorBackground(widget.isSelected, widget.isAccent);

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onSelected();
        });
      },
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            width: double.infinity,
            padding: widget.child is Text
                ? const EdgeInsets.fromLTRB(8, 6, 8, 8)
                : const EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: colorBackground,
            ),
            child: widget.child is! Text
                ? widget.child
                : Text(
                    (widget.child as Text).data!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (widget.child as Text).style?.copyWith(fontSize: 14) ??
                            TextStyle(fontSize: 14, color: colorText),
                  ),
          )),
    );
  }
}
