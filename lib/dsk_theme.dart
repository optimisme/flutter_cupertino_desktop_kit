import 'package:flutter/cupertino.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKTheme extends ChangeNotifier {
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
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFFF0000);
  static const Color green = Color(0xFF00FF00);
  static const Color yellow = Color(0xFFFFFF00);
  static const Color blue = Color(0xFF0000FF);

  static const Color grey50 = Color(0xffe7e7e8);
  static const Color grey75 = Color(0xffd8d8da);
  static const Color grey100 = Color(0xffbababd);
  static const Color grey200 = Color(0xffacacaf);
  static const Color grey300 = Color(0xff9d9da1);
  static const Color grey = CupertinoColors.systemGrey;
  static const Color grey500 = Color(0xff7f7f85);
  static const Color grey600 = Color(0xff717176);
  static const Color grey700 = Color(0xff636367);

  // Default colors for bacground and text (modified by dark/light mode)
  Color background = CupertinoColors.white;
  Color backgroundSecondary0 = CupertinoColors.white;
  Color backgroundSecondary1 = CupertinoColors.systemGrey5;
  Color text = CupertinoColors.black;

  // Modified programatically
  Color accent50 = const Color(0xff83bcfc);
  Color accent100 = const Color(0xff51a2fb);
  Color accent200 = const Color(0xff3895fa);
  Color accent300 = const Color(0xff1f87fa);
  Color accent = CupertinoColors.systemBlue;
  Color accent500 = const Color(0xff056ee0);
  Color accent600 = const Color(0xff0562c7);

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
      return baseTheme.copyWith(brightness: Brightness.light);
    } else {
      return baseTheme.copyWith(brightness: Brightness.dark);
    }
  }

  void setAppFocus(bool value) {
    isAppFocused = value;
    notifyListeners();
  }

  void addPostFrameCallback(
      BuildContext context, String defaultAppearance, String colorName) {
    setAppearanceConfig(context, type: defaultAppearance, notify: false);
    setAccentColour(colorName);
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
      text = CupertinoColors.black;
    } else {
      isLight = false;
      background = const Color.fromARGB(255, 24, 20, 20);
      backgroundSecondary0 = const Color.fromRGBO(95, 95, 95, 1);
      backgroundSecondary1 = const Color.fromRGBO(55, 55, 55, 1);
      text = CupertinoColors.white;
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

    /* How grey colors where obtained:
    // Original set of grey colors
    Color greyColor = grey;
    grey50 = adjustColor(greyColor, 1, 1.6);
    grey75 = adjustColor(greyColor, 1, 1.5);
    grey100 = adjustColor(greyColor, 1, 1.3);
    grey200 = adjustColor(greyColor, 1, 1.2);
    grey300 = adjustColor(greyColor, 1, 1.1);
    accent = color;
    grey500 = adjustColor(greyColor, 1, 0.9);
    grey600 = adjustColor(greyColor, 1, 0.8);
    grey700 = adjustColor(greyColor, 1, 0.7);*/
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
}
