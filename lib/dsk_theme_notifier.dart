import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// To notify widgets of theme changes
class DSKThemeNotifier extends InheritedWidget {
  final DSKTheme changeNotifier;

  const DSKThemeNotifier({
    Key? key,
    required Widget child,
    required this.changeNotifier,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static DSKThemeNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DSKThemeNotifier>();
  }
}
