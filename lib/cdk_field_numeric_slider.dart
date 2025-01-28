import 'package:flutter/cupertino.dart';
import 'cdk_field_numeric.dart';
import 'cdk_picker_slider.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKFieldNumericSlider extends StatefulWidget {
  final double value;
  final double textSize;
  final double min;
  final double max;
  final double increment;
  final int decimals;
  final bool enabled;
  final String units;
  final Function(double)? onValueChanged;
  final Function(double)? onTextChanged;
  const CDKFieldNumericSlider({
    super.key,
    this.value = 0.0,
    this.textSize = 12,
    this.min = 0,
    this.max = 1,
    this.increment = double.infinity, // If infinity, buttons are hidden
    this.decimals = 1, // Valor per defecte, sense decimals si no s'especifica
    this.units = "",
    this.enabled = true,
    this.onValueChanged,
    this.onTextChanged,
  });

  @override
  CDKFieldNumericSliderState createState() => CDKFieldNumericSliderState();
}

class CDKFieldNumericSliderState extends State<CDKFieldNumericSlider> {
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  void _onValueChanged(String origin, double newValue) {
    bool valueChanged = false;
    double distance = (widget.max - widget.min).abs();

    if (origin == "picker") {
      newValue = newValue * distance + widget.min;
    }

    if (newValue < widget.min) {
      newValue = widget.min;
      valueChanged = true;
    } else if (newValue > widget.max) {
      newValue = widget.max;
      valueChanged = true;
    }

    if (valueChanged || newValue != _previousValue) {
      widget.onValueChanged?.call(newValue);
      _previousValue = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    double distance = (widget.max - widget.min).abs();
    double sliderValue = ((widget.value - widget.min) / distance).clamp(0, 1);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: CDKPickerSlider(
          value: sliderValue,
          size: widget.textSize + 8,
          enabled: widget.enabled,
          onChanged: (value) {
            _onValueChanged("picker", value);
          },
        )),
        const SizedBox(width: 4),
        SizedBox(
          width: 64,
          child: CDKFieldNumeric(
            value: widget.value,
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
