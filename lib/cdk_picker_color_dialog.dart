import 'package:flutter/cupertino.dart';
import 'cdk_picker_slider_chroma.dart';
import 'cdk_picker_slider_gradient.dart';
import 'cdk_theme.dart';

class CDKPickerColorDialog extends StatefulWidget {
  final Color value;
  final Function(Color)? onChanged;

  const CDKPickerColorDialog({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  CDKPickerColorDialogState createState() => CDKPickerColorDialogState();
}

class CDKPickerColorDialogState extends State<CDKPickerColorDialog> {
  double _saturation = 0.5;
  double _brightness = 0.5;
  double _hue = 0.5;
  double _alpha = 0.5;

  final List<Color> _gradientHueColors = [CDKTheme.red, CDKTheme.yellow, CDKTheme.green, CDKTheme.cyan, CDKTheme.blue, CDKTheme.magenta, CDKTheme.red];
  final List<double> _gradientHueStops = const [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0];

  final List<Color> _gradientAlphaColors = [CDKTheme.white, CDKTheme.black];
  final List<double> _gradientAlphaStops = const [0.0, 1.0];


  @override
  void initState() {
    super.initState();
    HSVColor color = HSVColor.fromColor(widget.value); 
    _saturation = color.saturation;
    _brightness = color.value;
    _hue = color.hue / 360;
    _alpha = color.alpha;
  }

  void _callback() {
    if (widget.onChanged != null) {
      Color result = HSVColor.fromAHSV(
        _alpha, 
        _hue * 360, 
        _saturation,
        _brightness,
      ).toColor();
      widget.onChanged!(result);
    }
  }

  @override
  Widget build(BuildContext context) {

    Color hueSliderToColor = CDKPickerSliderGradient.getColorAtValue(
        _gradientHueColors, _gradientHueStops, _hue);

    return Column( 
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      CDKPickerSliderChroma(
        width: 150,
            staturation: _saturation,
            brightness: _brightness,
            hueColor: hueSliderToColor,
            onChanged: (saturation, brightness) {
              setState(() {
                _saturation = saturation;
                _brightness = brightness;
                _callback();
              });
            },
          ),
      const SizedBox(height: 8),
      SizedBox(width: 150, child:
        CDKPickerSliderGradient(
                    colors: _gradientHueColors,
                    stops: _gradientHueStops,
                    value: _hue,
                    onChanged: (value, color) {
                      setState(() {
                        _hue = value;
                        _callback();
                      });
                    },
                  )),
      const SizedBox(height: 8),
      SizedBox(width: 150, child:
        CDKPickerSliderGradient(
                    colors: _gradientAlphaColors,
                    stops: _gradientAlphaStops,
                    value: _alpha,
                    onChanged: (value, color) {
                      setState(() {
                        _alpha = value;
                        _callback();
                      });
                    },
                  )),
    ],);
  }
}
