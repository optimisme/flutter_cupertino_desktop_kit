import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'dsk_field_text.dart';
import 'dsk_buttons_up_down.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKFieldNumeric extends StatefulWidget {
  final double? textSize;
  final double defaultValue;
  final double min;
  final double max;
  final double increment;
  final int decimals;
  final bool enabled;
  final String units;
  final Function(double)? onValueChanged;
  final Function(double)? onTextChanged;

  const DSKFieldNumeric({
    Key? key,
    this.textSize = 12,
    this.defaultValue = 0.0,
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
  DSKFieldNumericState createState() => DSKFieldNumericState();
}

class DSKFieldNumericState extends State<DSKFieldNumeric> {
  late TextEditingController _controller;
  //late RegExp _decimalRegex;
  bool _isUpdating = false;
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = _fixValue(widget.defaultValue.toString());
    _controller = TextEditingController(text: _fixText(_currentValue));
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void setValue(double value) {
    setState(() {
      _currentValue = _fixValue(value.toString());
      _setCurrentValue();
    });
  }

  double _fixValue(String text) {
    final match =
        RegExp(r'-?\d+(\.\d+)?').firstMatch(text.replaceAll(',', '.'));
    final numberStr =
        match != null ? match.group(0)! : _currentValue.toString();

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

  void _setCurrentValue() {
    if (_isUpdating) {
      return;
    }

    _isUpdating = true;
    _controller.text = _fixText(_currentValue);

    // Set cursor to end of text
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    widget.onValueChanged?.call(_currentValue);
    _isUpdating = false;
  }

  _focusChanged(bool hasFocus) {
    if (!hasFocus) {
      _currentValue = _fixValue(_controller.text);
      _setCurrentValue();
    }
  }

  void _onTextChanged() {
    widget.onTextChanged?.call(_fixValue(_controller.text));
  }

  void _incrementValue() {
    double value = _fixValue(_controller.text);
    value = (value + widget.increment);
    if (value < widget.min) value = widget.min;
    if (value > widget.max) value = widget.max;
    _currentValue = value;
    _setCurrentValue();
    setState(() {});
  }

  void _decrementValue() {
    double value = _fixValue(_controller.text);
    value = (value - widget.increment);
    if (value < widget.min) value = widget.min;
    if (value > widget.max) value = widget.max;
    _currentValue = value;
    _setCurrentValue();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool enabledUp = _currentValue < widget.max;
    bool enabledDown = _currentValue > widget.min;

    return Row(
      children: <Widget>[
        Expanded(
          child: DSKFieldText(
            controller: _controller,
            enabled: widget.enabled,
            textSize: widget.textSize,
            textAlign: TextAlign.right,
            onFocusChanged: _focusChanged,
            //keyboardType: TextInputType.numberWithOptions(
            //    signed: true, decimal: widget.decimals > 0),
            keyboardType: TextInputType.text,
            //inputFormatters: [
            //  FilteringTextInputFormatter.allow(_decimalRegex),
            //],
          ),
        ),
        widget.increment == double.infinity
            ? Container()
            : const SizedBox(width: 4),
        widget.increment == double.infinity
            ? Container()
            : DSKButtonsUpDown(
                enabledUp: widget.enabled && enabledUp,
                enabledDown: widget.enabled && enabledDown,
                onUpPressed: _incrementValue,
                onDownPressed: _decrementValue,
              ),
      ],
    );
  }
}
