import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'cx_theme_notifier.dart';
import 'cx_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CXFieldText extends StatefulWidget {
  final bool isRounded;
  final bool obscureText;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? textSize;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final Function? onFocusChanged;
  final TextAlign textAlign;

  const CXFieldText({
    Key? key,
    this.isRounded = false,
    this.obscureText = false,
    this.placeholder = '',
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.textSize = 12,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.onFocusChanged,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  @override
  CXFieldTextState createState() => CXFieldTextState();
}

class CXFieldTextState extends State<CXFieldText> {
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_handleFocusChanged);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {
      widget.onFocusChanged?.call(_internalFocusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    CXTheme theme = CXThemeNotifier.of(context)!.changeNotifier;

    final BorderRadius borderRadius = widget.isRounded
        ? BorderRadius.circular(25.0)
        : BorderRadius.circular(4.0);

    return CupertinoTextField(
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: _internalFocusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
      decoration: BoxDecoration(
          color: theme.background,
          borderRadius: borderRadius,
          border: Border.all(
            color: widget.enabled
                ? CXTheme.grey200
                : theme.isLight
                    ? CXTheme.grey70
                    : CXTheme.grey700,
            width: 1,
          ),
          boxShadow: _internalFocusNode.hasFocus
              ? [
                  BoxShadow(
                    color: theme.isAppFocused
                        ? theme.accent200
                        : CXTheme.transparent,
                    spreadRadius: 1.5,
                    blurRadius: 0.7,
                    offset: const Offset(0, 0),
                  )
                ]
              : []),
      placeholder: widget.placeholder,
      style: TextStyle(
          fontSize: widget.textSize,
          color: widget.enabled
              ? theme.colorText
              : theme.isLight
                  ? CXTheme.grey100
                  : CXTheme.grey700),
      prefix: widget.prefixIcon == null
          ? null
          : Icon(widget.prefixIcon, color: CXTheme.grey),
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
    );
  }
}
