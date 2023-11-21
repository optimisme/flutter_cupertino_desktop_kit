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
  final TextInputType? keyboardType; // Nuevo: Tipo de teclado
  final List<TextInputFormatter>?
      inputFormatters; // Nuevo: Formateadores de entrada

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
    this.keyboardType, // Nuevo
    this.inputFormatters, // Nuevo
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

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = widget.isRounded
        ? BorderRadius.circular(25.0)
        : BorderRadius.circular(4.0);

    return CupertinoTextField(
      controller: widget.controller,
      focusNode: _internalFocusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
      decoration: BoxDecoration(
          color: DSKColors.background,
          borderRadius: borderRadius,
          border: Border.all(
            color: CupertinoColors.systemGrey.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: _internalFocusNode.hasFocus
              ? [
                  BoxShadow(
                    color: DSKThemeManager.isAppFocused
                        ? DSKColors.accent100
                        : DSKColors.transparent,
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: const Offset(0, 0),
                  )
                ]
              : []),
      placeholder: widget.placeholder,
      style: TextStyle(fontSize: widget.textSize),
      prefix: widget.prefixIcon == null
          ? null
          : Icon(widget.prefixIcon, color: CupertinoColors.systemGrey),
      keyboardType: widget.keyboardType, // Aplicar el tipo de teclado
      inputFormatters:
          widget.inputFormatters, // Aplicar formateadores de entrada
    );
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_handleFocusChanged);
    _internalFocusNode.dispose();
    super.dispose();
  }
}
