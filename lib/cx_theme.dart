import 'package:flutter/cupertino.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class CXTheme extends ChangeNotifier {
  // Appearance
  bool isLight = true;
  bool isAppFocused = true;
  String appearanceConfig = ""; // light, dark, system
  String colorConfig = "";

  // Abaliable theme colors
  static const Map<String, Color> systemColors = {
    "systemBlue": CupertinoColors.systemBlue,
    "systemPurple": CupertinoColors.systemPurple,
    "systemPink": CupertinoColors.systemPink,
    "systemRed": CupertinoColors.systemRed,
    "systemOrange": CupertinoColors.systemOrange,
    "systemYellow": CupertinoColors.systemYellow,
    "systemGreen": CupertinoColors.systemGreen,
    "systemGray": CupertinoColors.systemGrey,
  };

  // Constant predefined colors
  static const Color transparent = Color.fromRGBO(0, 0, 0, 0.0);
  static const Color white = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color black = Color.fromRGBO(0, 0, 0, 1.0);
  static const Color red = Color.fromRGBO(255, 0, 0, 1.0);
  static const Color green = Color.fromRGBO(0, 255, 0, 1.0);
  static const Color yellow = Color.fromRGBO(255, 255, 0, 1.0);
  static const Color blue = Color.fromRGBO(0, 0, 255, 1.0);

  static const Color grey50 = Color.fromRGBO(230, 230, 230, 1.0);
  static const Color grey60 = Color.fromRGBO(222, 222, 222, 1.0);
  static const Color grey70 = Color.fromRGBO(214, 214, 214, 1.0);
  static const Color grey80 = Color.fromRGBO(204, 204, 204, 1.0);
  static const Color grey90 = Color.fromRGBO(195, 195, 195, 1.0);
  static const Color grey100 = Color.fromRGBO(186, 186, 189, 1.0);
  static const Color grey200 = Color.fromRGBO(172, 172, 175, 1.0);
  static const Color grey300 = Color.fromRGBO(157, 157, 161, 1.0);
  static const Color grey = CupertinoColors.systemGrey;
  static const Color grey500 = Color.fromRGBO(127, 127, 133, 1.0);
  static const Color grey600 = Color.fromRGBO(112, 112, 112, 1.0);
  static const Color grey700 = Color.fromRGBO(99, 99, 103, 1.0);
  static const Color grey800 = Color.fromRGBO(85, 85, 85, 1.0);

  // Default colors for bacground and text (modified by dark/light mode)
  Color background = CupertinoColors.white;
  Color backgroundSecondary0 = CupertinoColors.white;
  Color backgroundSecondary1 = CupertinoColors.systemGrey5;
  Color colorText = CupertinoColors.black;
  Color colorTextSecondary = CupertinoColors.white;

  // Modified programatically
  Color accent50 = const Color.fromRGBO(131, 188, 252, 1.0);
  Color accent100 = const Color.fromRGBO(81, 162, 251, 1.0);
  Color accent200 = const Color.fromRGBO(56, 149, 250, 1.0);
  Color accent300 = const Color.fromRGBO(31, 135, 250, 1.0);
  Color accent = CupertinoColors.systemBlue;
  Color accent500 = const Color.fromRGBO(5, 110, 224, 1.0);
  Color accent600 = const Color.fromRGBO(5, 98, 199, 1.0);

  CupertinoThemeData getThemeData(
      BuildContext context, String initialAppearance, String initialColor) {
    String appearance = "";

    if (appearanceConfig == "") {
      appearanceConfig = initialAppearance;
    }

    if (colorConfig == "") {
      colorConfig = initialColor;
    }

    // Set accent color
    initColors(colorConfig);
    CupertinoThemeData baseTheme =
        CupertinoThemeData(primaryColor: systemColors[colorConfig]);

    appearance =
        setAppearanceConfig(context, type: appearanceConfig, notify: false);

    // Set light/dark appearance colors and return theme
    if (appearance == "light") {
      return baseTheme.copyWith(
          brightness: Brightness.light, scaffoldBackgroundColor: background);
    } else {
      return baseTheme.copyWith(
          brightness: Brightness.dark, scaffoldBackgroundColor: background);
    }
  }

  void setAppFocus(bool value) {
    isAppFocused = value;
    notifyListeners();
  }

  String setAppearanceConfig(BuildContext context,
      {String type = "system", bool notify = true}) {
    String appearance = ""; // only light or dark (no system)

    appearanceConfig = type;
    if (appearanceConfig == "system") {
      var brightness = MediaQuery.of(context).platformBrightness;
      appearance = (brightness == Brightness.light) ? "light" : "dark";
    } else {
      appearance = appearanceConfig;
    }

    _setAppearance(appearance, notify: notify);

    return appearance;
  }

  void _setAppearance(String type, {bool notify = true}) {
    // only light or dark (no system)
    String appearance = type;

    // Set accent color
    initColors(colorConfig);

    // Set light/dark appearance colors and return theme
    if (appearance == "light") {
      isLight = true;
      background = CupertinoColors.white;
      backgroundSecondary0 = CupertinoColors.white;
      backgroundSecondary1 = CupertinoColors.systemGrey5;
      colorText = CupertinoColors.black;
      colorTextSecondary = CupertinoColors.white;
    } else {
      isLight = false;
      background = const Color.fromARGB(255, 32, 32, 32);
      backgroundSecondary0 = const Color.fromRGBO(95, 95, 95, 1);
      backgroundSecondary1 = const Color.fromRGBO(55, 55, 55, 1);
      colorText = CupertinoColors.white;
      colorTextSecondary = CupertinoColors.black;
    }

    if (notify) {
      notifyListeners();
    }
  }

  void setAccentColour(String name) {
    Color? color = systemColors[name];
    colorConfig = name;

    if (color == null) {
      color = systemColors["systemBlue"];
      colorConfig = "systemBlue";
    }

    initColors(colorConfig);
    notifyListeners();
  }

  void initColors(themeColor) {
    Color? color = systemColors[themeColor];

    color = adjustColor(color!, 0.95, 1);
    accent50 = adjustColor(color, 1, 1.5);
    accent100 = adjustColor(color, 1, 1.3);
    accent200 = adjustColor(color, 1, 1.2);
    accent300 = adjustColor(color, 1, 1.1);
    accent = color;
    accent500 = adjustColor(color, 1, 0.9);
    accent600 = adjustColor(color, 1, 0.8);
  }

  static Color adjustColor(
      Color color, double saturationFactor, double brightnessFactor) {
    HSLColor hsl = HSLColor.fromColor(color);
    HSLColor adjusted = HSLColor.fromAHSL(
      hsl.alpha,
      hsl.hue,
      (hsl.saturation * saturationFactor).clamp(0.0, 1.0),
      (hsl.lightness * brightnessFactor).clamp(0.0, 1.0),
    );
    return adjusted.toColor();
  }

  Color getSidebarColorText(bool isSelected, bool isAccent) {
    return isLight
        ? (isSelected
            ? (isAppFocused
                ? isAccent
                    ? CXTheme.white
                    : CXTheme.black
                : CXTheme.grey)
            : (isAppFocused ? CXTheme.black : CXTheme.grey))
        : (isAppFocused ? CXTheme.white : CXTheme.grey);
  }

  Color getSidebarColorBackground(bool isSelected, bool isAccent) {
    return isLight
        ? (isSelected
            ? (isAppFocused
                ? isAccent
                    ? accent
                    : CXTheme.grey80
                : CXTheme.grey80)
            : CXTheme.transparent)
        : (isSelected
            ? (isAppFocused
                ? isAccent
                    ? accent
                    : CXTheme.grey700
                : CXTheme.grey800)
            : CXTheme.transparent);
  }
}
