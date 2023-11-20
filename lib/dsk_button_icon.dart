import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

class DSKButtonIcon extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  final bool isCircle;
  final bool isSelected;

  const DSKButtonIcon({
    Key? key,
    required this.onPressed,
    this.icon = CupertinoIcons.bell_fill,
    this.size = 24.0,
    this.isCircle = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  DSKButtonIconState createState() => DSKButtonIconState();
}

class DSKButtonIconState extends State<DSKButtonIcon> {
  bool _isPressed = false;
  bool _isHovering = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  void _onMouseEnter(PointerEvent details) {
    setState(() => _isHovering = true);
  }

  void _onMouseExit(PointerEvent details) {
    setState(() => _isHovering = false);
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = DSKThemeManager.isLight
        ? _isPressed
            ? DSKColors.grey75
            : _isHovering
                ? DSKColors.grey50
                : widget.isSelected
                    ? DSKColors.backgroundSecondary1
                    : DSKColors.transparent
        : _isPressed
            ? DSKColors.grey
            : _isHovering
                ? DSKColors.grey600
                : widget.isSelected
                    ? DSKColors.backgroundSecondary1
                    : DSKColors.transparent;

    return MouseRegion(
      onEnter: _onMouseEnter,
      onExit: _onMouseExit,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onPressed,
        child: widget.isCircle
            ? DecoratedBox(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(widget.size)),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  alignment: Alignment.center,
                  child: Icon(
                    widget.icon,
                    color: widget.isSelected && DSKThemeManager.isAppFocused
                        ? DSKColors.accent
                        : DSKColors.text,
                    size: widget.isCircle
                        ? widget.size * 0.5
                        : widget.size, // Icona més petita que el botó
                  ),
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                    child: Icon(
                      widget.icon,
                      color: DSKColors.text,
                      size: widget.isCircle
                          ? widget.size * 0.5
                          : widget.size, // Icona més petita que el botó
                    )),
              ),
      ),
    );
  }
}
