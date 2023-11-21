import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

enum DSKButtonStyle { action, normal, destructive }

class DSKButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final DSKButtonStyle style;
  final bool isLarge;
  final bool enabled;

  const DSKButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style = DSKButtonStyle.normal,
    this.isLarge = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  DSKButtonState createState() => DSKButtonState();
}

class DSKButtonState extends State<DSKButton> {
  static const double _fontSize = 12.0;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
    TextStyle textStyle;
    BoxShadow shadow = BoxShadow(
      color: DSKColors.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 1,
      offset: const Offset(0, 1),
    );

    if (!widget.enabled) {
      switch (widget.style) {
        case DSKButtonStyle.action:
          decoration = BoxDecoration(
              color: DSKThemeManager.isAppFocused
                  ? DSKColors.accent200
                  : DSKColors.grey200,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: DSKThemeManager.isAppFocused
                ? DSKColors.accent600
                : DSKColors.grey,
          );
          break;

        case DSKButtonStyle.normal:
        case DSKButtonStyle.destructive:
          decoration = BoxDecoration(
              color: DSKColors.backgroundSecondary0,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: DSKColors.grey,
          );
          break;
      }
    } else {
      switch (widget.style) {
        case DSKButtonStyle.action:
          if (DSKThemeManager.isAppFocused) {
            decoration = BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _isPressed
                      ? [DSKColors.accent100, DSKColors.accent]
                      : [DSKColors.accent300, DSKColors.accent500],
                ),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [shadow]);
            textStyle = TextStyle(
              fontSize: _fontSize,
              color: _isPressed ? DSKColors.accent50 : DSKColors.white,
            );
          } else {
            decoration = BoxDecoration(
                color: _isPressed
                    ? DSKColors.grey200
                    : DSKColors.backgroundSecondary0,
                border: Border.all(color: DSKColors.backgroundSecondary1),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [shadow]);
            textStyle = const TextStyle(
              fontSize: _fontSize,
              color: DSKColors.black,
            );
          }
          break;

        case DSKButtonStyle.destructive:
          decoration = BoxDecoration(
              color: DSKThemeManager.isLight
                  ? _isPressed
                      ? DSKColors.grey50
                      : DSKColors.white
                  : _isPressed
                      ? DSKColors.grey500
                      : DSKColors.backgroundSecondary0,
              border: DSKThemeManager.isLight
                  ? Border.all(color: DSKColors.grey75)
                  : Border.all(color: DSKColors.grey600),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          textStyle = const TextStyle(
            fontSize: _fontSize,
            color: DSKColors.red,
          );
          break;

        default:
          decoration = BoxDecoration(
              color: DSKThemeManager.isLight
                  ? _isPressed
                      ? DSKColors.grey50
                      : DSKColors.white
                  : _isPressed
                      ? DSKColors.grey500
                      : DSKColors.backgroundSecondary0,
              border: DSKThemeManager.isLight
                  ? Border.all(color: DSKColors.grey75)
                  : Border.all(color: DSKColors.grey600),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [shadow]);
          textStyle = TextStyle(
            fontSize: _fontSize,
            color: DSKColors.text,
          );
      }
    }

    return GestureDetector(
      onTapDown: !widget.enabled
          ? null
          : (details) => setState(() => _isPressed = true),
      onTapUp: !widget.enabled
          ? null
          : (details) => setState(() => _isPressed = false),
      onTapCancel:
          !widget.enabled ? null : () => setState(() => _isPressed = false),
      onTap: !widget.enabled ? null : widget.onPressed,
      child: IntrinsicWidth(
          child: DecoratedBox(
        decoration: decoration,
        child: Padding(
          padding: widget.isLarge
              ? const EdgeInsets.fromLTRB(8, 8, 8, 10)
              : const EdgeInsets.fromLTRB(8, 3, 8, 5),
          child: DefaultTextStyle(
            style: textStyle,
            child: widget.child,
          ),
        ),
      )),
    );
  }
}
