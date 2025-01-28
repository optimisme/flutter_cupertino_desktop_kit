import 'package:flutter/cupertino.dart';
import 'cdk_field_numeric.dart';
import 'cdk_picker_360.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CDKField360 extends StatefulWidget {
  final double value;
  final double textSize;
  final bool enabled;
  final Function(double)? onChanged;
  const CDKField360({
    super.key,
    this.value = 0.0,
    this.textSize = 12,
    this.enabled = true,
    this.onChanged,
  });

  @override
  CDKField360State createState() => CDKField360State();
}

class CDKField360State extends State<CDKField360> {
  double previousValue = 0.0;

  @override
  void initState() {
    super.initState();
    previousValue = _adjustAngle(widget.value);
  }

  double _adjustAngle(double angle) {
    return (angle % 360 + 360) % 360;
  }

  void _onValueChanged(double newValue) {
    final adjustedValue = _adjustAngle(newValue);
    if (adjustedValue != previousValue) {
      previousValue = adjustedValue;
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
        CDKPicker360(
          value: value,
          size: widget.textSize + 8,
          enabled: widget.enabled,
          onChanged: _onValueChanged,
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 64,
          child: CDKFieldNumeric(
            value: value,
            textSize: widget.textSize,
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
