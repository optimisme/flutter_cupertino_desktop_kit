import 'package:flutter/cupertino.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// A customizable switch button widget for Flutter applications
//
/// The [CDKButtonSwitch] is a versatile Flutter widget designed for creating toggleable
/// button switch elements.
///
/// <img src="/flutter_cupertino_desktop_kit/gh-pages/doc-images/CDKButtonSwitch_0.png" alt="CDKButtonSwitch Example" style="max-width: 500px; width: 100%;">
///
/// ```dart
/// CDKButtonSwitch(
///   value: true, // Initial state of the switch
///   onChanged: (newValue) {
///     // Handle switch state changes here
///   },
///   size: 30.0, // Optional: Adjust the size of the switch
/// )
/// ```
///
/// Parameters:
/// * `value`: A boolean flag indicating the current state of the switch (true for ON, false for OFF).
/// * `size`: A double representing the size of the switch. Defaults to 22.0.
/// * `onChanged`: A callback function that takes a boolean parameter and is triggered when the switch state changes. If null, the switch will not respond to user interactions.
class CDKButtonSwitch extends StatelessWidget {
  final bool value;
  final double size;
  final ValueChanged<bool>? onChanged;

  const CDKButtonSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 22.0,
  }) : super(key: key);

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
