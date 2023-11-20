import 'package:flutter/cupertino.dart';
import 'dsk_theme_colors.dart';

class DSKThemeManager {
  static bool isLight = true;
  static bool isAppFocused = true;
  static String appearanceConfig = "system"; // light, dark, system
  static String themeColor = "systemBlue";

  static CupertinoThemeData getThemeData(BuildContext context, String type) {
    String appearance = type;

    // Set accent color
    DSKColors.initColors(themeColor);
    CupertinoThemeData baseTheme =
        CupertinoThemeData(primaryColor: DSKColors.systemColors[themeColor]);

    // Define light/dark appearance
    appearanceConfig = type;
    if (appearanceConfig == "system") {
      var brightness = MediaQuery.of(context).platformBrightness;
      appearance = (brightness == Brightness.light) ? "light" : "dark";
    } else {
      appearance = appearanceConfig;
    }

    // Set light/dark appearance colors and return theme
    if (appearance == "light") {
      isLight = true;
      DSKColors.background = CupertinoColors.white;
      DSKColors.backgroundSecondary0 = CupertinoColors.white;
      DSKColors.backgroundSecondary1 = CupertinoColors.systemGrey5;
      DSKColors.text = CupertinoColors.black;
      return baseTheme.copyWith(brightness: Brightness.light);
    } else {
      isLight = false;
      DSKColors.background = const Color.fromRGBO(35, 35, 35, 1);
      DSKColors.backgroundSecondary0 = const Color.fromRGBO(95, 95, 95, 1);
      DSKColors.backgroundSecondary1 = const Color.fromRGBO(55, 55, 55, 1);
      DSKColors.text = CupertinoColors.white;
      return baseTheme.copyWith(brightness: Brightness.dark);
    }
  }

  static void setAccentColour(String name) {
    Color? color = DSKColors.systemColors[name];
    themeColor = name;

    if (color == null) {
      color = DSKColors.systemColors["systemBlue"];
      themeColor = "systemBlue";
    }

    DSKColors.initColors(themeColor);
  }

  static void setAppFocus(bool value) {
    isAppFocused = value;
  }
}
