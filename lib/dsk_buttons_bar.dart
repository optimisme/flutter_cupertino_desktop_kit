import 'package:flutter/material.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

class DSKButtonsBar extends StatefulWidget {
  final List<Map<String, dynamic>> options; // Canviat a llistat de diccionaris
  final Function(List<bool>)? onChanged;
  final bool allowsMultipleSelection;

  const DSKButtonsBar({
    Key? key,
    required this.options,
    this.onChanged,
    this.allowsMultipleSelection = false,
  }) : super(key: key);

  @override
  DSKButtonsBarState createState() => DSKButtonsBarState();
}

class DSKButtonsBarState extends State<DSKButtonsBar> {
  final double _borderRadius = 4.0;
  List<Map<String, dynamic>> _selectedStates =
      []; // Canviat a llistat de diccionaris

  @override
  void initState() {
    super.initState();
    _selectedStates = widget.options.map((option) => Map.of(option)).toList();
  }

  void _buttonTapped(int index) {
    setState(() {
      if (widget.allowsMultipleSelection) {
        _selectedStates[index]['value'] = !_selectedStates[index]['value'];
      } else {
        for (int i = 0; i < _selectedStates.length; i++) {
          _selectedStates[i]['value'] = i == index;
        }
      }
    });
    widget.onChanged?.call(
        _selectedStates.map((option) => option['value'] as bool).toList());
  }

  Widget fixWidgetStyle(Widget widget, int index) {
    Color color = DSKThemeManager.isLight
        ? _selectedStates[index]['value'] && DSKThemeManager.isAppFocused
            ? DSKColors.white
            : DSKColors.black
        : _selectedStates[index]['value'] && !DSKThemeManager.isAppFocused
            ? DSKColors.black
            : DSKColors.white;
    if (widget is Text) {
      double size = 12.0;
      return Text(
        widget.data!,
        style: widget.style?.copyWith(color: color, fontSize: size) ??
            TextStyle(color: color, fontSize: size),
      );
    }
    if (widget is Icon) {
      return Icon(
        widget.icon,
        color: color,
        size: 14.0,
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
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
                colors: _selectedStates[index]['value']
                    ? DSKThemeManager.isAppFocused
                        ? [DSKColors.accent200, DSKColors.accent500]
                        : [DSKColors.grey200, DSKColors.grey300]
                    : [
                        DSKColors.backgroundSecondary0,
                        DSKColors.backgroundSecondary1
                      ],
              ),
              borderRadius: borderRadius,
            ),
            child: fixWidgetStyle(widget.options[index]['widget'], index),
          ),
        ),
      );
    });

    return Container(
        padding: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            color: DSKColors.grey200,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: DSKColors.black.withOpacity(0.1),
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
