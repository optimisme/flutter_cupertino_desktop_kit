import 'package:flutter/cupertino.dart';
import 'dsk_theme_manager.dart';
import 'dsk_theme_colors.dart';

class DSKButtonCheckList extends StatefulWidget {
  final List<String> options;
  final int defaultIndex;
  final double size;
  final Function(int, String)? onSelect;

  const DSKButtonCheckList({
    Key? key,
    required this.options,
    this.size = 12.0,
    this.defaultIndex = 0,
    this.onSelect,
  }) : super(key: key);

  @override
  DSKButtonCheckListState createState() => DSKButtonCheckListState();
}

class DSKButtonCheckListState extends State<DSKButtonCheckList> {
  int? _hoverIndex;
  int _selectedIndex = 0;

  _select(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onSelect?.call(index, widget.options[index]);
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
        child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 300, // Alçada màxima de 300 pixels
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(widget.options.length, (index) {
            bool isSelected = index == _selectedIndex;
            bool isHovered = index == _hoverIndex;
            return MouseRegion(
                onEnter: (_) => setState(() => _hoverIndex = index),
                onExit: (_) => setState(() => _hoverIndex = null),
                child: GestureDetector(
                  onTap: () => _select(index),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color:
                          isHovered ? DSKColors.accent : DSKColors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: widget.size * 1.5,
                            child: !isSelected
                                ? null
                                : Icon(CupertinoIcons.check_mark,
                                    size: widget.size,
                                    color: isHovered
                                        ? DSKColors.background
                                        : DSKColors.text)),
                        Text(
                          widget.options[index],
                          style: TextStyle(
                              fontSize: widget.size,
                              color: DSKThemeManager.isLight && isHovered
                                  ? DSKColors.background
                                  : DSKColors.text),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
        ),
      ),
    ));
  }
}
