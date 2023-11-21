import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dsk_field_text.dart';
import 'dsk_buttons_up_down.dart';

class DSKFieldNumeric extends StatefulWidget {
  final double? textSize;
  final double defaultValue;
  final double min;
  final double max;
  final double increment;
  final int decimals; // Nou paràmetre per limitar el número de decimals
  final Function(double)? onChanged;

  const DSKFieldNumeric({
    Key? key,
    this.textSize = 12,
    this.defaultValue = 0.0,
    this.min = -double.infinity,
    this.max = double.infinity,
    this.increment = double.infinity, // If infinity, buttons are hidden
    this.decimals = 1, // Valor per defecte, sense decimals si no s'especifica
    this.onChanged,
  }) : super(key: key);

  @override
  DSKFieldNumericState createState() => DSKFieldNumericState();
}

class DSKFieldNumericState extends State<DSKFieldNumeric> {
  late TextEditingController _controller;
  late RegExp _decimalRegex;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.defaultValue.toStringAsFixed(widget.decimals));
    if (widget.decimals != double.infinity) {
      String str = '{0,${widget.decimals}}';
      _decimalRegex = RegExp(r'^-?\d*\.?\d' + str);
    } else {
      _decimalRegex = RegExp(r'^-?\d*\.?\d*');
    }

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_isUpdating) {
      return;
    }

    String text = _controller.text;

    // Comprova si el text compleix amb el patró decimal.
    if (!_decimalRegex.hasMatch(text)) {
      return;
    }

    double currentValue = double.parse(text);
    if (currentValue < widget.min || currentValue > widget.max) {
      _isUpdating = true;

      // Actualitza el valor dins dels límits.
      currentValue = currentValue.clamp(widget.min, widget.max);
      _controller.text = currentValue.toStringAsFixed(widget.decimals);

      // Restableix el cursor a la posició correcta.
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));

      _isUpdating = false;
    }

    widget.onChanged?.call(currentValue);
  }

  void _incrementValue() {
    double currentValue = double.parse(_controller.text);
    currentValue = (currentValue + widget.increment);
    if (currentValue < widget.min) currentValue = widget.min;
    if (currentValue > widget.max) currentValue = widget.max;
    _controller.text = currentValue.toStringAsFixed(widget.decimals);
    setState(() {});
  }

  void _decrementValue() {
    double currentValue = double.parse(_controller.text);
    currentValue = (currentValue - widget.increment);
    if (currentValue < widget.min) currentValue = widget.min;
    if (currentValue > widget.max) currentValue = widget.max;
    _controller.text = currentValue.toStringAsFixed(widget.decimals);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: DSKFieldText(
            controller: _controller,
            textSize: widget.textSize,
            keyboardType: TextInputType.numberWithOptions(
                signed: true, decimal: widget.decimals > 0),
            inputFormatters: [
              FilteringTextInputFormatter.allow(_decimalRegex),
            ],
          ),
        ),
        widget.increment == double.infinity
            ? Container()
            : const SizedBox(width: 4),
        widget.increment == double.infinity
            ? Container()
            : DSKButtonsUpDown(
                isDisabled: widget.increment == double.infinity,
                onUpPressed: _incrementValue,
                onDownPressed: _decrementValue,
              ),
      ],
    );
  }
}
