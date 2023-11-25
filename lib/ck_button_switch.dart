import 'package:flutter/cupertino.dart';
import 'ck_theme_notifier.dart';
import 'ck_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKButtonSwitch extends StatefulWidget {
  final bool value;
  final double size;
  final ValueChanged<bool>? onChanged;

  const CKButtonSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 24.0,
  }) : super(key: key);

  @override
  CKButtonSwitchState createState() => CKButtonSwitchState();
}

/// Class `DSKButtonSwitchState` - The state for `DSKButtonSwitch`.
///
/// Manages the state and rendering of the switch button.
class CKButtonSwitchState extends State<CKButtonSwitch> {
  final int _animationMillis = 200;

  @override
  Widget build(BuildContext context) {
    CKTheme theme = CKThemeNotifier.of(context)!.changeNotifier;

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
              colors: theme.isAppFocused && widget.value
                  ? theme.isLight
                      ? [theme.accent, theme.accent200]
                      : [theme.accent500, theme.accent]
                  : [theme.backgroundSecondary1, theme.backgroundSecondary1],
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
                  color: CKTheme.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
