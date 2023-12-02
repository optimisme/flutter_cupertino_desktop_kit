import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:window_manager/window_manager.dart';
import 'layout.dart';

void main() async {
  // For Linux, macOS and Windows, initialize WindowManager
  try {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      WidgetsFlutterBinding.ensureInitialized();
      await WindowManager.instance.ensureInitialized();
      windowManager.waitUntilReadyToShow().then(showWindow);
    }
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }

  runApp(const CDKApp(
    defaultAppearance: "system", // system, light, dark
    defaultColor:
        "systemBlue", // systemBlue, systemPurple, systemPink, systemRed, systemOrange, systemYellow, systemGreen, systemGray
    child: Layout(),
  ));
}

// Show the window when it's ready
void showWindow(_) async {
  const size = Size(800.0, 600.0);
  windowManager.setSize(size);
  windowManager.setMinimumSize(size);
  await windowManager.setTitle('Example App');
}
