import 'package:flutter/cupertino.dart';
import 'ck_field_numeric.dart';
import 'ck_picker_slider.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKFieldNumericSlider extends StatefulWidget {
  final double defaultValue;
  final double textSize;
  final double min;
  final double max;
  final double increment;
  final int decimals;
  final bool enabled;
  final String units;
  final Function(double)? onValueChanged;
  final Function(double)? onTextChanged;
  const CKFieldNumericSlider({
    Key? key,
    this.defaultValue = 0.0,
    this.textSize = 12,
    this.min = 0,
    this.max = 1,
    this.increment = double.infinity, // If infinity, buttons are hidden
    this.decimals = 1, // Valor per defecte, sense decimals si no s'especifica
    this.units = "",
    this.enabled = true,
    this.onValueChanged,
    this.onTextChanged,
  }) : super(key: key);

  @override
  CKFieldNumericSliderState createState() => CKFieldNumericSliderState();
}

class CKFieldNumericSliderState extends State<CKFieldNumericSlider> {
  GlobalKey<CKPickerSliderState> keyPicker = GlobalKey();
  GlobalKey<CKFieldNumericState> keyNumeric = GlobalKey();
  double _currentValue = 0;
  double _distance = 0;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _checkInit();
  }

  @override
  void didUpdateWidget(CKFieldNumericSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkInit();
  }

  void _checkInit() {
    if (widget.max == double.infinity || widget.min == double.infinity) {
      throw Exception(
          "DSKFieldNumericSlider: max and min must be specified and not infinity");
    }
    _distance = (widget.max - widget.min).abs();
    _currentValue = widget.defaultValue;
  }

  void _onValueChanged(String origin, double value) {
    if (_isUpdating) {
      return;
    }
    setState(() {
      _isUpdating = true;
      if (origin == "picker") {
        _currentValue = value * _distance + widget.min;
        keyNumeric.currentState?.setValue(_currentValue);
      }
      if (origin == "numeric") {
        _currentValue = value;
        keyPicker.currentState?.setValue((value - widget.min) / _distance);
      }
      widget.onValueChanged?.call(_currentValue);
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: CKPickerSlider(
          key: keyPicker,
          defaultValue: (_currentValue - widget.min) / _distance,
          size: widget.textSize + 8,
          enabled: widget.enabled,
          onChanged: (value) {
            _onValueChanged("picker", value);
          },
        )),
        const SizedBox(width: 4),
        SizedBox(
          width: 64,
          child: CKFieldNumeric(
            key: keyNumeric,
            defaultValue: _currentValue,
            textSize: widget.textSize,
            min: widget.min,
            max: widget.max,
            increment: widget.increment,
            decimals: widget.decimals,
            enabled: widget.enabled,
            units: widget.units,
            onValueChanged: (value) {
              _onValueChanged("numeric", value);
            },
            onTextChanged: (value) {
              widget.onTextChanged?.call(value);
            },
          ),
        )
      ],
    );
  }
}
