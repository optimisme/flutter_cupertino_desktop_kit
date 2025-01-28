import 'package:flutter/cupertino.dart';
import 'cdk_field_text.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKFieldColorHex extends StatefulWidget {
  final double? textSize;
  final int value; // Canviat a int
  final bool enabled;
  final Function(int)? onValueChanged; // Tipus de dades canviat a int
  final Function(int)? onTextChanged;

  const CDKFieldColorHex({
    super.key,
    this.textSize = 12,
    this.value = 0,
    this.enabled = true,
    this.onValueChanged,
    this.onTextChanged,
  });

  @override
  CDKFieldColorHexState createState() => CDKFieldColorHexState();
}

class CDKFieldColorHexState extends State<CDKFieldColorHex> {
  late TextEditingController _controller;
  int _previousValue = 0; // Canviat a int

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _fixText(widget.value));
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  String _fixValue(String text) {
    // Eliminar el prefix '#', si està present
    String hexValue = text.replaceFirst('#', '');

    // Mantenir només els caràcters hexadecimals vàlids
    hexValue = hexValue.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');

    // Limitar la llargada a 6 caràcters
    if (hexValue.length > 6) {
      hexValue = hexValue.substring(0, 6);
    }

    // Duplicar els dígits si són exactament 3
    if (hexValue.length == 3) {
      hexValue = hexValue.split('').map((c) => '$c$c').join();
    }

    return hexValue.toUpperCase();
  }

  String _fixText(int value) {
    String hexStr = value.toRadixString(16).toUpperCase();
    if (hexStr.length > 6) {
      hexStr = hexStr.substring(hexStr.length - 6);
    }
    return '#${hexStr.padLeft(6, '0')}';
  }

  void _setCurrentValue(String text) {
    String newValue = _fixValue(text);
    bool valueChanged = int.parse(newValue, radix: 16) != _previousValue;

    _controller.text = '#$newValue';
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    if (valueChanged) {
      int parsedValue = int.parse(newValue, radix: 16);
      widget.onValueChanged?.call(parsedValue);
      _previousValue = parsedValue;
    }
  }

  void _onTextChanged() {
    String hexValue = _fixValue(_controller.text);
    int parsedValue = int.parse(hexValue, radix: 16);
    widget.onTextChanged?.call(parsedValue);
  }

  @override
  Widget build(BuildContext context) {
    int value = widget.value;

    if (_previousValue != value) {
      _previousValue = value;
      _controller.text = _fixText(value);
    }

    return CDKFieldText(
      controller: _controller,
      enabled: widget.enabled,
      textSize: widget.textSize,
      textAlign: TextAlign.center,
      onFocusChanged: _focusChanged,
      keyboardType: TextInputType.text,
    );
  }

  _focusChanged(bool hasFocus) {
    if (!hasFocus) {
      _setCurrentValue(_controller.text);
    }
  }
}
