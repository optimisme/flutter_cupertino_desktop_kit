import 'package:flutter/cupertino.dart';
import 'cdk.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonColor extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color color;
  final bool enabled;

  const CDKButtonColor({
    super.key,
    this.onPressed,
    required this.color,
    this.enabled = true,
  });

  @override
  CDKButtonColorState createState() => CDKButtonColorState();
}

class CDKButtonColorState extends State<CDKButtonColor> {
  // Flag to track if the button is currently pressed.
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;
    Color colorBorder = theme.isLight
        ? _isPressed
            ? CDKTheme.grey90
            : CDKTheme.grey60
        : _isPressed
            ? CDKTheme.grey800
            : CDKTheme.grey600;
    Color colorIcon = theme.isLight
        ? _isPressed
            ? CDKTheme.grey90
            : _isHovered
                ? CDKTheme.white
                : CDKTheme.grey50
        : _isPressed
            ? CDKTheme.grey800
            : _isHovered
                ? CDKTheme.grey800
                : CDKTheme.grey600;

    // Define styles and themes based on the button's state and style.
    BoxDecoration decoration;

    BoxShadow shadow = BoxShadow(
      color: CDKTheme.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

    // Styling logic depending on the button's style and state.
    decoration = BoxDecoration(
        color: theme.backgroundSecondary0,
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [shadow]);

    return GestureDetector(
        onTapDown: !widget.enabled
            ? null
            : (details) => setState(() => _isPressed = true),
        onTapUp: !widget.enabled
            ? null
            : (details) => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: MouseRegion(
          onEnter: (event) => setState(() => _isHovered = true),
          onExit: (event) => setState(() => _isHovered = false),
          child: SizedBox(
            width: 65,
            height: 22,
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: decoration,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CustomPaint(
                      painter: CDKUtilShaderGrid(7),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(color: widget.color),
                          ),
                          Container(
                            width: 20,
                            color: Color(widget.color.value | 0xFF000000),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorBorder, width: 1),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 20,
                      child: IconTheme(
                        data: const IconThemeData(size: 12),
                        child:
                            Icon(CupertinoIcons.chevron_down, color: colorIcon),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
