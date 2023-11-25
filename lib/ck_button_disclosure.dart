import 'package:flutter/cupertino.dart';
import 'ck_theme.dart';
import 'ck_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKButtonDisclosure extends StatefulWidget {
  /// The initial value of the toggle.
  final bool value;

  /// A callback function that is called when the value of the toggle changes.
  final ValueChanged<bool>? onChanged;

  /// The size of the chevron icon.
  final double size;

  /// Creates a DSKButtonDisclosure widget.
  const CKButtonDisclosure({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 16.0,
  }) : super(key: key);

  @override
  CKButtonDisclosureState createState() => CKButtonDisclosureState();
}

/// The state of the `DSKButtonDisclosure` widget.
class CKButtonDisclosureState extends State<CKButtonDisclosure>
    with SingleTickerProviderStateMixin {
  /// The duration of the animation in milliseconds.
  final int _animationMillis = 200;

  /// An animation controller that controls the animation of the chevron icon.
  late AnimationController _controller;

  /// An animation that interpolates between 0.0 and 0.5, representing the rotation of the chevron icon from 0 to 45 degrees.
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
  void didUpdateWidget(CKButtonDisclosure oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    CKTheme theme = CKThemeNotifier.of(context)!.changeNotifier;

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
