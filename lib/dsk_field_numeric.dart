import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dsk_field_text.dart';

class DSKFieldNumeric extends StatefulWidget {
  final double defaultValue;
  final double min;
  final double max;
  final double increment;
  final int decimals; // Nou paràmetre per limitar el número de decimals
  final Function(double)? onChanged;

  const DSKFieldNumeric({
    Key? key,
    required this.defaultValue,
    required this.min,
    required this.max,
    required this.increment,
    this.decimals = 0, // Valor per defecte, sense decimals si no s'especifica
    this.onChanged,
  }) : super(key: key);

  @override
  DSKFieldNumericState createState() => DSKFieldNumericState();
}

class DSKFieldNumericState extends State<DSKFieldNumeric> {
  late TextEditingController _controller;
  late RegExp decimalRegex;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.defaultValue.toStringAsFixed(widget.decimals));
    decimalRegex = RegExp(r'^\d+\.?\d{0,' + widget.decimals.toString() + r'}$');
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    String text = _controller.text;
    if (decimalRegex.hasMatch(text)) {
      double? currentValue = double.tryParse(text);
      if (currentValue != null) {
        widget.onChanged?.call(currentValue);
      }
    } else {
      _controller.text =
          double.tryParse(text)?.toStringAsFixed(widget.decimals) ?? '';
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
    }
  }

  void _incrementValue() {
    double currentValue = double.parse(_controller.text);
    currentValue =
        (currentValue + widget.increment).clamp(widget.min, widget.max);
    _controller.text = currentValue.toStringAsFixed(widget.decimals);
  }

  void _decrementValue() {
    double currentValue = double.parse(_controller.text);
    currentValue =
        (currentValue - widget.increment).clamp(widget.min, widget.max);
    _controller.text = currentValue.toStringAsFixed(widget.decimals);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _decrementValue,
          child: const Icon(CupertinoIcons.minus_circled),
        ),
        Expanded(
          child: DSKFieldText(
            controller: _controller,
            keyboardType:
                TextInputType.numberWithOptions(decimal: widget.decimals > 0),
            inputFormatters: [
              FilteringTextInputFormatter.allow(decimalRegex),
            ],
            // Añadir otras propiedades y callbacks según sea necesario
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _incrementValue,
          child: const Icon(CupertinoIcons.add_circled),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }
}
