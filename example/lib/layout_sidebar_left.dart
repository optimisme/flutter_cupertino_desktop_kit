import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/flutter_cupertino_desktop_kit.dart';

class LayoutSidebarLeft extends StatefulWidget {
  final List<String> options;
  final void Function(int, String) onSelect;

  const LayoutSidebarLeft(
      {super.key, this.options = const [], required this.onSelect});

  @override
  State<LayoutSidebarLeft> createState() => LayoutButtonsState();
}

class LayoutButtonsState extends State<LayoutSidebarLeft> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    CDKTheme theme = CDKThemeNotifier.of(context)!.changeNotifier;

    bool isAccent = true;

    Color colorText = theme.getSidebarColorText(false, isAccent);
    TextStyle textStyle = TextStyle(fontSize: 14, color: colorText);

    final selectedRadio = theme.appearanceConfig;
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
            child: CDKButtonSidebar(
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
                CDKButtonRadio(
                  isSelected: selectedRadio == CDKThemeAppearance.system,
                  onSelected: (bool? isSelected) {
                    setState(() {
                      theme.setAppearanceConfig(
                          type: CDKThemeAppearance.system);
                    });
                  },
                  child: Text("System", style: textStyle),
                ),
                const SizedBox(height: 8),
                CDKButtonRadio(
                  isSelected: selectedRadio == CDKThemeAppearance.light,
                  onSelected: (bool? isSelected) {
                    setState(() {
                      theme.setAppearanceConfig(type: CDKThemeAppearance.light);
                    });
                  },
                  child: Text("Light", style: textStyle),
                ),
                const SizedBox(height: 8),
                CDKButtonRadio(
                  isSelected: selectedRadio == CDKThemeAppearance.dark,
                  onSelected: (bool? isSelected) {
                    setState(() {
                      theme.setAppearanceConfig(type: CDKThemeAppearance.dark);
                    });
                  },
                  child: Text("Dark", style: textStyle),
                ),
                const SizedBox(height: 16),
                Text("Primary color: ", style: textStyle),
                const SizedBox(height: 8),
                CDKPickerThemeColors(
                  colors: CDKTheme.systemColors,
                  onColorChanged: (String colorName) {
                    // ignore: avoid_print
                    print("Color changed: $colorName");
                  },
                ),
              ]))
    ]);
  }
}
