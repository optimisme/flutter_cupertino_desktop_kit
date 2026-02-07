import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKButtonSwitch extends StatelessWidget {
  final bool value;
  final double size;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  const CDKButtonSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 22.0,
    this.semanticLabel,
  });

  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
  };

  bool get _isEnabled => onChanged != null;

  void _toggle() {
    if (_isEnabled) {
      onChanged?.call(!value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = CDKThemeNotifier.colorTokensOf(context);
    final runtime = CDKThemeNotifier.runtimeTokensOf(context);

    final backRadius = size * 12.0 / 24.0;
    final backHeight = size;
    final backWidth = size * 40.0 / 24.0;
    final circleTop = size * 2.0 / 24.0;
    final circleMovement = size * 16.0 / 24.0;
    final circleSize = size * 20.0 / 24.0;

    final activeGradient = runtime.isLight
        ? [colors.accent, colors.accent200]
        : [colors.accent500, colors.accent];

    return Semantics(
      button: true,
      toggled: value,
      enabled: _isEnabled,
      label: semanticLabel ?? 'Switch',
      value: value ? 'On' : 'Off',
      onTap: _isEnabled ? _toggle : null,
      child: FocusableActionDetector(
        enabled: _isEnabled,
        mouseCursor:
            _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        shortcuts: _shortcuts,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              _toggle();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isEnabled ? _toggle : null,
          onPanUpdate: !_isEnabled
              ? null
              : (details) {
                  final newState = details.localPosition.dx > (backWidth / 2);
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
                colors: runtime.isAppFocused && value
                    ? activeGradient
                    : [
                        colors.backgroundSecondary1,
                        colors.backgroundSecondary1
                      ],
              ),
            ),
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
        ),
      ),
    );
  }
}
