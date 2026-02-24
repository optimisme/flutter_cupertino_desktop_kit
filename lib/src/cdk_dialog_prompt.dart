import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'cdk_button.dart';
import 'cdk_field_text.dart';
import 'cdk_text.dart';
import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

typedef CDKPromptValidator = String? Function(String value);
typedef CDKPromptSubmit = void Function(String value);

class _CDKDialogCancelIntent extends Intent {
  const _CDKDialogCancelIntent();
}

class CDKDialogPrompt extends StatefulWidget {
  const CDKDialogPrompt({
    super.key,
    this.title,
    this.message,
    this.placeholder,
    this.initialValue,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.validator,
    this.isDestructiveConfirm = false,
    this.onConfirm,
    this.onCancel,
    this.onRequestClose,
  });

  final String? title;
  final String? message;
  final String? placeholder;
  final String? initialValue;
  final String confirmLabel;
  final String cancelLabel;
  final CDKPromptValidator? validator;
  final bool isDestructiveConfirm;
  final CDKPromptSubmit? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onRequestClose;

  @override
  State<CDKDialogPrompt> createState() => _CDKDialogPromptState();
}

class _CDKDialogPromptState extends State<CDKDialogPrompt> {
  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.escape): _CDKDialogCancelIntent(),
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
  };

  late final TextEditingController _textController = TextEditingController(
    text: widget.initialValue ?? '',
  );
  late final FocusNode _textFocusNode = FocusNode(debugLabel: 'CDKPromptText');
  String? _errorText;
  bool _didRequestClose = false;

  @override
  void initState() {
    super.initState();
    _errorText = _validate(_textController.text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _textFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  String? _validate(String value) {
    return widget.validator?.call(value);
  }

  bool get _isValid => _errorText == null;

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
    final value = _textController.text;
    final validationError = _validate(value);
    if (validationError != null) {
      if (_errorText != validationError) {
        setState(() {
          _errorText = validationError;
        });
      }
      return;
    }

    _closeOnce(() {
      widget.onConfirm?.call(value);
      widget.onRequestClose?.call();
    });
  }

  void _onTextChanged(String value) {
    final validationError = _validate(value);
    if (_errorText == validationError) {
      return;
    }
    setState(() {
      _errorText = validationError;
    });
  }

  @override
  Widget build(BuildContext context) {
    final typography = CDKThemeNotifier.typographyTokensOf(context);
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
              if (_isValid) {
                _confirm();
              }
              return null;
            },
          ),
        },
        child: Focus(
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
                    CDKText(
                      widget.title!,
                      role: CDKTextRole.title,
                    ),
                    SizedBox(height: spacing.md),
                  ],
                  if (widget.message != null && widget.message!.isNotEmpty) ...[
                    CDKText(
                      widget.message!,
                      role: CDKTextRole.body,
                    ),
                    SizedBox(height: spacing.md),
                  ],
                  CDKFieldText(
                    placeholder: widget.placeholder ?? '',
                    controller: _textController,
                    focusNode: _textFocusNode,
                    onChanged: _onTextChanged,
                    onSubmitted: (_) => _confirm(),
                  ),
                  if (_errorText != null) ...[
                    SizedBox(height: spacing.sm),
                    Text(
                      _errorText!,
                      style: typography.caption.copyWith(color: CDKTheme.red),
                    ),
                  ],
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
                        style: widget.isDestructiveConfirm
                            ? CDKButtonStyle.destructive
                            : CDKButtonStyle.action,
                        enabled: _isValid,
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
