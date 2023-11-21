
import 'package:flutter/cupertino.dart';
import 'dsk_button_disclosure.dart';
import 'dsk_theme_colors.dart';


class DSKPickerDisclosure extends StatefulWidget {
  final Widget sideWidget;
  final Widget bottomWidget;
  final ValueChanged<bool> onChanged;

  const DSKPickerDisclosure({
    Key? key,
    required this.sideWidget,
    required this.bottomWidget,
    this.onChanged = _defaultOnChanged,
  }) : super(key: key);

  @override
  DSKPickerDisclosureState createState() => DSKPickerDisclosureState();

  static void _defaultOnChanged(bool value) {}
}

class DSKPickerDisclosureState extends State<DSKPickerDisclosure> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDisclosure() {
    if (_controller.isCompleted) {
      _controller.reverse();
      _isExpanded = false;
    } else {
      _controller.forward();
      _isExpanded = true;
    }
    widget.onChanged(_controller.isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            DSKButtonDisclosure(
              value: _isExpanded,
              onChanged: (newValue) => _toggleDisclosure(),
            ),
            Expanded(child: widget.sideWidget),
          ],
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          axisAlignment: -1.0,
          child: Container(
            width: double.infinity, // Això estira el widget horitzontalment
            child: widget.bottomWidget),
        ),
      ],
    );
  }
}