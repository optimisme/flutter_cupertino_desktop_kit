import 'package:flutter/cupertino.dart';
import 'ck_field_numeric.dart';
import 'ck_picker_360.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKField360 extends StatefulWidget {
  final double value;
  final double textSize;
  final bool enabled;
  final Function(double)? onChanged;
  const CKField360({
    Key? key,
    this.value = 0.0,
    this.textSize = 12,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  CKField360State createState() => CKField360State();
}

class CKField360State extends State<CKField360> {
  double _previousValue = 0.0;

  @override
  void initState() {
    super.initState();
    _previousValue = _adjustAngle(widget.value);
  }

  double _adjustAngle(double angle) {
    return (angle % 360 + 360) % 360;
  }

  void _onValueChanged(double newValue) {
    final adjustedValue = _adjustAngle(newValue);
    if (adjustedValue != _previousValue) {
      _previousValue = adjustedValue;
      widget.onChanged?.call(adjustedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    double value = _adjustAngle(widget.value);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Container()),
        CKPicker360(
          value: value,
          size: widget.textSize + 8,
          enabled: widget.enabled,
          onChanged: _onValueChanged,
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 64,
          child: CKFieldNumeric(
            value: value,
            textSize: widget.textSize,
            min: 0,
            max: 360,
            increment: 1,
            decimals: 0,
            enabled: widget.enabled,
            units: "°",
            onValueChanged: _onValueChanged,
          ),
        )
      ],
    );
  }
}
