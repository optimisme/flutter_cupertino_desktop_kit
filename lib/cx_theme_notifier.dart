import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/cx_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// To notify widgets of theme changes
class CXThemeNotifier extends InheritedWidget {
  final CXTheme changeNotifier;

  const CXThemeNotifier({
    Key? key,
    required Widget child,
    required this.changeNotifier,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CXThemeNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CXThemeNotifier>();
  }
}
