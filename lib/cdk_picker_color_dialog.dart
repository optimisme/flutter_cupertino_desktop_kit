import 'package:flutter/cupertino.dart';
import 'cdk_picker_slider_chroma.dart';
import 'cdk_theme.dart';
import 'cdk_theme_notifier.dart';

class CDKPickerColorDialog extends StatefulWidget {
  final Function(Color)? onChanged;

  const CDKPickerColorDialog({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  CDKPickerColorDialogState createState() => CDKPickerColorDialogState();
}

class CDKPickerColorDialogState extends State<CDKPickerColorDialog> {
  double _valueSliderSaturation = 0.5;
  double _valueSliderBrightness = 0.5;
  Color _valueSliderSB = CDKTheme.red;


  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    return Container(color: theme.background, child:
    Padding(padding: const EdgeInsets.all(0), child:
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text('Brightness/Saturation', style: TextStyle(fontSize: 12, color: theme.colorText)),
      CDKPickerSliderChroma(
                  staturation: _valueSliderSaturation,
                  brightness: _valueSliderBrightness,
                  hueColor: _valueSliderSB,
                  onChanged: (saturation, brightness) {
                    setState(() {
                      _valueSliderSaturation = saturation;
                      _valueSliderBrightness = brightness;
                    });
                  },
                ),
    ],)));
  
  }
}
