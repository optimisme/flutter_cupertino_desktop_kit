import 'package:flutter/cupertino.dart';
import 'dsk_field_numeric.dart';
import 'dsk_picker_360.dart';
import 'dsk_theme_manager.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKField360 extends StatefulWidget {
  final double defaultValue;
  final double textSize;
  final bool enabled;
  final Function(double)? onChanged;
  const DSKField360({
    Key? key,
    this.defaultValue = 0.0,
    this.textSize = 12,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  DSKField360State createState() => DSKField360State();
}

class DSKField360State extends State<DSKField360> {
  GlobalKey<DSKPicker360State> keyPicker = GlobalKey();
  GlobalKey<DSKFieldNumericState> keyNumeric = GlobalKey();
  double _currentAngle = 0;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    DSKThemeManager().addListener(_update);
    _currentAngle = widget.defaultValue;
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

  void _onChanged(String origin, double angle) {
    if (_isUpdating) {
      return;
    }
    setState(() {
      _isUpdating = true;
      _currentAngle = angle;
      if (origin == "picker") {
        keyNumeric.currentState?.setValue(angle);
      }
      if (origin == "numeric") {
        keyPicker.currentState?.setValue(angle);
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
        DSKPicker360(
          key: keyPicker,
          defaultValue: _currentAngle,
          size: widget.textSize + 8,
          enabled: widget.enabled,
          onChanged: (angle) {
            _onChanged("picker", angle);
          },
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 64,
          child: DSKFieldNumeric(
            key: keyNumeric,
            defaultValue: _currentAngle,
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
