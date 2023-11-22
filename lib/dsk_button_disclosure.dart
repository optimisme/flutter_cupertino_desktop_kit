import 'package:flutter/cupertino.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKButtonDisclosure extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;

  const DSKButtonDisclosure({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 16.0,
  }) : super(key: key);

  @override
  DSKButtonDisclosureState createState() => DSKButtonDisclosureState();
}

class DSKButtonDisclosureState extends State<DSKButtonDisclosure>
    with SingleTickerProviderStateMixin {
  final int _animationMillis = 200;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          Duration(milliseconds: _animationMillis), // Durada de l'animació
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 0.5) // Rotació de 0 a 45 graus
        .animate(_controller);

    if (widget.value) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(DSKButtonDisclosure oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 3.14159, // Rotació en radians
            child: Icon(
              color: DSKColors.text,
              CupertinoIcons.chevron_forward,
              size: widget.size,
            ),
          );
        },
      ),
    );
  }
}
