import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonSwitch extends StatelessWidget {
  final bool value;
  final double size;
  final ValueChanged<bool>? onChanged;

  const CDKButtonSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    double backRadius = size * 12.0 / 24.0;
    double backHeight = size * 24.0 / 24.0;
    double backWidth = size * 40.0 / 24.0;
    double circleTop = size * 2.0 / 24.0;
    double circleMovement = size * 16.0 / 24.0;
    double circleSize = size * 20.0 / 24.0;

    return GestureDetector(
      onTap: () {
        onChanged?.call(!value);
      },
      onPanUpdate: (details) {
        bool newState = details.localPosition.dx > (backWidth / 2);
        onChanged?.call(newState);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: backHeight,
        width: backWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(backRadius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.isAppFocused && value
                  ? theme.isLight
                      ? [theme.accent, theme.accent200]
                      : [theme.accent500, theme.accent]
                  : [theme.backgroundSecondary1, theme.backgroundSecondary1],
            )),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              top: circleTop,
              left: value ? circleMovement : 0.0,
              right: value ? 0.0 : circleMovement,
              child: Container(
                height: circleSize,
                width: circleSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CDKTheme.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
