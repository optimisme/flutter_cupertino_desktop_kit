import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop/ck_widgets.dart';

class LayoutSidebarLeft extends StatefulWidget {
  final List<String> options;
  final Function(int, String) onSelect;

  const LayoutSidebarLeft(
      {Key? key, this.options = const [], required this.onSelect})
      : super(key: key);

  @override
  State<LayoutSidebarLeft> createState() => LayoutButtonsState();
}

class LayoutButtonsState extends State<LayoutSidebarLeft> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    CKTheme theme = CKThemeNotifier.of(context)!.changeNotifier;

    bool isAccent = true;

    Color colorText = theme.getSidebarColorText(false, isAccent);
    TextStyle textStyle = TextStyle(fontSize: 14, color: colorText);

    String selectedRadio = theme.appearanceConfig;
    return ListView(children: [
      const SizedBox(height: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.options.length, (int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.onSelect(index, widget.options[index]);
                _selectedIndex = index;
              });
            },
            child: CKButtonSidebar(
              isSelected: _selectedIndex == index,
              isAccent: true,
              onSelected: () {
                setState(() {
                  widget.onSelect(index, widget.options[index]);
                  _selectedIndex = index;
                });
              },
              child: Text(widget.options[index]),
            ),
          );
        }),
      ),
      const SizedBox(height: 25),
      Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Theme: ", style: textStyle),
                const SizedBox(height: 8),
                CKButtonRadio(
                  isSelected: selectedRadio == "system",
                  onSelected: (bool? isSelected) {
                    setState(() {
                      selectedRadio = "system";
                      theme.setAppearanceConfig(context);
                    });
                  },
                  child: Text("System", style: textStyle),
                ),
                const SizedBox(height: 8),
                CKButtonRadio(
                  isSelected: selectedRadio == "light",
                  onSelected: (bool? isSelected) {
                    setState(() {
                      selectedRadio = "light";
                      theme.setAppearanceConfig(context, type: "light");
                    });
                  },
                  child: Text("Light", style: textStyle),
                ),
                const SizedBox(height: 8),
                CKButtonRadio(
                  isSelected: selectedRadio == "dark",
                  onSelected: (bool? isSelected) {
                    setState(() {
                      selectedRadio = "dark";
                      theme.setAppearanceConfig(context, type: "dark");
                    });
                  },
                  child: Text("Dark", style: textStyle),
                ),
                const SizedBox(height: 16),
                Text("Primary color: ", style: textStyle),
                const SizedBox(height: 8),
                CKPickerThemeColors(
                  colors: CKTheme.systemColors,
                  onColorChanged: (String colorName) {
                    // ignore: avoid_print
                    print("Color changed: $colorName");
                  },
                ),
              ]))
    ]);
  }
}
