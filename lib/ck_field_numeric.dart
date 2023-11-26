import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'ck_field_text.dart';
import 'ck_buttons_up_down.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKFieldNumeric extends StatefulWidget {
  final double? textSize;
  final double value;
  final double min;
  final double max;
  final double increment;
  final int decimals;
  final bool enabled;
  final String units;
  final Function(double)? onValueChanged;
  final Function(double)? onTextChanged;

  const CKFieldNumeric({
    Key? key,
    this.textSize = 12,
    this.value = 0.0,
    this.min = -double.infinity,
    this.max = double.infinity,
    this.increment = double.infinity, // If infinity, buttons are hidden
    this.decimals = 1, // Valor per defecte, sense decimals si no s'especifica
    this.enabled = true,
    this.units = "",
    this.onValueChanged,
    this.onTextChanged,
  }) : super(key: key);

  @override
  CKFieldNumericState createState() => CKFieldNumericState();
}

class CKFieldNumericState extends State<CKFieldNumeric> {
  late TextEditingController _controller;
  double previousValue = double.infinity;

  @override
  void initState() {
    super.initState();
    _checkWidgetValue();
    _controller = TextEditingController(text: _fixText(widget.value));
    _controller.addListener(_onTextChanged);
  }

  void _checkWidgetValue() {
    if (widget.max <= widget.min) {
      throw Exception("DSKFieldNumeric: max must be greater than min");
    }
    if (widget.value < widget.min || widget.value > widget.max) {
      throw Exception(
          "DSKFieldNumeric: defaultValue must be between min and max");
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  double _fixValue(String text) {
    final match =
        RegExp(r'-?\d+(\.\d+)?').firstMatch(text.replaceAll(',', '.'));
    final numberStr =
        match != null ? match.group(0)! : widget.value.toString();

    final number = double.parse(numberStr);
    final powCal = pow(10, widget.decimals);
    return (number * powCal).round() / powCal;
  }

  String _fixText(double value) {
    String rst = value.toStringAsFixed(widget.decimals);
    if (widget.units != "") {
      rst += " ${widget.units}";
    }
    return rst;
  }

  void _setCurrentValue(String text) {
    double newValue = _fixValue(text);

    // Set cursor to end of text
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    widget.onValueChanged?.call(newValue);
  }

  _focusChanged(bool hasFocus) {
    if (!hasFocus) {
      _setCurrentValue(_controller.text);
    }
  }

  void _onTextChanged() {
    widget.onTextChanged?.call(_fixValue(_controller.text));
  }

  void _incrementValue() {
    double value = _fixValue(_controller.text);
    value = min(value + widget.increment, widget.max);
    _setCurrentValue(value.toString());
  }

  void _decrementValue() {
    double value = _fixValue(_controller.text);
    value = max(value - widget.increment, widget.min);
    _setCurrentValue(value.toString());
  }

  @override
  Widget build(BuildContext context) {

    if (previousValue != widget.value) {
      _checkWidgetValue();
      previousValue = widget.value;
      _controller.text = _fixText(widget.value);
    }
    
    bool enabledUp = widget.value < widget.max;
    bool enabledDown = widget.value > widget.min;

    return Row(
      children: <Widget>[
        Expanded(
          child: CKFieldText(
            controller: _controller,
            enabled: widget.enabled,
            textSize: widget.textSize,
            textAlign: TextAlign.right,
            onFocusChanged: _focusChanged,
            keyboardType: TextInputType.text,
          ),
        ),
        widget.increment == double.infinity
            ? Container()
            : const SizedBox(width: 4),
        widget.increment == double.infinity
            ? Container()
            : CKButtonsUpDown(
                enabledUp: widget.enabled && enabledUp,
                enabledDown: widget.enabled && enabledDown,
                onUpPressed: _incrementValue,
                onDownPressed: _decrementValue,
              ),
      ],
    );
  }
}
