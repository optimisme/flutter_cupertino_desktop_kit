import 'package:example/layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_desktop_kit/flutter_cupertino_desktop_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Example layout renders', (WidgetTester tester) async {
    final theme = CDKTheme()..setAccentColour('systemBlue');

    await tester.pumpWidget(
      CDKThemeNotifier(
        changeNotifier: theme,
        child: const CupertinoApp(
          home: Layout(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(Layout), findsOneWidget);
    expect(find.text('Introduction'), findsWidgets);
  });
}
