import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';
import 'cdk_widget_state.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

/// Custom enum for button styles
enum CDKButtonStyle { action, normal, destructive }

/// A customizable button widget for Flutter applications.
class CDKButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final CDKButtonStyle style;
  final bool isLarge;
  final bool enabled;

  const CDKButton({
    super.key,
    this.onPressed,
    required this.child,
    this.style = CDKButtonStyle.normal,
    this.isLarge = false,
    this.enabled = true,
  });

  @override
  State<CDKButton> createState() => _CDKButtonState();
}

class _CDKButtonState extends State<CDKButton> {
  static const double _fontSize = 12.0;

  bool _isPressed = false;
  bool _isFocused = false;
  bool _isHovered = false;

  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
  };

  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  void _activate() {
    if (_isEnabled) {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = CDKThemeNotifier.colorTokensOf(context);
    final runtime = CDKThemeNotifier.runtimeTokensOf(context);
    final radii = CDKThemeNotifier.radiusTokensOf(context);
    final elevations = CDKThemeNotifier.elevationTokensOf(context);

    final states = cdkWidgetStates(
      enabled: _isEnabled,
      pressed: _isPressed,
      focused: _isFocused,
      hovered: _isHovered,
    );

    final decoration = _resolveDecoration(
      states: states,
      colors: colors,
      runtime: runtime,
      radii: radii,
      elevations: elevations,
    );
    final foregroundColor = _resolveForegroundColor(
        states: states, colors: colors, runtime: runtime);

    final textStyle = TextStyle(
      fontSize: _fontSize,
      color: foregroundColor,
    );
    final iconTheme =
        IconThemeData(color: foregroundColor, size: _fontSize + 2);

    final Widget buttonContents = IntrinsicWidth(
      child: DecoratedBox(
        decoration: decoration,
        child: Padding(
          padding: widget.isLarge
              ? const EdgeInsets.fromLTRB(8, 8, 8, 10)
              : widget.child is Text
                  ? const EdgeInsets.fromLTRB(8, 3, 8, 5)
                  : const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: widget.child is Text
              ? DefaultTextStyle(
                  style: textStyle,
                  child: widget.child,
                )
              : widget.child is Icon
                  ? IconTheme.merge(data: iconTheme, child: widget.child)
                  : widget.child,
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: _isEnabled,
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
        onShowHoverHighlight: (isHovered) {
          if (_isHovered != isHovered) {
            setState(() => _isHovered = isHovered);
          }
        },
        onShowFocusHighlight: (isFocused) {
          if (_isFocused != isFocused) {
            setState(() => _isFocused = isFocused);
          }
        },
        child: GestureDetector(
          onTapDown: !_isEnabled
              ? null
              : (details) => setState(() => _isPressed = true),
          onTapUp: !_isEnabled
              ? null
              : (details) => setState(() => _isPressed = false),
          onTapCancel:
              !_isEnabled ? null : () => setState(() => _isPressed = false),
          onTap: !_isEnabled ? null : _activate,
          child: buttonContents,
        ),
      ),
    );
  }

  BoxDecoration _resolveDecoration({
    required Set<WidgetState> states,
    required CDKThemeColorTokens colors,
    required CDKThemeRuntimeTokens runtime,
    required CDKThemeRadiusTokens radii,
    required CDKThemeElevationTokens elevations,
  }) {
    final isDisabled = states.contains(WidgetState.disabled);
    final isPressed = states.contains(WidgetState.pressed);
    final isFocused = states.contains(WidgetState.focused);

    final baseShadows = <BoxShadow>[
      BoxShadow(
        color: CDKTheme.black.withValues(alpha: 0.1),
        spreadRadius: 0,
        blurRadius: elevations.softShadowBlur,
        offset: Offset(0, elevations.softShadowYOffset),
      )
    ];
    if (isFocused && !isDisabled) {
      baseShadows.add(
        BoxShadow(
          color: colors.accent200.withValues(alpha: 0.75),
          spreadRadius: elevations.focusRingSpread,
          blurRadius: elevations.focusRingBlur,
          offset: const Offset(0, 0),
        ),
      );
    }

    final radius = BorderRadius.circular(radii.medium);

    if (isDisabled) {
      switch (widget.style) {
        case CDKButtonStyle.action:
          return BoxDecoration(
            color: runtime.isAppFocused ? colors.accent200 : CDKTheme.grey200,
            borderRadius: radius,
            boxShadow: baseShadows,
          );
        case CDKButtonStyle.normal:
        case CDKButtonStyle.destructive:
          return BoxDecoration(
            color: colors.backgroundSecondary0,
            borderRadius: radius,
            boxShadow: baseShadows,
          );
      }
    }

    switch (widget.style) {
      case CDKButtonStyle.action:
        if (runtime.isAppFocused) {
          return BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isPressed
                  ? [colors.accent100, colors.accent]
                  : [colors.accent300, colors.accent500],
            ),
            borderRadius: radius,
            boxShadow: baseShadows,
          );
        }
        return BoxDecoration(
          color: isPressed ? CDKTheme.grey200 : colors.backgroundSecondary0,
          border: Border.all(color: colors.backgroundSecondary1),
          borderRadius: radius,
          boxShadow: baseShadows,
        );
      case CDKButtonStyle.destructive:
        return BoxDecoration(
          color: runtime.isLight
              ? (isPressed ? CDKTheme.grey50 : CDKTheme.white)
              : (isPressed ? CDKTheme.grey500 : colors.backgroundSecondary0),
          border: runtime.isLight
              ? Border.all(color: CDKTheme.grey70)
              : Border.all(color: CDKTheme.grey600),
          borderRadius: radius,
          boxShadow: baseShadows,
        );
      case CDKButtonStyle.normal:
        return BoxDecoration(
          color: runtime.isLight
              ? (isPressed ? CDKTheme.grey50 : CDKTheme.white)
              : (isPressed ? CDKTheme.grey500 : colors.backgroundSecondary0),
          border: runtime.isLight
              ? Border.all(color: CDKTheme.grey70)
              : Border.all(color: CDKTheme.grey600),
          borderRadius: radius,
          boxShadow: baseShadows,
        );
    }
  }

  Color _resolveForegroundColor({
    required Set<WidgetState> states,
    required CDKThemeColorTokens colors,
    required CDKThemeRuntimeTokens runtime,
  }) {
    final isDisabled = states.contains(WidgetState.disabled);
    final isPressed = states.contains(WidgetState.pressed);

    if (isDisabled) {
      switch (widget.style) {
        case CDKButtonStyle.action:
          return runtime.isAppFocused ? colors.accent600 : CDKTheme.grey;
        case CDKButtonStyle.normal:
        case CDKButtonStyle.destructive:
          return CDKTheme.grey;
      }
    }

    switch (widget.style) {
      case CDKButtonStyle.action:
        if (runtime.isAppFocused) {
          return isPressed ? colors.accent50 : CDKTheme.white;
        }
        return CDKTheme.black;
      case CDKButtonStyle.destructive:
        return CDKTheme.red;
      case CDKButtonStyle.normal:
        return colors.colorText;
    }
  }
}
