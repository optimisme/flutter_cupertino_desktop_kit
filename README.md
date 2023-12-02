# Flutter Cupertino Desktop Kit (CDK)

This project, defines Flutter widgets for Desktop, providing a macOS style aesthetic, built upon the foundation of Cupertino widgets.

The goal is to be able to develop applications for all desktop systems, including the web, filling in the gaps in the Cupertino theme.

The CDK prefix strives to be distinctive within the Flutter ecosystem, while remaining concise and suggestive of Flutter Desktop and macOS AppKit. In doing so, it captures the essence of the project.

## Getting Started

The project itself is just a set of libraries that define and manage widgets. However, it includes an example of how to use them. The example can be seen on this website:

[CDK toolkit web Example](https://optimisme.github.io/flutter_cupertino_desktop_kit/gh-pages/example/)

[CDK library documentation](https://optimisme.github.io/flutter_cupertino_desktop_kit/gh-pages/doc/)

![CDK toolkit example](https://optimisme.github.io/flutter_cupertino_desktop_kit/demo_image.png)
<img src="/flutter_cupertino_desktop_kit/demo_image.png" alt="CDK Example" style="max-width: 500px; width: 100%;">

### Add the library as a dependency at pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_cupertino_desktop_kit: ">= 0.0.1 < 999.0.0"
```

### Import the library

```dart
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
```

Then
```bash
flutter pub get
flutter pub upgrade
```

### Use it
```dart
return const CDKApp(
    defaultAppearance: "system", // system, light, dark
    defaultColor:
        "systemBlue", 
    child: LayoutDesktop(title: "App Desktop Title"));
```

## Run the example as a local app:

```bash
cd example
flutter create .
flutter run
```

Create the project if necessary
```bash
flutter create . --template=package
rm lib/flutter_cupertino_desktop_kit.dart
rm -r test
cd example
flutter create . --platform macos # Or the platform of your choice
flutter run -d macos --enable-impeller
```