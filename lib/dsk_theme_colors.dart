import 'package:flutter/cupertino.dart';
// https://api.flutter.dev/flutter/cupertino/CupertinoColors-class.html

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

class DSKColors {
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFFF0000);
  static const Color green = Color(0xFF00FF00);
  static const Color yellow = Color(0xFFFFFF00);
  static const Color blue = Color(0xFF0000FF);

  // Default colors for bacground and text (modified by dark/light mode)
  static Color background = CupertinoColors.white;
  static Color backgroundSecondary0 = CupertinoColors.white;
  static Color backgroundSecondary1 = CupertinoColors.systemGrey5;
  static Color text = CupertinoColors.black;

  // Modified programatically
  static Color accent50 = const Color(0xff83bcfc);
  static Color accent100 = const Color(0xff51a2fb);
  static Color accent200 = const Color(0xff3895fa);
  static Color accent300 = const Color(0xff1f87fa);
  static Color accent = CupertinoColors.systemBlue;
  static Color accent500 = const Color(0xff056ee0);
  static Color accent600 = const Color(0xff0562c7);
  static const Color grey50 = Color(0xffe7e7e8);
  static const Color grey75 = Color(0xffd8d8da);
  static const Color grey100 = Color(0xffbababd);
  static const Color grey200 = Color(0xffacacaf);
  static const Color grey300 = Color(0xff9d9da1);
  static const Color grey = CupertinoColors.systemGrey;
  static const Color grey500 = Color(0xff7f7f85);
  static const Color grey600 = Color(0xff717176);
  static const Color grey700 = Color(0xff636367);

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

  static void initColors(themeColor) {
    Color? color = systemColors[themeColor];

    color = DSKColors.adjustColor(color!, 0.95, 1);
    DSKColors.accent50 = DSKColors.adjustColor(color, 1, 1.5);
    DSKColors.accent100 = DSKColors.adjustColor(color, 1, 1.3);
    DSKColors.accent200 = DSKColors.adjustColor(color, 1, 1.2);
    DSKColors.accent300 = DSKColors.adjustColor(color, 1, 1.1);
    DSKColors.accent = color;
    DSKColors.accent500 = DSKColors.adjustColor(color, 1, 0.9);
    DSKColors.accent600 = DSKColors.adjustColor(color, 1, 0.8);

    /* Original set of grey colors
    Color greyColor = VNTColors.grey;
    VNTColors.grey50 = VNTColors.adjustColor(greyColor, 1, 1.6);
    VNTColors.grey75 = VNTColors.adjustColor(greyColor, 1, 1.5);
    VNTColors.grey100 = VNTColors.adjustColor(greyColor, 1, 1.3);
    VNTColors.grey200 = VNTColors.adjustColor(greyColor, 1, 1.2);
    VNTColors.grey300 = VNTColors.adjustColor(greyColor, 1, 1.1);
    VNTColors.accent = color;
    VNTColors.grey500 = VNTColors.adjustColor(greyColor, 1, 0.9);
    VNTColors.grey600 = VNTColors.adjustColor(greyColor, 1, 0.8);
    VNTColors.grey700 = VNTColors.adjustColor(greyColor, 1, 0.7);
    */
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
