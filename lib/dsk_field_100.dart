import 'package:flutter/cupertino.dart';
import 'dsk_field_numeric.dart';
import 'dsk_picker_slider.dart';
import 'dsk_theme_manager.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKField100 extends StatefulWidget {
  final double defaultValue;
  final double textSize;
  final bool enabled;
  final Function(double)? onChanged;
  const DSKField100({
    Key? key,
    this.defaultValue = 0.0,
    this.textSize = 12,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  DSKField100State createState() => DSKField100State();
}

class DSKField100State extends State<DSKField100> {
  GlobalKey<DSKPickerSliderState> keyPicker = GlobalKey();
  GlobalKey<DSKFieldNumericState> keyNumeric = GlobalKey();
  double _currentValue = 0;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    DSKThemeManager().addListener(_update);
    _currentValue = widget.defaultValue;
  }

  @override
  void dispose() {
    DSKThemeManager().removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onChanged(String origin, double value) {
    if (_isUpdating) {
      return;
    }
    setState(() {
      _isUpdating = true;
      if (origin == "picker") {
        _currentValue = value * 100;
        keyNumeric.currentState?.setValue(_currentValue);
      }
      if (origin == "numeric") {
        _currentValue = value;
        keyPicker.currentState?.setValue(value / 100);
      }
      widget.onChanged?.call(_currentValue);
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: DSKPickerSlider(
          key: keyPicker,
          defaultValue: _currentValue / 100,
          size: widget.textSize + 8,
          enabled: widget.enabled,
          onChanged: (value) {
            _onChanged("picker", value);
          },
        )),
        const SizedBox(width: 4),
        SizedBox(
          width: 64,
          child: DSKFieldNumeric(
            key: keyNumeric,
            defaultValue: _currentValue,
            textSize: widget.textSize,
            min: 0,
            max: 100,
            increment: 1,
            decimals: 0,
            enabled: widget.enabled,
            units: "%",
            onValueChanged: (value) {
              _onChanged("numeric", value);
            },
          ),
        )
      ],
    );
  }
}
