import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cdk_button.dart';
import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class _CDKDialogCancelIntent extends Intent {
  const _CDKDialogCancelIntent();
}

class CDKDialogConfirm extends StatefulWidget {
  const CDKDialogConfirm({
    super.key,
    this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
    this.onRequestClose,
  });

  final String? title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onRequestClose;

  @override
  State<CDKDialogConfirm> createState() => _CDKDialogConfirmState();
}

class _CDKDialogConfirmState extends State<CDKDialogConfirm> {
  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.escape): _CDKDialogCancelIntent(),
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
  };

  bool _didRequestClose = false;
  late final FocusNode _focusNode = FocusNode(debugLabel: 'CDKDialogConfirm');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _closeOnce(VoidCallback callback) {
    if (_didRequestClose) {
      return;
    }
    _didRequestClose = true;
    callback();
  }

  void _cancel() {
    _closeOnce(() {
      widget.onCancel?.call();
      if (widget.onRequestClose != null) {
        widget.onRequestClose!.call();
      } else {
        Actions.maybeInvoke(context, const DismissIntent());
      }
    });
  }

  void _confirm() {
    _closeOnce(() {
      widget.onConfirm?.call();
      widget.onRequestClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = CDKThemeNotifier.colorTokensOf(context);
    final spacing = CDKThemeNotifier.spacingTokensOf(context);

    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          _CDKDialogCancelIntent: CallbackAction<_CDKDialogCancelIntent>(
            onInvoke: (_CDKDialogCancelIntent intent) {
              _cancel();
              return null;
            },
          ),
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              _confirm();
              return null;
            },
          ),
        },
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320,
              maxWidth: 420,
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null && widget.title!.isNotEmpty) ...[
                    Text(
                      widget.title!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.colorText,
                      ),
                    ),
                    SizedBox(height: spacing.md),
                  ],
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: colors.colorText,
                    ),
                  ),
                  SizedBox(height: spacing.lg + spacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CDKButton(
                        style: CDKButtonStyle.normal,
                        onPressed: _cancel,
                        child: Text(widget.cancelLabel),
                      ),
                      SizedBox(width: spacing.md),
                      CDKButton(
                        style: widget.isDestructive
                            ? CDKButtonStyle.destructive
                            : CDKButtonStyle.action,
                        onPressed: _confirm,
                        child: Text(widget.confirmLabel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
