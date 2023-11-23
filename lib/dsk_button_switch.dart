import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Class `DSKButtonSwitch` - A custom switch button widget for Flutter.
///
/// This class creates a switch button widget that can toggle between on/off states.
///
/// Parameters:
/// * `value`: (bool) The current state of the switch (on/off).
/// * `onChanged`: (ValueChanged<bool>?) Callback called when the state of the switch changes.
/// * `size`: (double) The size of the switch button.
class DSKButtonSwitch extends StatefulWidget {
  final bool value;
  final double size;
  final ValueChanged<bool>? onChanged;

  const DSKButtonSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 24.0,
  }) : super(key: key);

  @override
  DSKButtonSwitchState createState() => DSKButtonSwitchState();
}

/// Class `DSKButtonSwitchState` - The state for `DSKButtonSwitch`.
///
/// Manages the state and rendering of the switch button.
class DSKButtonSwitchState extends State<DSKButtonSwitch> {
  final int _animationMillis = 200;

  @override
  Widget build(BuildContext context) {
    DSKThemeManager themeManager = DSKThemeManager();

    // Calculations for sizes and positions based on the provided `size`.
    double backRadius = widget.size * 12.0 / 24.0;
    double backHeight = widget.size * 24.0 / 24.0;
    double backWidth = widget.size * 40.0 / 24.0;
    double circleTop = widget.size * 2.0 / 24.0;
    double circleMovement = widget.size * 16.0 / 24.0;
    double circleSize = widget.size * 20.0 / 24.0;

    return GestureDetector(
      onTap: () {
        widget.onChanged?.call(!widget.value);
      },
      onPanUpdate: (details) {
        // Obtenir la posició local del gest de desplaçament quan finalitza
        bool newState = details.localPosition.dx > (backWidth / 2);
        widget.onChanged?.call(newState);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: _animationMillis),
        height: backHeight,
        width: backWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(backRadius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: themeManager.isAppFocused && widget.value
                  ? themeManager.isLight
                      ? [DSKColors.accent, DSKColors.accent200]
                      : [DSKColors.accent500, DSKColors.accent]
                  : [
                      DSKColors.backgroundSecondary1,
                      DSKColors.backgroundSecondary1
                    ],
            )),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: _animationMillis),
              curve: Curves.easeIn,
              top: circleTop,
              left: widget.value ? circleMovement : 0.0,
              right: widget.value ? 0.0 : circleMovement,
              child: Container(
                height: circleSize,
                width: circleSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: DSKColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
