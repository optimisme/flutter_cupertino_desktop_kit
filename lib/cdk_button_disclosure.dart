import 'package:flutter/cupertino.dart';
import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// A disclosure button widget for Flutter applications with animated rotation.
///
/// The [CDKButtonDisclosure] widget provides a disclosure button that can be toggled
/// to reveal or hide additional content. It includes an animation that rotates the
/// chevron icon when the button is toggled.
///
/// <img src="/flutter_cupertino_desktop_kit/gh-pages/doc-images/CDKButtonDisclosure_0.png" alt="CDKButtonDisclosure Example 1" style="max-width: 500px; width: 100%;">
/// <img src="/flutter_cupertino_desktop_kit/gh-pages/doc-images/CDKButtonDisclosure_1.png" alt="CDKButtonDisclosure Example 2" style="max-width: 500px; width: 100%;">
///
/// ```dart
/// CDKButtonDisclosure(
///   value: true,
///   onChanged: (newValue) {
///     // Handle disclosure state change
///   },
///   size: 16.0,
/// )
/// ```
///
/// Parameters:
/// * `value`: The current state of the disclosure button, whether it is open or closed.
/// * `onChanged`: A callback function that is called when the disclosure state changes.
/// * `size`: The size of the disclosure button. Defaults to `16.0`.
class CDKButtonDisclosure extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;

  const CDKButtonDisclosure({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 16.0,
  }) : super(key: key);

  @override
  CDKButtonDisclosureState createState() => CDKButtonDisclosureState();
}

class CDKButtonDisclosureState extends State<CDKButtonDisclosure>
    with SingleTickerProviderStateMixin {
  final int _animationMillis = 200;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    /// Creates an animation controller with a duration of [_animationMillis] milliseconds.
    _controller = AnimationController(
      duration:
          Duration(milliseconds: _animationMillis), // Durada de l'animació
      vsync: this,
    );

    /// Creates an animation that interpolates between 0.0 and 0.5, representing the rotation of the chevron icon from 0 to 45 degrees.
    _animation = Tween<double>(begin: 0.0, end: 0.5) // Rotació de 0 a 45 graus
        .animate(_controller);

    /// If the initial value of the toggle is true, forward the animation.
    if (widget.value) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CDKButtonDisclosure oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 3.14159, // Rotació en radians
            child: Icon(
              color: theme.colorText,
              CupertinoIcons.chevron_forward,
              size: widget.size,
            ),
          );
        },
      ),
    );
  }
}
