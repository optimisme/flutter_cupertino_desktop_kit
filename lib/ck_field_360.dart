import 'package:flutter/cupertino.dart';
import 'ck_field_numeric.dart';
import 'ck_picker_360.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CKField360 extends StatefulWidget {
  final double defaultValue;
  final double textSize;
  final bool enabled;
  final Function(double)? onChanged;
  const CKField360({
    Key? key,
    this.defaultValue = 0.0,
    this.textSize = 12,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  CKField360State createState() => CKField360State();
}

class CKField360State extends State<CKField360> {
  GlobalKey<CKPicker360State> keyPicker = GlobalKey();
  GlobalKey<CKFieldNumericState> keyNumeric = GlobalKey();
  double _currentAngle = 0;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentAngle = widget.defaultValue;
  }

  void _onChanged(String origin, double angle) {
    if (_isUpdating) {
      return;
    }
    setState(() {
      _isUpdating = true;
      _currentAngle = angle;
      if (origin == "picker") {
        // TODO keyNumeric.currentState?.setValue(angle);
      }
      if (origin == "numeric") {
        // TODO keyPicker.currentState?.setValue(angle);
      }
      widget.onChanged?.call(angle);
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Container()),
        CKPicker360(
          key: keyPicker,
          value: _currentAngle,
          size: widget.textSize + 8,
          enabled: widget.enabled,
          onChanged: (angle) {
            _onChanged("picker", angle);
          },
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 64,
          child: CKFieldNumeric(
            key: keyNumeric,
            value: _currentAngle,
            textSize: widget.textSize,
            min: 0,
            max: 360,
            increment: 1,
            decimals: 0,
            enabled: widget.enabled,
            units: "°",
            onValueChanged: (angle) {
              _onChanged("numeric", angle);
            },
          ),
        )
      ],
    );
  }
}
