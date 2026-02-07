import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonIcon extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final bool isCircle;
  final bool isSelected;
  final String? semanticLabel;

  const CDKButtonIcon({
    super.key,
    this.onPressed,
    this.icon = CupertinoIcons.bell_fill,
    this.size = 24.0,
    this.isCircle = false,
    this.isSelected = false,
    this.semanticLabel,
  });

  @override
  State<CDKButtonIcon> createState() => _CDKButtonIconState();
}

class _CDKButtonIconState extends State<CDKButtonIcon> {
  bool _isPressed = false;
  bool _isHovering = false;
  bool _isFocused = false;

  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
  };

  bool get _isEnabled => widget.onPressed != null;

  void _activate() {
    if (_isEnabled) {
      widget.onPressed?.call();
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (_isEnabled) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isEnabled) {
      setState(() => _isPressed = false);
    }
  }

  void _onTapCancel() {
    if (_isEnabled) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    final Color backgroundColor = theme.isLight
        ? _isPressed
            ? CDKTheme.grey70
            : _isHovering
                ? CDKTheme.grey50
                : widget.isSelected
                    ? theme.backgroundSecondary1
                    : CDKTheme.transparent
        : _isPressed
            ? CDKTheme.grey
            : _isHovering
                ? CDKTheme.grey600
                : widget.isSelected
                    ? theme.backgroundSecondary1
                    : CDKTheme.transparent;

    final Color textColor = theme.isLight
        ? widget.isSelected && theme.isAppFocused
            ? theme.accent
            : theme.colorText
        : widget.isSelected && theme.isAppFocused
            ? CDKTheme.white
            : theme.colorText;

    final BorderRadius borderRadius = widget.isCircle
        ? BorderRadius.circular(widget.size)
        : BorderRadius.circular(8);
    final Color focusBorderColor = _isFocused && _isEnabled
        ? theme.accent200.withValues(alpha: 0.85)
        : CDKTheme.transparent;

    final Widget buttonChild = DecoratedBox(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.all(color: focusBorderColor, width: 1.25)),
      child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: Icon(
              widget.icon,
              color: textColor,
              semanticLabel: widget.semanticLabel,
              size: widget.isCircle ? widget.size * 0.5 : widget.size * 0.75,
            ),
          )),
    );

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.semanticLabel,
      onTap: _isEnabled ? _activate : null,
      child: FocusableActionDetector(
        enabled: _isEnabled,
        mouseCursor:
            _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        shortcuts: _shortcuts,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              _activate();
              return null;
            },
          ),
        },
        onShowHoverHighlight: (isHovering) {
          if (_isHovering != isHovering) {
            setState(() => _isHovering = isHovering);
          }
        },
        onShowFocusHighlight: (isFocused) {
          if (_isFocused != isFocused) {
            setState(() => _isFocused = isFocused);
          }
        },
        child: GestureDetector(
          onTapDown: _isEnabled ? _onTapDown : null,
          onTapUp: _isEnabled ? _onTapUp : null,
          onTapCancel: _isEnabled ? _onTapCancel : null,
          onTap: _isEnabled ? _activate : null,
          child: buttonChild,
        ),
      ),
    );
  }
}
