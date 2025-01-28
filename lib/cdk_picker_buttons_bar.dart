import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKPickerButtonsBar extends StatefulWidget {
  /// List of button options.
  final List<bool> selectedStates;
  final List<Widget> options;

  /// Callback for selection changes.
  final Function(List<bool>)? onChanged;

  /// Flag for multiple selection.
  final bool allowsMultipleSelection;

  const CDKPickerButtonsBar({
    super.key,
    required this.selectedStates,
    required this.options,
    this.onChanged,
    this.allowsMultipleSelection = false,
  });

  @override
  CDKPickerButtonsBarState createState() => CDKPickerButtonsBarState();
}

class CDKPickerButtonsBarState extends State<CDKPickerButtonsBar> {
  // Border radius for button edges.
  final double _borderRadius = 4.0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedStates.length != widget.options.length) {
      throw Exception(
          "CDKPickerButtonsBarState initState: selectedStates and options must have the same length");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Handles tap events on buttons, updating the selection state.
  void _buttonTapped(int index) {
    setState(() {
      if (widget.allowsMultipleSelection) {
        widget.selectedStates[index] = !widget.selectedStates[index];
      } else {
        for (int i = 0; i < widget.selectedStates.length; i++) {
          widget.selectedStates[i] = i == index;
        }
      }
    });
    widget.onChanged
        ?.call(widget.selectedStates.map((option) => option).toList());
  }

  Widget fixWidgetStyle(Widget child, int index, CDKTheme theme) {
    Color color = theme.isLight
        ? widget.selectedStates[index] && theme.isAppFocused
            ? CDKTheme.white
            : CDKTheme.black
        : widget.selectedStates[index] && !theme.isAppFocused
            ? CDKTheme.black
            : CDKTheme.white;
    if (child is Text) {
      double size = 12.0;
      return Text(
        child.data!,
        style: child.style?.copyWith(color: color, fontSize: size) ??
            TextStyle(color: color, fontSize: size),
      );
    }
    if (child is Icon) {
      return Icon(
        child.icon,
        color: color,
        size: 14.0,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    List<Widget> buttonWidgets = List.generate(widget.options.length, (index) {
      // Determine border radius based on the position of the element
      BorderRadius borderRadius = BorderRadius.zero;
      if (index == 0) {
        borderRadius = BorderRadius.only(
          topLeft: Radius.circular(_borderRadius),
          bottomLeft: Radius.circular(_borderRadius),
        );
      } else if (index == widget.options.length - 1) {
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(_borderRadius),
          bottomRight: Radius.circular(_borderRadius),
        );
      }

      return Expanded(
        child: GestureDetector(
          onTap: () => _buttonTapped(index),
          child: Container(
            alignment: Alignment.center,
            margin: index != 0 ? const EdgeInsets.only(left: 1.0) : null,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.selectedStates[index]
                    ? theme.isAppFocused
                        ? [theme.accent200, theme.accent500]
                        : [CDKTheme.grey200, CDKTheme.grey300]
                    : [theme.backgroundSecondary0, theme.backgroundSecondary1],
              ),
              borderRadius: borderRadius,
            ),
            child: fixWidgetStyle(widget.options[index], index, theme),
          ),
        ),
      );
    });

    return Container(
        padding: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            color: CDKTheme.grey200,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: CDKTheme.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 1),
              )
            ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buttonWidgets));
  }
}
