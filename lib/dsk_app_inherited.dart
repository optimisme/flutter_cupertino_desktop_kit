
import 'package:flutter/cupertino.dart';
import 'package:flutter_desktop_cupertino/dsk_theme_manager.dart';

// To notify widgets of theme changes
class DSKAppInheritedWidget extends InheritedWidget {
  final DSKThemeManager changeNotifier;

  const DSKAppInheritedWidget({
    Key? key,
    required Widget child,
    required this.changeNotifier,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static DSKAppInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DSKAppInheritedWidget>();
  }
}
