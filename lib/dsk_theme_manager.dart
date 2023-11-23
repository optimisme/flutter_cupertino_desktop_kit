import 'package:flutter/cupertino.dart';
import 'dsk_theme_colors.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKThemeManager extends ChangeNotifier {
  bool isLight = true;
  bool isAppFocused = true;
  String appearanceConfig = "system"; // light, dark, system
  String themeColor = "systemBlue";
  Function? forceUpdateCallback;

  // Instància única del singleton
  static final DSKThemeManager _instance = DSKThemeManager._internal();

  // Constructor privat per crear la instància única
  DSKThemeManager._internal();

  // Mètode estàtic per obtenir la instància del singleton
  factory DSKThemeManager() {
    return _instance;
  }

  CupertinoThemeData getThemeData(BuildContext context) {
    String appearance = setAppearance(context, appearanceConfig, notify: false);

    // Set accent color
    DSKColors.initColors(themeColor);
    CupertinoThemeData baseTheme =
        CupertinoThemeData(primaryColor: DSKColors.systemColors[themeColor]);

    // Set light/dark appearance colors and return theme
    if (appearance == "light") {
      return baseTheme.copyWith(brightness: Brightness.light);
    } else {
      return baseTheme.copyWith(brightness: Brightness.dark);
    }
  }

  void setAccentColour(String name) {
    Color? color = DSKColors.systemColors[name];
    themeColor = name;

    if (color == null) {
      color = DSKColors.systemColors["systemBlue"];
      themeColor = "systemBlue";
    }

    DSKColors.initColors(themeColor);
    notifyListeners();
    forceUpdateCallback?.call();
  }

  void setAppFocus(bool value) {
    isAppFocused = value;
    notifyListeners();
    forceUpdateCallback?.call();
  }

  String setAppearance(BuildContext context, String type,
      {bool notify = true}) {
    String appearance = type;

    // Set accent color
    DSKColors.initColors(themeColor);

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
    } else {
      isLight = false;
      DSKColors.background = const Color.fromARGB(255, 24, 20, 20);
      DSKColors.backgroundSecondary0 = const Color.fromRGBO(95, 95, 95, 1);
      DSKColors.backgroundSecondary1 = const Color.fromRGBO(55, 55, 55, 1);
      DSKColors.text = CupertinoColors.white;
    }

    if (notify) {
      notifyListeners();
      forceUpdateCallback?.call();
    }

    return appearance;
  }
}
