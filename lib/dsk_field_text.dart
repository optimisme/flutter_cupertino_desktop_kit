import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_desktop_cupertino/dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

class DSKFieldText extends StatefulWidget {
  final bool isRounded;
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

  const DSKFieldText({
    Key? key,
    this.isRounded = false,
    this.placeholder = '',
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.textSize,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
  }) : super(key: key);

  @override
  DSKFieldTextState createState() => DSKFieldTextState();
}

class DSKFieldTextState extends State<DSKFieldText> {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = widget.isRounded
        ? BorderRadius.circular(25.0)
        : BorderRadius.circular(2.0);

    return CupertinoTextField(
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: _internalFocusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
      decoration: BoxDecoration(
          color: DSKColors.background,
          borderRadius: borderRadius,
          border: Border.all(
            color: widget.enabled ? DSKColors.grey200 : DSKColors.grey75,
            width: 1,
          ),
          boxShadow: _internalFocusNode.hasFocus
              ? [
                  BoxShadow(
                    color: DSKThemeManager.isAppFocused
                        ? DSKColors.accent100
                        : DSKColors.transparent,
                    spreadRadius: 1.5,
                    blurRadius: 0.7,
                    offset: const Offset(0, 0),
                  )
                ]
              : []),
      placeholder: widget.placeholder,
      style: TextStyle(
          fontSize: widget.textSize,
          color:
              widget.enabled ? DSKColors.text : DSKColors.backgroundSecondary1),
      prefix: widget.prefixIcon == null
          ? null
          : Icon(widget.prefixIcon, color: DSKColors.grey),
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
    );
  }
}
