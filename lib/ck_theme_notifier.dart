import 'package:flutter/cupertino.dart';
import 'ck_theme.dart';

// Copyright © 2023 Albert Palacios. All Rights Reserved.
// Licensed under the BSD 3-clause license, see LICENSE file for details.

// To notify widgets of theme changes
class CKThemeNotifier extends InheritedWidget {
  final CKTheme changeNotifier;

  const CKThemeNotifier({
    Key? key,
    required Widget child,
    required this.changeNotifier,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CKThemeNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CKThemeNotifier>();
  }
}
