import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'cdk_field_text.dart';
import 'cdk_buttons_up_down.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKFieldNumeric extends StatefulWidget {
  final double? textSize;
  final double value;
  final double min;
  final double max;
  final double increment;
  final int decimals;
  final bool enabled;
  final String units;
  final ValueChanged<double>? onValueChanged;
  final ValueChanged<double>? onTextChanged;

  const CDKFieldNumeric({
    super.key,
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
  });

  @override
  State<CDKFieldNumeric> createState() => _CDKFieldNumericState();
}

class _CDKIncrementIntent extends Intent {
  const _CDKIncrementIntent();
}

class _CDKDecrementIntent extends Intent {
  const _CDKDecrementIntent();
}

class _CDKFieldNumericState extends State<CDKFieldNumeric> {
  late TextEditingController _controller;
  double _previousValue = double.infinity;
  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowUp): _CDKIncrementIntent(),
    SingleActivator(LogicalKeyboardKey.arrowDown): _CDKDecrementIntent(),
  };

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

  double _fixValue(String text) {
    final match =
        RegExp(r'-?\d+(\.\d+)?').firstMatch(text.replaceAll(',', '.'));
    final numberStr = match != null ? match.group(0)! : widget.value.toString();

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
    bool valueChanged = false;

    if (newValue < widget.min) {
      newValue = widget.min;
      valueChanged = true;
    } else if (newValue > widget.max) {
      newValue = widget.max;
      valueChanged = true;
    }

    // Actualitza el text i el cursor
    _controller.text = _fixText(newValue);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    // Notifica el canvi al pare si el valor ha canviat
    if (valueChanged || newValue != _previousValue) {
      widget.onValueChanged?.call(newValue);
      _previousValue = newValue;
    }
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
    double value = widget.value;
    if (value < widget.min || value > widget.max) {
      _setCurrentValue(value.toString());
    }

    if (_previousValue != widget.value) {
      _previousValue = widget.value;
      _controller.text = _fixText(value);
    }

    bool enabledUp = widget.value < widget.max;
    bool enabledDown = widget.value > widget.min;

    Widget child = Row(
      children: <Widget>[
        Expanded(
          child: CDKFieldText(
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
            : CDKButtonsUpDown(
                enabledUp: widget.enabled && enabledUp,
                enabledDown: widget.enabled && enabledDown,
                onUpPressed: _incrementValue,
                onDownPressed: _decrementValue,
              ),
      ],
    );

    if (widget.increment == double.infinity) {
      return child;
    }

    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: Shortcuts(
        shortcuts: _shortcuts,
        child: Actions(
          actions: <Type, Action<Intent>>{
            _CDKIncrementIntent: CallbackAction<_CDKIncrementIntent>(
              onInvoke: (_) {
                if (widget.enabled) {
                  _incrementValue();
                }
                return null;
              },
            ),
            _CDKDecrementIntent: CallbackAction<_CDKDecrementIntent>(
              onInvoke: (_) {
                if (widget.enabled) {
                  _decrementValue();
                }
                return null;
              },
            ),
          },
          child: child,
        ),
      ),
    );
  }
}
